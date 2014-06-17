package ninedays.events
{
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    import flash.utils.Dictionary;
    
    import ninedays.utils.ArrayUtil;

	/**
	 * 监听管理器 
	 * @author riggzhuo
	 * 
	 */	
    public class ListenerManager
    {
        protected static var _proxyMap:Dictionary;

        protected var _eventDispatcher:IEventDispatcher;

        protected var _events:Array;

        protected var _blockRequest:Boolean;

        public function ListenerManager(singletonEnforcer:EventInfo, dispatcher:IEventDispatcher)
        {
            _eventDispatcher = dispatcher;
            _events = [];
        }

        public static function getManager(dispatcher:IEventDispatcher):ListenerManager
        {
            if (ListenerManager._proxyMap == null)
            {
                ListenerManager._proxyMap = new Dictionary();
            }

            if (!(dispatcher in ListenerManager._proxyMap))
            {
                ListenerManager._proxyMap[dispatcher] = new ListenerManager(new EventInfo(null, null, false), dispatcher);
            }

            return ListenerManager._proxyMap[dispatcher];
        }

        public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
        {
            var info:EventInfo = new EventInfo(type, listener, useCapture);
            var l:int = _events.length;
            while (l--)
            {
                if (_events[l].equals(info))
                {
                    return;
                }
            }
            _events.push(info);
        }

        public function dispatchEvent(event:Event):Boolean
        {
            return _eventDispatcher.dispatchEvent(event);
        }

        public function hasEventListener(type:String):Boolean
        {
            return _eventDispatcher.hasEventListener(type);
        }

        public function willTrigger(type:String):Boolean
        {
            return _eventDispatcher.willTrigger(type);
        }

        public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
        {
            if (_blockRequest)
            {
                return;
            }

            var info:EventInfo = new EventInfo(type, listener, useCapture);
            var l:int = _events.length;
            while (l--)
            {
                if (_events[l].equals(info))
                {
                    _events.splice(l, 1);
                }
            }
        }

        public function removeEventsForType(type:String):void
        {
            var eventInfo:EventInfo;
            _blockRequest = true;
            var l:int = _events.length;
            while (l--)
            {
                eventInfo = _events[l];
                if (eventInfo.type == type)
                {
                    _events.splice(l, 1);
                    _eventDispatcher.removeEventListener(eventInfo.type, eventInfo.listener, eventInfo.useCapture);
                }
            }
            _blockRequest = false;
        }

        public function removeEventsForListener(listener:Function):void
        {
            var eventInfo:EventInfo;
            _blockRequest = true;
            var l:int = _events.length;
            while (l--)
            {
                eventInfo = _events[l];
                if (eventInfo.listener == listener)
                {
                    _events.splice(l, 1);
                    _eventDispatcher.removeEventListener(eventInfo.type, eventInfo.listener, eventInfo.useCapture);
                }
            }
            _blockRequest = false;
        }

        public function removeEventListeners():void
        {
            var eventInfo:EventInfo;
            _blockRequest = true;
            var l:int = _events.length;
            while (l--)
            {
                eventInfo = _events.splice(l, 1)[0];
                _eventDispatcher.removeEventListener(eventInfo.type, eventInfo.listener, eventInfo.useCapture);
            }
            _blockRequest = false;
        }

        public function getTotalEventListeners(type:String = null):uint
        {
            return type == null ? _events.length : ArrayUtil.getItemsByKey(_events, "type", type).length;
        }

        public function destroy():void
        {
            removeEventListeners();
            delete ListenerManager._proxyMap[_eventDispatcher];
            _eventDispatcher = null;
            _events = null;
        }
    }
}


class EventInfo
{

    public var type:String;

    public var listener:Function;

    public var useCapture:Boolean;

    public function EventInfo(type:String, listener:Function, useCapture:Boolean)
    {
        this.type = type;
        this.listener = listener;
        this.useCapture = useCapture;
    }

    public function equals(eventInfo:EventInfo):Boolean
    {
        return type == eventInfo.type && listener == eventInfo.listener && useCapture == eventInfo.useCapture;
    }
}