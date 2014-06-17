package ninedays.component
{
	import flash.events.MouseEvent;
	
	import ninedays.display.mediator.IButtonSelectable;

	public class ToggleButton extends Button implements IButtonSelectable
	{
		protected var _selected:Boolean;

		public function ToggleButton()
		{
			super();
		}

		public function set selected(value:Boolean):void
		{
			if (value != _selected)
			{
				value ? toMouseDownState() : toMouseUpState();

				_selected = value;
			}
		}

		public function get selected():Boolean
		{
			return _selected;
		}


		override protected function mouseHandle(e:MouseEvent):void
		{
			if (e.type == MouseEvent.MOUSE_UP)
			{
				selected = !selected;
			}
			else
			{
				super.mouseHandle(e);
			}
		}


		override protected function toMouseOverState():void
		{
			if (_selected == false)
				super.toMouseOverState();
		}


		override protected function toMouseOutState():void
		{
			if (_selected == false)
				super.toMouseOutState();
		}
	}
}
