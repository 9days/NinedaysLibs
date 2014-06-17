package ninedays.component.defaultSkin
{
    import flash.display.Shape;

	/**
	 * 树关闭分支的icon 
	 * @author riggzhuo
	 * 
	 */	
    public class TreeCloseBranchIcon extends Shape
    {
        public function TreeCloseBranchIcon()
        {
			graphics.beginFill(0x999999);
			graphics.moveTo(0, 0);
			graphics.lineTo(0, 10);
			graphics.lineTo(10, 5);
			graphics.endFill();
        }
    }
}