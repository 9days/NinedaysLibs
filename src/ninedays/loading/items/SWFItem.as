package ninedays.loading.items
{
    import flash.display.BitmapData;
    import flash.display.Loader;
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.media.Sound;
    import flash.system.ApplicationDomain;
    import flash.system.ImageDecodingPolicy;
    import flash.system.LoaderContext;

    public class SWFItem extends BinaryItem
    {
        protected var _toCurrentApplicationDomain:Boolean;

        protected var _loader:Loader;

        private var _domain:ApplicationDomain;

        public function SWFItem(url:String, id:String, toCurrentApplicationDomain:Boolean = false)
        {
            _toCurrentApplicationDomain = toCurrentApplicationDomain;
            super(url, id);
        }


        override protected function decode():void
        {
            _loader = new Loader();
            var context:LoaderContext = new LoaderContext();
            if (_toCurrentApplicationDomain)
            {
                context.applicationDomain = ApplicationDomain.currentDomain;
            }
            context.allowCodeImport = true;
            context.imageDecodingPolicy = ImageDecodingPolicy.ON_LOAD;
            _loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
            _loader.loadBytes(_data, context);
        }

        protected function completeHandler(event:Event):void
        {
            _domain = _loader.contentLoaderInfo.applicationDomain;
            _loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, completeHandler);
            _data.clear();
            complete();
        }

        /**
         * getClass 从SWF中获得类
         *
         * @param className 类名称
         * @return Class 类
         */
        public function getClass(className:String):Class
        {
			if(_domain == null)
			{
				return null;
			}
			
            if (!_domain.hasDefinition(className))
            {
                return null;
            }
            var assetClass:Class = _domain.getDefinition(className) as Class;
            return assetClass;
        }

        /**
         * 获得Sprite
         *
         * @param className 元件定义
         * @return Sprite
         */
        public function getSprite(className:String):Sprite
        {
            var assetClass:Class = getClass(className);
            if (assetClass == null)
            {
                return null;
            }
            return (new assetClass() as Sprite);
        }

        /**
         * 获得MovieClip
         *
         * @param className 元件定义
         * @return Movilip
         */
        public function getMovieClip(className:String):MovieClip
        {
            var assetClass:Class = getClass(className);
            if (assetClass == null)
            {
                return null;
            }
            var mc:MovieClip = new assetClass() as MovieClip;
            if (mc != null)
            {
                mc.stop();
            }
            return mc;
        }

        /**
         * 获得BitmapData
         *
         * @param className 元件定义
         * @return Bitmapta 位图
         */
        public function getBitmapData(className:String):BitmapData
        {
            var assetClass:Class = getClass(className);
            if (assetClass == null)
            {
                return null;
            }
            var bd:BitmapData = new assetClass() as BitmapData;
            return bd;
        }

        /**
         * 获得Sound
         *
         * @param className 元件定义
         * @return Sound
         */
        public function getSound(className:String):Sound
        {
            var assetClass:Class = getClass(className);
            if (assetClass == null)
                return null;
            var sound:Sound = new assetClass() as Sound;
            return sound;
        }
		
		override public function get content():*
		{
			if(_loader)
			{
				return _loader.content;
			}
			return null;
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
			_domain = null;
        }
    }
}