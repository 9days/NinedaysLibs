package ninedays.display.mediator
{
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;
    import flash.events.MouseEvent;
    
    import ninedays.events.ValueChangeEvent;

	[Event(name="valueChange", type="ninedays.events.ValueChangeEvent")]
    /**
     * 单选组
     * @author riggzhuo
     *
     */
    public class RadioGroup extends EventDispatcher
    {
        protected var _group:Vector.<IButtonSelectable>;

        protected var _currentIndex:int;

        public function RadioGroup(group:Vector.<IButtonSelectable>)
        {
            _group = group;
            _currentIndex = -1;
            addListeners();
        }


        protected function addListeners():void
        {
            for each (var btn:IButtonSelectable in _group)
            {
                btn.addEventListener(MouseEvent.CLICK, onMouseEvent);
            }
        }


        private function onMouseEvent(event:MouseEvent):void
        {
            var target:IButtonSelectable = event.currentTarget as IButtonSelectable;
            var index:int = _group.indexOf(target);
			
            if (index == _currentIndex)
                return;
			
            if (_currentIndex != -1)
            {
                _group[_currentIndex].selected = false;
            }
			
			dispatchEvent(new ValueChangeEvent(ValueChangeEvent.VALUE_CHANGE, "", _currentIndex, index));
			
			_currentIndex = index;
			
            target.selected = true;
        }


        protected function removeListeners():void
        {
            while (_group.length)
            {
                _group.shift().removeEventListener(MouseEvent.CLICK, onMouseEvent);
            }
        }
		
		public function get currentIndex():int
		{
			return _currentIndex;
		}


        public function destroy():void
        {
            removeListeners();
            _group = null;
        }
    }
}