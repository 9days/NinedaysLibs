package ninedays.display
{
	import flash.display.Sprite;
	
	import ninedays.core.IDestroyable;
	
	public interface IMediator extends IDestroyable
	{
		function set mainUI(ui:Sprite):void;
		
		function get children():Vector.<IMediator>;
	}
}