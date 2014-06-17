package ninedays.component.defaultSkin
{
    import flash.display.Graphics;
    import flash.display.Shape;
    
    import ninedays.component.Button;

    public class DefaultScrollThumb extends Button
    {
        protected var thumb:Shape;

        /**
         * 创建孩子
         */
        override protected function creatChildren():void
        {
            super.creatChildren();
            thumb = new Shape();
            var g:Graphics = thumb.graphics;
            g.clear();
            g.lineStyle(1);
            g.moveTo(0, 0);
            g.lineTo(10, 0);
            g.moveTo(0, 2);
            g.lineTo(10, 2);
            g.moveTo(0, 4);
            g.lineTo(10, 4);
            addChild(thumb);
        }

        override public function draw():void
        {
            super.draw();

            thumb.width = _width;
            thumb.y = _height - 6 >> 1;
        }
    }
}