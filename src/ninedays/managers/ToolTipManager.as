package ninedays.managers
{
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import flash.utils.clearTimeout;
	import flash.utils.getQualifiedClassName;
	import flash.utils.setTimeout;
	
	import ninedays.display.IToolTip;
	import ninedays.display.TextToolTip;
	import ninedays.framework.Global;

	public class ToolTipManager
	{
		private static var _classMap:Dictionary  = new Dictionary();
		
		private static var _classCountMap:Dictionary = new Dictionary();
		
		private static var _targetMap:Dictionary = new Dictionary();
		
		private static var _delayTimer:int;
		
		/**
		 * 注册 
		 * @param target	目标
		 * @param userData	用户数据
		 * @param tooltipClass	显示的tooltip类，必须实现IToolTip 接口，为空的话默认是 TextToolTip，可以继承BaseToolTip
		 * @param delay	延迟，单位ms
		 * 
		 */		
		public static function regester(target:InteractiveObject, userData:Object, tooltipClass:Class = null, delay:int = 200):void
		{
			unregester(target);
			
			if(tooltipClass == null)
				tooltipClass = TextToolTip;
			
			_targetMap[target] = new TipData(tooltipClass, userData, delay);
			
			target.addEventListener(MouseEvent.ROLL_OVER, overHandle);
			target.addEventListener(MouseEvent.ROLL_OUT, outHandle);
			
			var count:int = int(_classCountMap[getQualifiedClassName(tooltipClass)]);
			_classCountMap[getQualifiedClassName(tooltipClass)] = ++count;
		}
		
		public static function unregester(target:InteractiveObject):void
		{
			target.removeEventListener(MouseEvent.ROLL_OVER, overHandle);
			target.removeEventListener(MouseEvent.ROLL_OUT, outHandle);
			target.removeEventListener(MouseEvent.MOUSE_MOVE, moveHandle);
			
			var tipData:TipData = _targetMap[target] as TipData;
			
			if(tipData)
			{
				_targetMap[target] = null;
				delete _targetMap[target];
				
				var className:String = getQualifiedClassName(tipData.clazz);
				
				var tooltipInstance:IToolTip = _classMap[className] as IToolTip;
				if(tooltipInstance)
				{
					tooltipInstance.hide();
				}
				
				var count:int = int(_classCountMap[className]);
				count--;
				_classCountMap[className] = count;
				if(count <= 0)
				{
					_classCountMap[className] = null;
					delete _classCountMap[className];
					
					if(tooltipInstance)
					{
						tooltipInstance.destroy();
						_classMap[className] = null;
						delete _classMap[className];
					}
				}
			}
		}
		
		private static function overHandle(event:MouseEvent):void
		{
			var target:InteractiveObject = event.currentTarget as InteractiveObject;
			
			var tipData:TipData = _targetMap[target] as TipData;
			
			if(tipData)
			{
				clearTimeout(_delayTimer);
				_delayTimer = setTimeout(prevShowTips, tipData.delay, target);
			}
		}
		
		private static function outHandle(event:MouseEvent):void
		{
			var target:InteractiveObject = event.currentTarget as InteractiveObject;
			target.removeEventListener(MouseEvent.MOUSE_MOVE, moveHandle);
			hideTip(target);
			clearTimeout(_delayTimer);
		}
		
		private static function moveHandle(event:MouseEvent):void
		{
			var target:InteractiveObject = event.currentTarget as InteractiveObject;
			showTip(target, true);
		}
		
		private static function prevShowTips(target:InteractiveObject):void
		{
			target.addEventListener(MouseEvent.MOUSE_MOVE, moveHandle);
			showTip(target, false);
		}
		
		private static function showTip(target:InteractiveObject, onlyUpdatePosition:Boolean):void
		{
			var tipData:TipData = _targetMap[target] as TipData;
			
			if(tipData)
			{
				var tooltipInstance:IToolTip = _classMap[getQualifiedClassName(tipData.clazz)] as IToolTip;
				if(tooltipInstance == null)
				{
					tooltipInstance = _classMap[getQualifiedClassName(tipData.clazz)] = new tipData.clazz() as IToolTip;
				}
				
				if(onlyUpdatePosition)
				{
					tooltipInstance.layout();
				}
				else
				{
					tooltipInstance.initData(tipData.userData);
					tooltipInstance.show(Global.layerManager.tipsLevel);
				}
				
			}
		}
		
		private static function hideTip(target:InteractiveObject):void
		{
			var tipData:TipData = _targetMap[target] as TipData;
			
			if(tipData)
			{
				var tooltipInstance:IToolTip = _classMap[getQualifiedClassName(tipData.clazz)] as IToolTip;
				if(tooltipInstance)
				{
					tooltipInstance.hide();
				}
			}
		}
	}
}

class TipData
{
	public var clazz:Class;
	public var userData:Object;
	public var delay:int;
	
	public function TipData(clazz:Class, userData:Object, delay:int)
	{
		this.clazz = clazz;
		this.userData = userData;
		this.delay = delay;
	}
}