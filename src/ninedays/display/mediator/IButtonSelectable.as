package ninedays.display.mediator
{
	import flash.events.IEventDispatcher;

	public interface IButtonSelectable extends IEventDispatcher
	{
		function get selected():Boolean;
		
		function set selected(value:Boolean):void;
	}
}