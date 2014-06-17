package ninedays.loading.items
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;

    public class SoundItem extends LoaderItem
    {
        private var _sound:Sound;
		
		public function SoundItem(url:String, id:String)
		{
			super(url, id);	
		}

        private function addListeners():void
        {
            _sound.addEventListener(ProgressEvent.PROGRESS, onProgressHandler);
            _sound.addEventListener(Event.COMPLETE, completeHandler);
            _sound.addEventListener(IOErrorEvent.IO_ERROR, onErrorHandler);
            _sound.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onErrorHandler);
        }

        override protected function removeListeners():void
        {
            _sound.removeEventListener(ProgressEvent.PROGRESS, onProgressHandler);
            _sound.removeEventListener(Event.COMPLETE, completeHandler);
            _sound.removeEventListener(IOErrorEvent.IO_ERROR, onErrorHandler);
            _sound.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onErrorHandler);
        }
		
		override protected function onErrorHandler(event:Event):void
		{
			_sound.close();
			super.onErrorHandler(event);
		}


        private function completeHandler(event:Event):void
        {
            removeListeners();
            complete();
        }

        override protected function startLoad():void
        {
            _sound = new Sound();
            addListeners();
            var request:URLRequest = new URLRequest(_url);
            request.method = URLRequestMethod.GET;
            try
            {
                _sound.load(request);
            }
            catch (e:Error)
            {
                _sound.close();
            }
        }

        /**
         * 获得Sound
         *
         * @return 
         */
        public function get sound():Sound
        {
            return _sound;
        }
		
		override public function get content():*
		{
			return _sound;
		}
		
		override public function stop():void
		{
			super.stop();
			_sound.close();
		}
		
		override protected function doDestroy():void
		{
			super.doDestroy();
			_sound = null;
		}
    }
}