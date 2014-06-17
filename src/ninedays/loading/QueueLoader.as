package ninedays.loading
{
    import flash.display.BitmapData;
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.ProgressEvent;
    import flash.media.Sound;
    import flash.utils.ByteArray;
    
    import ninedays.command.ICommand;
    import ninedays.command.Queue;
    import ninedays.loading.items.BinaryItem;
    import ninedays.loading.items.ImageItem;
    import ninedays.loading.items.JSONItem;
    import ninedays.loading.items.LoaderItem;
    import ninedays.loading.items.SWFItem;
    import ninedays.loading.items.SoundItem;
    import ninedays.loading.items.XMLItem;
    import ninedays.utils.StringUtil;

	[Event(name="progress", type="ninedays.loading.QueueLoaderProgressEvent")]
    public class QueueLoader extends Queue
    {
        private static var _customTypesExtensions:Object;

        private static function creat(url:String, id:String, toCurrentApplicationDomain:Boolean):LoaderItem
        {
            var fileType:String = StringUtil.getFileExtension(url);
            var loaderItem:LoaderItem;
            if (fileType == "swf")
            {
                loaderItem = new SWFItem(url, id, toCurrentApplicationDomain);
            }
            else if (fileType == "jpg" || fileType == "jpeg" || fileType == "png" || fileType == "gif")
            {
                loaderItem = new ImageItem(url, id);
            }
            else if (fileType == "xml")
            {
                loaderItem = new XMLItem(url, id);
            }
            else if (fileType == "json")
            {
                loaderItem = new JSONItem(url, id);
            }
            else if (fileType == "mp3")
            {
                loaderItem = new SoundItem(url, id);
            }
            else if (fileType == "binary")
            {
                loaderItem = new BinaryItem(url, id);
            }
            else if (_customTypesExtensions && (fileType in _customTypesExtensions))
            {
                loaderItem = new _customTypesExtensions[fileType](url, id);
            }
            else
            {
                loaderItem = new BinaryItem(url, id);
            }
            return loaderItem;
        }

        /**
         * 注册新类型
         * @param extension	文件后缀名
         * @param withClass	对应的类，需继承自LoaderItem
         * @return
         *
         */
        public static function registerNewType(extension:String, withClass:Class = null):Boolean
        {
            extension = StringUtil.getFileExtension(extension);
            if (_customTypesExtensions == null)
            {
                _customTypesExtensions = {};
            }

            if (extension in _customTypesExtensions)
            {
                return false;
            }

            _customTypesExtensions[extension] = withClass;
            return true;
        }




        public function QueueLoader()
        {
            _maxExecuting = 20;
        }


        public function load(url:String, id:String = null, onLoaded:Function = null, onProgress:Function = null, onFailed:Function = null, toCurrentApplicationDomain:Boolean = false):LoaderItem
        {
            var item:LoaderItem = creat(url, id ? id : url, toCurrentApplicationDomain);

            item.onLoaded = onLoaded;
            item.onProgress = onProgress;
            item.onFailed = onFailed;

            addChild(item);

            if (stutus != EXECUTING)
            {
                execute();
            }

            return item;
        }
		
		override protected function addChildListeners(child:ICommand):void
		{
			child.addEventListener(ProgressEvent.PROGRESS, onChildProgress);
			super.addChildListeners(child);
		}
		
		override protected function removeChildListeners(child:ICommand):void
		{
			child.removeEventListener(ProgressEvent.PROGRESS, onChildProgress);
			super.removeChildListeners(child);
		}
		
		protected function onChildProgress(event:ProgressEvent):void
		{
			dispatchEvent(new QueueLoaderProgressEvent(event.currentTarget as LoaderItem, calculateBytesLoaded(), calculateBytesTotal()));
		}
		
		protected function calculateBytesTotal():Number
		{
			var bytesLoaded:int = 0;
			var loadCount:int = 0;
			for each(var loader:LoaderItem in _children)
			{
				if(loader && loader.bytesTotal > 0)
				{
					bytesLoaded += loader.bytesTotal;
					loadCount++;
				}
			}
			return bytesLoaded / loadCount * _children.length;
		}
		
		protected function calculateBytesLoaded():Number
		{
			var result:Number = 0;
			for each(var loader:LoaderItem in _children)
			{
				if(loader)
				{
					result += loader.bytesLoaded;
				}
			}
			return result;
		}

        public function getLoader(id:String):LoaderItem
        {
            return getChildByID(id) as LoaderItem;
        }

        public function getByteArray(id:String):ByteArray
        {
            var loader:BinaryItem = getChildByID(id) as BinaryItem;
            return loader != null ? loader.byteArray : null;
        }

        public function getImg(id:String):BitmapData
        {
            var loader:ImageItem = getChildByID(id) as ImageItem;
            return loader != null ? loader.bitmapData : null;
        }

        public function getSound(id:String):Sound
        {
            var loader:SoundItem = getChildByID(id) as SoundItem;
            return loader != null ? loader.sound : null;
        }

        public function getXML(id:String):XML
        {
            var loader:XMLItem = getChildByID(id) as XMLItem;
            return loader != null ? loader.xml : null;
        }

        public function getJsonObj(id:String):Object
        {
            var loader:JSONItem = getChildByID(id) as JSONItem;
            return loader != null ? loader.jsonObj : null;
        }

        public function getClass(id:String, lib:String):Class
        {
            var loader:SWFItem = getChildByID(id) as SWFItem;
            return loader != null ? loader.getClass(lib) : null;
        }

        public function getSprite(id:String, lib:String):Sprite
        {
            var loader:SWFItem = getChildByID(id) as SWFItem;
            return loader != null ? loader.getSprite(lib) : null;
        }

        public function getMovieClip(id:String, lib:String):MovieClip
        {
            var loader:SWFItem = getChildByID(id) as SWFItem;
            return loader != null ? loader.getMovieClip(lib) : null;
        }

        public function getBitmapData(id:String, lib:String):BitmapData
        {
            var loader:SWFItem = getChildByID(id) as SWFItem;
            return loader != null ? loader.getBitmapData(lib) : null;
        }

        public function destroyLoaderByID(id:String):Boolean
        {
            var loader:LoaderItem = getLoader(id);
            if (loader)
            {
				destroyLoader(loader);
                return true;
            }
            return false;
        }
		
        public function destroyLoader(loader:LoaderItem):void
        {
            if (loader)
            {
                destroyChildCommand(loader);
				removeChild(loader);
            }
        }
		
		override protected function destroyChildCommand(child:ICommand):void
		{
			(child as ILoaderItem).stop();
			super.destroyChildCommand(child);
		}
		
		public function stop():void
		{
			_stutus = WAIT;
			var executingChildren:Vector.<ICommand> = getExecutingChildren();
			while(executingChildren.length)
			{
				var child:ICommand = executingChildren.pop();
				removeChildListeners(child);
				(child as LoaderItem).stop();
			}
			_executingCount = 0;
		}
    }
}