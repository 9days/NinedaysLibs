package ninedays.managers
{
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	import ninedays.framework.Global;
	import ninedays.display.IContextMenuPanel;
	import ninedays.display.TextToolTip;
	import ninedays.ui.contextMenu.BaseContextMenuPanel;
	import ninedays.ui.contextMenu.ContextMenu;

	/**
	 * flash右键菜单管理 
	 * @author riggzhuo
	 * 
	 */	
	public class ContextMenuManager
	{
		private static var _instance:ContextMenuManager;
		
		public static function get instance():ContextMenuManager
		{
			return _instance ||= new ContextMenuManager();
		}
		
		
		
		private var _classMap:Dictionary;
		
		private var _targetMap:Dictionary;
		
		private var _currentMenu:IContextMenuPanel;
		
		public function ContextMenuManager()
		{
			Global.layerManager.stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, rightDownHandle, true);
			_classMap = new Dictionary(true);
			_targetMap = new Dictionary();
		}
		
		/**
		 * 
		 * @param target	目标
		 * @param contextMenu	
		 * @param contextMenuClass	显示的contextMenu类，必须实现IContextMenuPanel 接口，为空的话默认是 BaseContextMenuPanel，可以继承BaseContextMenuPanel
		 * 
		 */		
		public function regester(target:InteractiveObject, contextMenu:ContextMenu, contextMenuClass:Class = null):void
		{
			unregester(target);
			
			if(contextMenuClass == null)
				contextMenuClass = BaseContextMenuPanel;
			
			_targetMap[target] = new ContextMenuData(contextMenuClass, contextMenu);
			
			target.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, rightDownHandle);
		}
		
		public function unregester(target:InteractiveObject):void
		{
			target.removeEventListener(MouseEvent.RIGHT_MOUSE_DOWN, rightDownHandle);
			_targetMap[target] = null;
			delete _targetMap[target];
		}
		
		private function rightDownHandle(event:MouseEvent):void
		{
			hideMenu();
			showMenu(event.currentTarget as InteractiveObject);
		}
		
		private function showMenu(target:InteractiveObject):void
		{
			var contentMenuData:ContextMenuData = _targetMap[target] as ContextMenuData;
			
			if(contentMenuData)
			{
				_currentMenu = _classMap[getQualifiedClassName(contentMenuData.clazz)] as IContextMenuPanel;
				if(_currentMenu == null)
				{
					_currentMenu = _classMap[getQualifiedClassName(contentMenuData.clazz)] = new contentMenuData.clazz() as IContextMenuPanel;
				}
				
				_currentMenu.initContextMenu(contentMenuData.contextMenu);
				_currentMenu.show(Global.layerManager.contextMenuLayer);
				Global.layerManager.stage.addEventListener(MouseEvent.MOUSE_DOWN, onStageDownHandle);
			}
		}
		
		private function hideMenu():void
		{
			if(_currentMenu)
			{
				_currentMenu.hide();
				Global.layerManager.stage.removeEventListener(MouseEvent.MOUSE_DOWN, onStageDownHandle);
			}
		}
		
		private function onStageDownHandle(event:MouseEvent):void
		{
			if (_currentMenu)
			{
				if ((_currentMenu as Sprite).contains(event.target as DisplayObject) == false)
				{
					hideMenu();
				}
			}
		}
	}
}


import ninedays.ui.contextMenu.ContextMenu;

class ContextMenuData
{
	public var clazz:Class;
	public var contextMenu:ContextMenu;
	
	public function ContextMenuData(clazz:Class, contextMenu:ContextMenu)
	{
		this.clazz = clazz;
		this.contextMenu = contextMenu;
	}
}