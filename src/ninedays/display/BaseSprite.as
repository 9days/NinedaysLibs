package ninedays.display
{
    import flash.display.Sprite;
    import flash.events.Event;
    
    import ninedays.core.IDestroyable;
    import ninedays.events.ListenerManager;
    import ninedays.utils.DisplayObjectUtil;

    public class BaseSprite extends Sprite implements IDestroyable
    {
        protected var _listenerManager:ListenerManager;

        protected var _isDestroyed:Boolean;

        public function BaseSprite()
        {
            super();
            _listenerManager = ListenerManager.getManager(this);
        }

        override public function dispatchEvent(event:Event):Boolean
        {
            if (willTrigger(event.type))
            {
                return (super.dispatchEvent(event));
            }
            return true;
        }

        override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
        {
            super.addEventListener(type, listener, useCapture, priority, useWeakReference);
            _listenerManager.addEventListener(type, listener, useCapture, priority, useWeakReference);
        }

        override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
        {
            super.removeEventListener(type, listener, useCapture);
            _listenerManager.removeEventListener(type, listener, useCapture);
        }

        public function removeEventsForType(type:String):void
        {
            _listenerManager.removeEventsForType(type);
        }

        public function removeEventsForListener(listener:Function):void
        {
            _listenerManager.removeEventsForListener(listener);
        }

        public function removeEventListeners():void
        {
            _listenerManager.removeEventListeners();
        }

        public function getTotalEventListeners(type:String = null):uint
        {
            return _listenerManager.getTotalEventListeners(type);
        }

        public function get children():Array
        {
            return DisplayObjectUtil.getChildren(this);
        }

        public function removeAllChildren():void
        {
            DisplayObjectUtil.removeAllChildren(this);
        }

        public function get destroyed():Boolean
        {
            return _isDestroyed;
        }

        final public function destroy():void
        {
            if (!_isDestroyed)
            {
                doDestroy();
                _isDestroyed = true;
            }
        }

        protected function doDestroy():void
        {
            _listenerManager.destroy();
			removeAllChildren();
            if (parent != null)
            {
                parent.removeChild(this);
            }
        }
    }
}