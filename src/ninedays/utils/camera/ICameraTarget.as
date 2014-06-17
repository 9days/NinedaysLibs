package ninedays.utils.camera
{
	import flash.geom.Rectangle;

	public interface ICameraTarget
	{
		function get contentWidth():int;
		function get contentHeight():int;
		
		function get viewWidth():int;
		function get viewHeight():int;
		
		function get scrollRect():Rectangle;
		function set scrollRect(value:Rectangle):void;
	}
}