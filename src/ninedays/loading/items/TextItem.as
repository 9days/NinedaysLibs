package ninedays.loading.items
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;

	public class TextItem extends LoaderItem
	{
		protected var _urlLoder:URLLoader;
		protected var _content:String;
		
		public function TextItem(url:String, id:String)
		{
			super(url, id);	
		}
		
		private function addListeners():void
		{
			_urlLoder.addEventListener(ProgressEvent.PROGRESS, onProgressHandler);
			_urlLoder.addEventListener(Event.COMPLETE, completeHandler);
			_urlLoder.addEventListener(IOErrorEvent.IO_ERROR, onErrorHandler);
			_urlLoder.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onErrorHandler);
		}
		
		override protected function removeListeners():void
		{
			_urlLoder.removeEventListener(ProgressEvent.PROGRESS, onProgressHandler);
			_urlLoder.removeEventListener(Event.COMPLETE, completeHandler);
			_urlLoder.removeEventListener(IOErrorEvent.IO_ERROR, onErrorHandler);
			_urlLoder.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onErrorHandler);
		}
		
		
		private function completeHandler(event:Event):void
		{
			removeListeners();
			_content = _urlLoder.data;
			decode();
		}
		
		protected function decode():void
		{
			complete();
		}
		
		override protected function startLoad():void
		{
			_urlLoder = new URLLoader();
			addListeners();
			_urlLoder.dataFormat = URLLoaderDataFormat.TEXT;
			_urlLoder.load(new URLRequest(_url));
		}
		
		override public function get content():*
		{
			return _content;
		}
	}
}