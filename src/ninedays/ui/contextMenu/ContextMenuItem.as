package ninedays.ui.contextMenu
{
	public class ContextMenuItem
	{
		/**指定上下文菜单中显示的菜单项标题（文本）**/
		public var caption:String;
		/**指示指定的菜单项处于启用状态还是禁用状态**/
		public var separatorBefore:Boolean;
		/**指示指定的菜单项上方是否显示分隔条**/
		public var enabled:Boolean;
		/**指示在显示 Flash Player 上下文菜单时指定菜单项是否可见**/
		public var visible:Boolean;
		/**点击事件**/
		public var handle:Function;
		
		/**
		 * 可以使用 ContextMenuItem 类来创建在 Flash Player 上下文菜单中显示的自定义菜单项
		 * @param caption	指定上下文菜单中显示的菜单项标题（文本）
		 * @param separatorBefore	指示指定的菜单项处于启用状态还是禁用状态
		 * @param enabled	指示指定的菜单项上方是否显示分隔条
		 * @param visible	指示在显示 Flash Player 上下文菜单时指定菜单项是否可见
		 * 
		 */		
		public function ContextMenuItem(caption:String, handle:Function = null, separatorBefore:Boolean = false, enabled:Boolean = true, visible:Boolean = true)
		{
			this.caption = caption;
			this.handle = handle;
			this.separatorBefore = separatorBefore;
			this.enabled = enabled;
			this.visible = visible;
		}
		
		public function clone():ContextMenuItem
		{
			return new ContextMenuItem(caption, handle, separatorBefore, enabled, visible);
		}
	}
}