package ninedays.ui.contextMenu
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import ninedays.utils.DisplayObjectUtil;
	
	public class BaseContextMenuPanelItem extends Sprite
	{
		protected var _overState:Shape;
		protected var _textField:TextField;
		protected var _enabled:Boolean;
		protected var _data:ContextMenuItem;
		
		public function BaseContextMenuPanelItem()
		{
			_textField = new TextField();
			_textField.defaultTextFormat = new TextFormat(null, 12);
			_textField.height = 20;
			_textField.x = 5;
			addChild(_textField);
			
			_overState = new Shape();
			_overState.graphics.beginFill(0x0000FF, .1);
			_overState.graphics.drawRoundRect(0, 0, 100, 20, 5, 5);
			_overState.graphics.endFill();
			_overState.scale9Grid = new Rectangle(10, 10, 80, 5);
			addChild(_overState);
			_overState.visible = false;
			
			mouseChildren = false;
			buttonMode = true;
			
			addEventListener(MouseEvent.ROLL_OVER, overHandle);
			addEventListener(MouseEvent.ROLL_OUT, outHandle);
		}
		
		public function set itemWidth(value:int):void
		{
			_overState.width = value;
			_textField.width = value;
		}
		
		public function set data(value:ContextMenuItem):void
		{
			_data = value;
			_textField.htmlText = value.caption;	
		}
		
		public function get data():ContextMenuItem
		{
			return _data;
		}
		
		public function set enabled(value:Boolean):void
		{
			
		}
		
		protected function overHandle(event:MouseEvent):void
		{
			_overState.visible = true;
		}
		
		protected function outHandle(event:MouseEvent):void
		{
			_overState.visible = false;
		}
		
		public function destroy():void
		{
			DisplayObjectUtil.removeAllChildren(this);
			removeEventListener(MouseEvent.ROLL_OVER, overHandle);
			removeEventListener(MouseEvent.ROLL_OUT, outHandle);
		}
	}
}