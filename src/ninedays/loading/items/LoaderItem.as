package ninedays.loading.items
{
    import flash.events.ErrorEvent;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.HTTPStatusEvent;
    import flash.events.IEventDispatcher;
    import flash.events.ProgressEvent;
    
    import ninedays.command.Command;
    import ninedays.loading.ILoaderItem;

    public class LoaderItem extends Command implements ILoaderItem
    {
        protected var _url:String;

        protected var _onLoaded:Function;

        protected var _onProgress:Function;

        protected var _onFailed:Function;

		protected var _bytesTotal:int = 0;

		protected var _bytesLoaded:int = 0;

        public function LoaderItem(url:String, id:String)
        {
            _url = url;
            _id = id;
        }

        public function load():void
        {
            execute();
        }

        override protected function doExecute():void
        {
            startLoad();
        }

        protected function startLoad():void
        {
        }

        override public function complete():void
        {
            if (_onLoaded != null)
            {
                _onLoaded();
            }
			super.complete();
        }

        override public function fault():void
        {
            if (_onFailed != null)
            {
                _onFailed();
            }
			super.fault();
        }

        public function get bytesTotal():int
        {
            return _bytesTotal;
        }

        public function get bytesLoaded():int
        {
            return _bytesLoaded;
        }

		public function get content():*
		{
			return null;
		}

        public function set onLoaded(value:Function):void
        {
            _onLoaded = value;
        }

        public function set onFailed(value:Function):void
        {
            _onFailed = value;
        }

        public function set onProgress(value:Function):void
        {
			_onProgress = value;
        }

		protected function onProgressHandler(event:ProgressEvent):void
        {
            _bytesLoaded = event.bytesLoaded;
            _bytesTotal = event.bytesTotal;
			
			if(_onProgress != null)
			{
				_onProgress(_bytesLoaded, _bytesTotal);
			}
			
            dispatchEvent(event);
        }

		protected function onErrorHandler(event:Event):void
        {
            fault();
        }

        protected function removeListeners():void
        {
        }

        public function stop():void
        {
			_stutus = WAIT;
        }

        override protected function doDestroy():void
        {
            removeListeners();
            stop();
			super.doDestroy();
        }
    }
}