package ninedays.component.defaultSkin
{
	import flash.display.Shape;
	
	/**
	 * 树展开分支的icon  
	 * @author riggzhuo
	 * 
	 */	
	public class TreeOpenBranchIcon extends Shape
	{
		public function TreeOpenBranchIcon()
		{
			graphics.beginFill(0x999999);
			graphics.moveTo(0, 0);
			graphics.lineTo(10, 0);
			graphics.lineTo(5, 10);
			graphics.endFill();
		}
	}
}