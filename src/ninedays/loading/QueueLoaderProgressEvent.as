package ninedays.loading
{
    import flash.events.Event;
    
    import ninedays.loading.items.LoaderItem;

    public class QueueLoaderProgressEvent extends Event
    {
        public static const PROGRESS:String = "progress";

        public var loadingLoader:LoaderItem;

        public var bytesLoaded:Number;

        public var bytesTotal:Number;

        public function QueueLoaderProgressEvent(loadingLoader:LoaderItem, bytesLoaded:Number = 0, bytesTotal:Number = 0)
        {
			this.loadingLoader = loadingLoader;
			this.bytesLoaded = bytesLoaded;
			this.bytesTotal = bytesTotal;
            super(PROGRESS, false, false);
        }

        public function get childBytesLoaded():Number
        {
            return loadingLoader ? loadingLoader.bytesLoaded : 0;
        }

        public function get childBytesTotal():Number
        {
            return loadingLoader ? loadingLoader.bytesTotal : 0;
        }
    }
}