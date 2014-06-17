package ninedays.component.defaultSkin
{
	import flash.display.Graphics;
	import flash.display.Shape;
	
	import ninedays.component.BaseButton;
	import ninedays.component.Button;
	
	public class DefaultScrollArrowUp extends Button
	{
		protected var triangle:Shape;
		
		/**
		 * 创建孩子
		 */
		override protected function creatChildren():void
		{
			super.creatChildren();
			triangle = new Shape();
			var g:Graphics = triangle.graphics;
			g.clear();
			g.lineStyle(0.2);
			g.beginFill(0);
			g.moveTo(5, 3);
			g.lineTo(3, 6.5);
			g.lineTo(7, 6.5);
			g.endFill();
			addChild(triangle);
		}
		
		override public function draw():void
		{
			super.draw();
			
			triangle.width = _width * .4;
			triangle.height = _height * .4;
		}
	}
}