package ninedays.controller
{
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import ninedays.framework.Global;
	
	public class StageResizeController
	{
		private static var _instance:StageResizeController;
		public static function get instance():StageResizeController
		{
			return _instance ||= new StageResizeController();
		}
		
		
		private var _map:Vector.<Function>;
		
		public function StageResizeController()
		{
			_map = new Vector.<Function>();
			Global.layerManager.stage.addEventListener(Event.RESIZE, onStageReziseHandle);
		}
		
		private function onStageReziseHandle(event:Event):void
		{
			for each(var handler:Function in _map)
			{
				handler.apply();
			}
		}
		
		public function register(callback:Function):Boolean
		{
			if(_map.indexOf(callback) == -1)
			{
				_map.push(callback);
				return true;
			}
			return false;
		}
		
		public function unregister(callback:Function):Boolean
		{
			var index:int = _map.indexOf(callback);
			if(index != -1)
			{
				_map.splice(index, 1);
				return true;
			}
			return false;
		}
	}
}