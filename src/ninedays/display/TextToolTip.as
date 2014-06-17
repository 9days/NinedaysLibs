package ninedays.display
{
    import flash.display.Sprite;
    import flash.geom.Rectangle;
    import flash.text.TextField;

    public class TextToolTip extends BaseToolTip
    {
        protected var backgroud:Sprite;

        protected var label:TextField;

        public function TextToolTip()
        {
            backgroud = new Sprite();
            backgroud.graphics.lineStyle(1);
            backgroud.graphics.beginFill(0XFFFFFF);
            backgroud.graphics.drawRoundRect(0, 0, 100, 100, 10, 10);
            backgroud.graphics.endFill();
            backgroud.scale9Grid = new Rectangle(20, 20, 20, 20);
            addChild(backgroud);

            label = new TextField();
            label.wordWrap = true;
            label.multiline = true;
            label.x = 5;
            label.y = 5;
            addChild(label);
        }

        override public function initData(userData:Object):void
        {
            var tips:String = String(userData);
			
			label.width = 100;
			
            label.htmlText = tips;
            label.width = label.textWidth + 5;
            label.height = label.textHeight + 5;

            backgroud.width = 2 * label.x + label.width;
            backgroud.height = 2 * label.y + label.height;
        }
    }
}