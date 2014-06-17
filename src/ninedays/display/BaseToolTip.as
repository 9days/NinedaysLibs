package ninedays.display
{
    import flash.display.DisplayObjectContainer;
    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.geom.Rectangle;
    
    import ninedays.framework.Global;
    import ninedays.managers.LayerManager;
    import ninedays.utils.DisplayObjectUtil;

	/**
	 * ToolTip基类 
	 * @author riggzhuo
	 * 
	 */	
    public class BaseToolTip extends Sprite implements IToolTip
    {
        protected var _offsetX:int = 10;

        protected var _offsetY:int = 10;
		
		public function BaseToolTip()
		{
			mouseChildren = false;
			mouseEnabled = false;
		}

        public function initData(userData:Object):void
        {
        }

        public function show(container:DisplayObjectContainer):void
        {
            container.addChild(this);
			layout();
        }

        public function hide():void
        {
            if (parent)
                parent.removeChild(this);
        }

        public function layout():void
        {
            if (!parent)
            {
                return;
            }

            this.x = parent.mouseX + _offsetX;
            this.y = parent.mouseY + _offsetY;
            if (this.x + this.width > stage.stageWidth)
            {
                this.x = parent.mouseX - this.width;
            }
            if (this.y + this.height > stage.stageHeight)
            {
                this.y = parent.mouseY - this.height;
            }
        }

        override public function get stage():Stage
        {
            return super.stage || Global.layerManager.stage;
        }
		
		public function destroy():void
		{
			DisplayObjectUtil.removeForParent(this);
		}
    }
}