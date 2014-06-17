package ninedays.loading.items
{
    import flash.events.Event;
    import flash.events.HTTPStatusEvent;
    import flash.events.IOErrorEvent;
    import flash.events.ProgressEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.URLLoaderDataFormat;
    import flash.net.URLRequest;
    import flash.net.URLStream;
    import flash.utils.ByteArray;

    public class BinaryItem extends LoaderItem
    {
        protected var _stream:URLStream;

        protected var _data:ByteArray;

        public function BinaryItem(url:String, id:String)
        {
            super(url, id);
        }

        override protected function startLoad():void
        {
            _stream = new URLStream();
            _stream.addEventListener(ProgressEvent.PROGRESS, onProgressHandler, false, 0, true);
            _stream.addEventListener(Event.COMPLETE, onCompleteHandler, false, 0, true);
            _stream.addEventListener(IOErrorEvent.IO_ERROR, onErrorHandler, false, 0, true);
            _stream.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onErrorHandler, false, 0, true);
            try
            {
                _stream.load(new URLRequest(_url));
            }
            catch (e:SecurityError)
            {
                onErrorHandler(null);
            }
        }

        private function onCompleteHandler(event:Event):void
        {
            _data = new ByteArray();
            _stream.readBytes(_data, 0, _stream.bytesAvailable);
            if (_data.length > 0)
            {
                decode();
            }
            else
            {
                fault();
            }
        }

        protected function decode():void
        {
            complete();
        }

        override protected function removeListeners():void
        {
			super.removeListeners();
			if(_stream)
			{
				_stream.removeEventListener(ProgressEvent.PROGRESS, onProgressHandler);
				_stream.removeEventListener(Event.COMPLETE, onCompleteHandler);
				_stream.removeEventListener(IOErrorEvent.IO_ERROR, onErrorHandler);
				_stream.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onErrorHandler);
			}
        }
		
		override public function get content():*
		{
			return _data;
		}
		
		public function get byteArray():ByteArray
		{
			return _data;
		}

        override public function stop():void
        {
            super.stop();
			if(_stream)
			{
				try
				{
					_stream.close();
				}
				catch (e:Error)
				{
				}
			}
        }

        override protected function doDestroy():void
        {
            super.doDestroy();
            _stream = null;
			_data = null;
        }
    }
}