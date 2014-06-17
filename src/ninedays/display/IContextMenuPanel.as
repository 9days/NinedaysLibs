package ninedays.display
{
	import flash.display.DisplayObjectContainer;
	
	import ninedays.ui.contextMenu.ContextMenu;

	public interface IContextMenuPanel
	{
		function initContextMenu(contextMenu:ContextMenu):void;
		
		function show(container:DisplayObjectContainer):void;
		
		function hide():void;
		
		function layout():void;
	}
}