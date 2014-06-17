package ninedays.display
{
	import flash.display.DisplayObjectContainer;

	public interface IToolTip
	{
		function initData(userData:Object):void;
		
		function show(container:DisplayObjectContainer):void;
		
		function hide():void;
		
		function layout():void;
		
		function destroy():void;
	}
}