package ninedays.core
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	
	public class Tick 
	{
		private static var _instance:Tick;
		public static function get instance():Tick
		{
			return _instance ||= new Tick();
		}
		
		
		private var _map:Array;
		
		/**用来提供事件的对象**/
		private var _trigger:Shape;
		
		/**上次记录的时间**/
		private var _prevTime:int;
		
		/**
		 * 最大两帧间隔（防止待机后返回卡死）
		 */
		public static var MAX_INTERVAL:int = 3000;
		
		/**
		 * 速度系数
		 * 可由此实现慢速播放
		 *
		 */
		public var speed:Number = 1.0;
		
		/**
		 * 是否停止发布Tick事件
		 * Tick事件的发布影响的内容非常多，一般情况不建议设置此属性，而是设置所有需要暂停物品的pause属性。
		 */
		public var pause:Boolean = false;
		
		public function Tick()
		{
			_map = [];
			_prevTime = getTimer();
			_trigger = new Shape();
			_trigger.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		/**
		 * 清除掉积累的时间（在暂停之后）
		 *
		 */
		public function clear():void
		{
			this._prevTime = 0;
		}
		
		private var _runningCount:int;
		private var _totalTime:int;
		private function enterFrameHandler(event:Event):void
		{
			var nextTime:int = getTimer();
			if (!pause)
			{
				var interval:int;
				if (_prevTime == 0)
				{
					interval = 0;
				}
				else
				{
					interval = Math.min(nextTime - _prevTime, MAX_INTERVAL);
					for each(var handle:Function in _map)
					{
						handle(interval * speed);
					}
				}
			}
			_totalTime += (nextTime - _prevTime);
			_runningCount++;
			if(_runningCount == 2000)
			trace("---------" + (_totalTime / _runningCount));
			_prevTime = nextTime;
		}
		
		public function isRegistered(handle:Function):Boolean
		{
			return _map.indexOf(handle) != -1;
		}
		
		public function unregister(handle:Function):void
		{
			var index:int = _map.indexOf(handle);
			if(index != -1)
			{
				_map.splice(index, 1);
			}
		}
		
		public function register(handle:Function):void
		{
			unregister(handle);
			_map.push(handle);
		}
	}
}
