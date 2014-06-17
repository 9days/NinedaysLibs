package ninedays.utils
{
    import flash.events.TimerEvent;
    import flash.utils.Dictionary;
    import flash.utils.Timer;
    import flash.utils.getTimer;

	/**
	 * 计时器，相同delay的只运行一个Timer 
	 * @author riggzhuo
	 * 
	 */	
    public class AutoTimer
    {
        private static var _map:Dictionary = new Dictionary();

        private var _key:uint;

        private var _delay:uint;

        public var currentCount:uint;

        public var repeatCount:uint;

        public var running:Boolean;

        public var timerHander:Function;

        public var timerCompleteHandler:Function;

        public function AutoTimer(enforcer:Enforcer, key:uint, delay:uint, timerHander:Function, repeatCount:uint, timerCompleteHandler:Function)
        {
            if (!enforcer)
            {
                throw new Error("请通过AutoTimer.getInstance获取实例");
            }
            _key = key;
            _delay = delay;
            this.repeatCount = repeatCount;
            this.timerHander = timerHander;
            this.timerCompleteHandler = timerCompleteHandler;
        }

        public static function getInstance(delay:uint, timerHander:Function = null, repeatCount:uint = 0, timerCompleteHandler:Function = null):AutoTimer
        {
            createTimer(delay);
            var key:uint = ++_map[delay].index;
            var autoTimer:AutoTimer = new AutoTimer(new Enforcer(), _map[delay].index, delay, timerHander, repeatCount, timerCompleteHandler);
            _map[delay].list[key] = autoTimer;
            return autoTimer;
        }

        private static function createTimer(delay:uint):void
        {
            if (_map[delay] == null)
            {
                _map[delay] = { index: 0, list: new Dictionary(), timer: new Timer(delay)};
                _map[delay].timer.addEventListener(TimerEvent.TIMER, timerHandler);
            }
        }

        public static function getInstanceByKey(delay:uint, key:uint):AutoTimer
        {
            if (_map[delay] == null)
            {
                return null;
            }
            return _map[delay].list[key];
        }

        private static function timerHandler(event:TimerEvent):void
        {
            var running:Boolean;
            var autoTimer:AutoTimer;
            var timer:Timer = event.target as Timer;
            var item:Object = _map[timer.delay];
			
			//为了防止在完成时AutoTimer被摧毁导致item.list不准确
			var completeHandles:Vector.<Function> = new Vector.<Function>();
			
            for each (autoTimer in item.list)
            {
                if (autoTimer.running)
                {
                    if (autoTimer.timerHander != null)
                    {
                        autoTimer.timerHander();
                    }
                    autoTimer.currentCount++;
                    if (autoTimer.repeatCount > 0 && autoTimer.currentCount >= autoTimer.repeatCount)
                    {
                        autoTimer.running = false;
                        if (autoTimer.timerCompleteHandler != null)
                        {
							completeHandles.push(autoTimer.timerCompleteHandler);
                        }
                    }
                    else
                    {
                        running = true;
                    }
                }
            }
            if (!running)
            {
                timer.reset();
            }
			
			while(completeHandles.length)
			{
				completeHandles.shift()();
			}
			completeHandles = null;
        }

        public function get key():uint
        {
            return _key;
        }

        public function set delay(value:uint):void
        {
            if (this._delay == value)
            {
                return;
            }
            clear();
            _delay = value;
            createTimer(_delay);
            _key = ++_map[this._delay].index;
            _map[_delay].list[_key] = this;
            if (running)
            {
                start();
            }
        }

        public function get delay():uint
        {
            return _delay;
        }

        public function start():void
        {
            running = true;
            if (repeatCount == 0 || currentCount < repeatCount)
            {
                _map[_delay].timer.start();
            }
        }

        public function stop():void
        {
            running = false;
        }

        public function reset():void
        {
            currentCount = 0;
            stop();
        }

        private function clear():void
        {
            _map[_delay].list[_key] = null;
            delete _map[_delay].list[_key];

            var totalCount:int = 0;
            for (var key:*in _map[_delay].list)
            {
                totalCount++;
                break;
            }
            if (totalCount == 0)
            {
                _map[_delay].timer.removeEventListener(TimerEvent.TIMER, timerHandler);
                _map[_delay].timer.stop();
                _map[_delay] = null;
                delete _map[_delay];
            }
        }

        public function destroy():void
        {
            clear();
            timerHander = null;
            timerCompleteHandler = null;
        }
    }
}

class Enforcer
{
}

