package ninedays.loading.items
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Loader;
    import flash.events.Event;
    import flash.system.ImageDecodingPolicy;
    import flash.system.LoaderContext;

    public class ImageItem extends BinaryItem
    {
        private var _loader:Loader;

        private var _bitmapData:BitmapData;
		
		public function ImageItem(url:String, id:String)
		{
			super(url, id);	
		}

        override protected function decode():void
        {
            var context:LoaderContext = new LoaderContext();
            context.imageDecodingPolicy = ImageDecodingPolicy.ON_LOAD;

            _loader = new Loader();
            _loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
            _loader.loadBytes(_data, context);
        }

        private function completeHandler(event:Event):void
        {
            _loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, completeHandler);
            _bitmapData = Bitmap(_loader.contentLoaderInfo.content).bitmapData;
            _loader.unloadAndStop();
            _data.clear();
            complete();
        }


        override public function get content():*
        {
            return _bitmapData;
        }

        public function get bitmapData():BitmapData
        {
            return _bitmapData;
        }

        override public function stop():void
        {
            super.stop();
            if (_loader)
            {
                _loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, completeHandler);
                try
                {
                    _loader.close();
                }
                catch (e:Error)
                {
                }
            }
        }

        override protected function doDestroy():void
        {
            super.doDestroy();
			if(_loader)
			{
				_loader.unloadAndStop();
			}
            _loader = null;
        }
    }
}