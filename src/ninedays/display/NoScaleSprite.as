package ninedays.display
{
	import flash.display.Sprite;
	
	public class NoScaleSprite extends Sprite
	{
		protected var _width:int;
		protected var _height:int;
		
		public function NoScaleSprite()
		{
			super();
		}
		
		override public function set scaleX(value:Number):void
		{
		}
		
		override public function set scaleY(value:Number):void
		{
		}
		
		override public function set scaleZ(value:Number):void
		{
		}
		
		override public function get width():Number
		{
			return _width;
		}
		
		override public function set width(value:Number):void
		{
			_width = value;
			onResize();
		}
		
		override public function get height():Number
		{
			return _height;
		}
		
		override public function set height(value:Number):void
		{
			_height = value;
			onResize();
		}
		
		protected function onResize():void
		{
		}
	}
}