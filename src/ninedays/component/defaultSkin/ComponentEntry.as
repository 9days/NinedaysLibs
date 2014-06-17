package ninedays.component.defaultSkin
{
	import ninedays.component.List;
	import ninedays.component.Button;
	import ninedays.component.Tree;
	import ninedays.component.listClasses.ItemRenderer;
	import ninedays.component.style.DefaultStyle;
	import ninedays.component.style.StyleManager;
	import ninedays.component.treeClasses.TreeItemRenderer;

	public class ComponentEntry
	{
		public function setup():void
		{
			StyleManager.instance.setStyle(DefaultStyle.SCROLL_ARROW_UP, DefaultScrollArrowUp);
			StyleManager.instance.setStyle(DefaultStyle.SCROLL_ARROW_DOWN, DefaultScrollArrowDown);
			StyleManager.instance.setStyle(DefaultStyle.SCROLL_THUMB, DefaultScrollThumb);
			StyleManager.instance.setStyle(DefaultStyle.SCROLL_TRACK, DefaultScrollTrack);
			
			
			StyleManager.instance.setClassDefaultStyle(Button, "textPadding", 5);
			StyleManager.instance.setClassDefaultStyle(Button, "leftMargin", 5);
			StyleManager.instance.setClassDefaultStyle(Button, "upColor", 0xFFFFFF);
			StyleManager.instance.setClassDefaultStyle(Button, "overColor", 0xAADEFF);
			StyleManager.instance.setClassDefaultStyle(Button, "downColor", 0x7FCDFE);
			
			
			StyleManager.instance.setClassDefaultStyle(List, "itemRenderer", ItemRenderer);
			
			
			StyleManager.instance.setClassDefaultStyle(Tree, "itemRenderer", TreeItemRenderer);
			StyleManager.instance.setClassDefaultStyle(TreeItemRenderer, "openBranchIcon", TreeOpenBranchIcon);
			StyleManager.instance.setClassDefaultStyle(TreeItemRenderer, "closeBranchIcon", TreeCloseBranchIcon);
			
			
			StyleManager.instance.setClassDefaultStyle(TreeItemRenderer, "nodeIndent", 10);
		}
	}
}