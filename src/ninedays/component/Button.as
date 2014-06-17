package ninedays.component
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class Button extends BaseButton
	{
		protected var background:Shape;
		
		/**显示的文本**/
		protected var textField:TextField;
		
		
		public function Button()
		{
			_width = 100;
			_height = 25;
			this.buttonMode = true;
		}
		
		
		/**
		 * 创建孩子
		 */
		override protected function creatChildren():void
		{
			super.creatChildren();
			creatBackground();
			creatTextField();
		}
		
		protected function creatBackground():void
		{
			background = new Shape();
			addChild(background);
			setShape(background.graphics, int(getStyle("upColor")));
		}
		
		protected function setShape(g:Graphics, color:uint):void
		{
			g.clear();
			g.lineStyle(0.2);
			g.beginFill(color);
			g.drawRect(0, 0, 10, 10);
			g.endFill();
		}
		
		/**
		 * 创建文本
		 */
		protected function creatTextField():void
		{
			textField = new TextField();
			textField.x = 5;
			textField.height = 20;
			addChild(textField);
			
			textField.mouseEnabled = false;
		}
		
		override protected function toMouseDownState():void
		{
			super.toMouseDownState();
			setShape(background.graphics, int(getStyle("downColor")));
		}
		
		override protected function toMouseUpState():void
		{
			super.toMouseUpState();
			setShape(background.graphics, int(getStyle("upColor")));
		}
		
		override protected function toMouseOverState():void
		{
			super.toMouseOverState();
			setShape(background.graphics, int(getStyle("overColor")));
		}
		
		override protected function toMouseOutState():void
		{
			super.toMouseOutState();
			setShape(background.graphics, int(getStyle("upColor")));
		}
		
		/**
		 * 文本值
		 */
		public function get label():String
		{
			return textField.text;
		}
		
		public function set label(value:String):void
		{
			if(textField == null)
			{
				creatChildren();
				addListeners();
			}
			textField.text = value;
			textField.width = textField.textWidth + 3;
		}
		
		override public function draw():void
		{
			super.draw();
			drawLayout();
		}
		
		protected function drawLayout():void
		{
			background.width = _width;
			background.height = _height;
			
			textField.width = _width - textField.x;
			textField.x = int(getStyle("textPadding"));
			textField.y = _height - 20 >> 1;
		}
		
		/**
		 * 宽度
		 */
		public function get itemWidth():uint
		{
			return _width;
		}
		
		public function set itemWidth(value:uint):void
		{
			_width = value;
			setSize(_width, _height);
		}
		
		/**
		 * 高度
		 */
		public function get itemHeight():uint
		{
			return _height;
		}
		
		public function set itemHeight(value:uint):void
		{
			_height = value;
			setSize(_width, _height);
		}
	}
}
