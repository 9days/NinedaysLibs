package ninedays.framework
{
	import ninedays.managers.LayerManager;

	public class Global
	{
		private static var _layerManager:ILayerManager;
		
		public static function set layerManager(value:ILayerManager):void
		{
			_layerManager = value;
		}
		
		public static function get layerManager():ILayerManager
		{
			return _layerManager;
		}
	}
}