package ninedays.component
{
    import flash.display.Graphics;
    import flash.display.InteractiveObject;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.TimerEvent;
    import flash.utils.Timer;
    
    import ninedays.component.events.ScrollEvent;
    import ninedays.component.style.DefaultStyle;
    import ninedays.component.style.StyleManager;
    import ninedays.core.IDestroyable;


    [Event(name="scroll", type="ninedays.component.events.ScrollEvent")]

    /**
     * ScrollBar
     * @author	九天之后
     */
    public class ScrollBar extends Component
    {
        public static const HORIZONTAL:String = "horizontal";

        public static const VERTICAL:String = "vertical";

        public static const WIDTH:Number = 15;

        protected static const REPEAT_TIME:int = 100;

        private var _pageSize:Number = 10;

        private var _pageScrollSize:Number = 0;

        private var _lineScrollSize:Number = 1;

        private var _minValue:Number = 0;

        private var _maxValue:Number = 100;

        private var _scrollPosition:Number = 0;

        private var _direction:String = "";

        private var thumbScrollOffset:Number;

        /**自动隐藏**/
        protected var _autoHide:Boolean = true;

        protected var upArrow:InteractiveObject;

        protected var downArrow:InteractiveObject;

        protected var thumb:InteractiveObject;

        protected var track:InteractiveObject;


        protected var _repeatTimer:Timer;

        protected var _pressInteractive:InteractiveObject;


        public function ScrollBar(direction:String = VERTICAL)
        {
            setSize(15, 100);
            creatChildren();
            addListeners();
            this.direction = direction;

            _repeatTimer = new Timer(REPEAT_TIME);
            _repeatTimer.addEventListener(TimerEvent.TIMER, onRepeat);
        }

        protected function onRepeat(event:TimerEvent):void
        {
            if (_pressInteractive == upArrow)
            {
                setScrollPosition(_scrollPosition - _lineScrollSize);
            }
            else if (_pressInteractive == downArrow)
            {
                setScrollPosition(_scrollPosition + _lineScrollSize);
            }
            else
            {
                var mousePosition:Number;
                if (_direction == VERTICAL)
                    mousePosition = (track.mouseY) / track.height * (_maxValue - _minValue) + _minValue;
                else
                    mousePosition = (track.mouseX) / track.width * (_maxValue - _minValue) + _minValue;

                var pgScroll:Number = (pageScrollSize == 0) ? pageSize : pageScrollSize;
                if (_scrollPosition < mousePosition)
                {
                    setScrollPosition(Math.min(mousePosition, _scrollPosition + pgScroll));
                }
                else if (_scrollPosition > mousePosition)
                {
                    setScrollPosition(Math.max(mousePosition, _scrollPosition - pgScroll));
                }
            }
        }

        public function setScrollProperties(pageSize:Number, minScrollPosition:Number, maxScrollPosition:Number, pageScrollSize:Number = 0):void
        {
            this.pageSize = pageSize;
            _minValue = minScrollPosition;
            _maxValue = maxScrollPosition;
            if (pageScrollSize >= 0)
            {
                _pageScrollSize = pageScrollSize;
            }
            visible = _autoHide ? 0 < _maxValue : true;
            setScrollPosition(_scrollPosition, false);
            updateThumb();

            if (_direction == HORIZONTAL)
            {
                var w:Number = width;
                downArrow.y = 0;
                downArrow.x = Math.max(upArrow.width, w - downArrow.width);
                track.height = WIDTH;
                track.width = Math.max(0, w - (downArrow.width + upArrow.width));
            }
            else
            {
                var h:Number = height;
                downArrow.x = 0;
                downArrow.y = Math.max(upArrow.height, h - downArrow.height);
                track.width = WIDTH;
                track.height = Math.max(0, h - (downArrow.height + upArrow.height));
            }
        }

        override public function draw():void
        {
            setScrollProperties(_pageSize, _minValue, _maxValue);
        }

        override protected function creatChildren():void
        {
            super.creatChildren();

            track = StyleManager.instance.getStyleInstance(DefaultStyle.SCROLL_TRACK) as InteractiveObject;
            addChild(track);

            thumb = StyleManager.instance.getStyleInstance(DefaultStyle.SCROLL_THUMB) as InteractiveObject;
            thumb.width = thumb.height = WIDTH;
            addChild(thumb);

            downArrow = StyleManager.instance.getStyleInstance(DefaultStyle.SCROLL_ARROW_DOWN) as InteractiveObject;
            downArrow.width = downArrow.height = WIDTH;
            addChild(downArrow);

            upArrow = StyleManager.instance.getStyleInstance(DefaultStyle.SCROLL_ARROW_UP) as InteractiveObject;
            upArrow.width = upArrow.height = WIDTH;
            addChild(upArrow);
        }

        override protected function addListeners():void
        {
            upArrow.addEventListener(MouseEvent.MOUSE_DOWN, scrollPressHandler);
            downArrow.addEventListener(MouseEvent.MOUSE_DOWN, scrollPressHandler);
            track.addEventListener(MouseEvent.MOUSE_DOWN, scrollPressHandler);
            thumb.addEventListener(MouseEvent.MOUSE_DOWN, thumbPressHandler);
        }

        override protected function removeListeners():void
        {
            upArrow.removeEventListener(MouseEvent.MOUSE_DOWN, scrollPressHandler);
            downArrow.removeEventListener(MouseEvent.MOUSE_DOWN, scrollPressHandler);
            track.removeEventListener(MouseEvent.MOUSE_DOWN, scrollPressHandler);
            thumb.removeEventListener(MouseEvent.MOUSE_DOWN, thumbPressHandler);
			if(stage)
            	stage.removeEventListener(MouseEvent.MOUSE_UP, endPress);
			
			if(_pressInteractive)
				_pressInteractive.removeEventListener(MouseEvent.ROLL_OUT, endPress);
        }

        protected function scrollPressHandler(event:MouseEvent):void
        {
            _pressInteractive = event.currentTarget as InteractiveObject;
			
			_repeatTimer.reset();
			_repeatTimer.start();
			stage.addEventListener(MouseEvent.MOUSE_UP, endPress);
            _pressInteractive.addEventListener(MouseEvent.ROLL_OUT, endPress);
			
			onRepeat(null);
        }

        private function endPress(event:MouseEvent):void
        {
            stage.removeEventListener(MouseEvent.MOUSE_UP, endPress);
            _repeatTimer.reset();
            _pressInteractive.removeEventListener(MouseEvent.ROLL_OUT, endPress);
            _pressInteractive = null;
        }

        protected function thumbPressHandler(event:MouseEvent):void
        {
            thumbScrollOffset = _direction == VERTICAL ? mouseY - thumb.y : mouseX - thumb.x;
            mouseChildren = false;
            stage.addEventListener(MouseEvent.MOUSE_MOVE, handleThumbDrag, false, 0, true);
            stage.addEventListener(MouseEvent.MOUSE_UP, thumbReleaseHandler, false, 0, true);
        }

        protected function handleThumbDrag(event:MouseEvent):void
        {
            var pos:Number;
            if (_direction == VERTICAL)
            {
                pos = Math.max(0, Math.min(track.height - thumb.height, mouseY - track.y - thumbScrollOffset));
                setScrollPosition(pos / (track.height - thumb.height) * (_maxValue - _minValue) + _minValue);
            }
            else
            {
                pos = Math.max(0, Math.min(track.width - thumb.width, mouseX - track.x - thumbScrollOffset));
                setScrollPosition(pos / (track.width - thumb.width) * (_maxValue - _minValue) + _minValue);
            }
        }

        protected function thumbReleaseHandler(event:MouseEvent):void
        {
            mouseChildren = true;
            stage.removeEventListener(MouseEvent.MOUSE_MOVE, handleThumbDrag);
            stage.removeEventListener(MouseEvent.MOUSE_UP, thumbReleaseHandler);
        }

        protected function setScrollPosition(newScrollPosition:Number, fireEvent:Boolean = true):void
        {
            var oldPosition:Number = scrollPosition;
            _scrollPosition = Math.max(_minValue, Math.min(_maxValue, newScrollPosition));
            if (oldPosition == _scrollPosition)
            {
                return;
            }
            if (fireEvent)
            {
                dispatchEvent(new ScrollEvent(_direction, _scrollPosition, oldPosition, percent));
            }
            updateThumb();
        }

        protected function updateThumb():void
        {
            var per:Number = _maxValue - _minValue + _pageSize;
            if (_direction == VERTICAL)
            {
                thumb.x = 0;
                if (track.height <= WIDTH || _maxValue <= _minValue || (per == 0 || isNaN(per)))
                {
                    thumb.height = WIDTH;
                    visible = false;
                }
                else
                {
                    thumb.height = Math.max(WIDTH, _pageSize / per * track.height);
                    thumb.y = track.y + (track.height - thumb.height) * ((_scrollPosition - _minValue) / (_maxValue - _minValue));
                    visible = _autoHide ? 0 < _maxValue : true;
                }
            }
            else
            {
                thumb.y = 0;
                if (track.width <= WIDTH || _maxValue <= _minValue || (per == 0 || isNaN(per)))
                {
                    thumb.width = WIDTH;
                    visible = false;
                }
                else
                {
                    thumb.width = Math.max(WIDTH, _pageSize / per * track.width);
                    thumb.x = track.x + (track.width - thumb.width) * ((_scrollPosition - _minValue) / (_maxValue - _minValue));
                    visible = _autoHide ? 0 < _maxValue : true
                }
            }
        }

        /**
         * 当前值
         * @return
         *
         */
        public function get scrollPosition():Number
        {
            return _scrollPosition;
        }


        public function set scrollPosition(newScrollPosition:Number):void
        {
            setScrollPosition(newScrollPosition, true);
        }

        /**
         * 最小值
         * @return
         *
         */
        public function get minValue():Number
        {
            return _minValue;
        }

        public function set minValue(value:Number):void
        {
            setScrollProperties(_pageSize, value, _maxValue);
        }

        /**
         * 最大值
         * @return
         *
         */
        public function get maxValue():Number
        {
            return _maxValue;
        }

        public function set maxValue(value:Number):void
        {
            setScrollProperties(_pageSize, _minValue, value);
        }

        /**
         * 一页的大小
         * @return
         *
         */
        public function get pageSize():Number
        {
            return _pageSize;
        }

        public function set pageSize(value:Number):void
        {
            if (value > 0)
            {
                _pageSize = value;
            }
        }

        /**
         * 点击背景滚动一页时的大小，如果为0，则和<code>pageSize</code>一样
         * @return
         *
         */
        public function get pageScrollSize():Number
        {
            return (_pageScrollSize == 0) ? _pageSize : _pageScrollSize;
        }


        public function set pageScrollSize(value:Number):void
        {
            if (value >= 0)
            {
                _pageScrollSize = value;
            }
        }

        /**
         * 一行滚动的值
         * @return
         *
         */
        public function get lineScrollSize():Number
        {
            return _lineScrollSize;
        }

        public function set lineScrollSize(value:Number):void
        {
            if (value > 0)
            {
                _lineScrollSize = value;
            }
        }

        public function get direction():String
        {
            return _direction;
        }

        public function set direction(value:String):void
        {
            if (_direction == value)
            {
                return;
            }
            _direction = value;

            if (_direction == HORIZONTAL)
            {
                var w:Number = width;
                downArrow.y = 0;
                downArrow.x = Math.max(upArrow.width, w - downArrow.width);
                track.height = WIDTH;
                track.width = Math.max(0, w - (downArrow.width + upArrow.width));

                track.x = upArrow.width;
                track.y = 0;
                thumb.height = WIDTH;
            }
            else
            {
                var h:Number = height;
                downArrow.x = 0;
                downArrow.y = Math.max(upArrow.height, h - downArrow.height);
                track.width = WIDTH;
                track.height = Math.max(0, h - (downArrow.height + upArrow.height));

                track.x = 0;
                track.y = upArrow.height;
                thumb.width = WIDTH;
            }

            updateThumb();
        }

        public function set autoHide(value:Boolean):void
        {
            _autoHide = value;
            visible = _autoHide ? 0 < _maxValue : true;
        }

        public function get autoHide():Boolean
        {
            return _autoHide;
        }

        /**
         * 百分比
         * @return
         *
         */
        public function get percent():Number
        {
            return (_scrollPosition - _minValue) / (_maxValue - _minValue);
        }


        public function set percent(value:Number):void
        {
            this.scrollPosition = value * (_maxValue - _minValue) + _minValue;
        }


        override protected function doDestroy():void
        {
            super.doDestroy();

            if (upArrow is IDestroyable)
                (upArrow as IDestroyable).destroy();
            if (downArrow is IDestroyable)
                (downArrow as IDestroyable).destroy();
            if (thumb is IDestroyable)
                (thumb as IDestroyable).destroy();
            if (track is IDestroyable)
                (track as IDestroyable).destroy();

            _repeatTimer.stop();
            _repeatTimer = null;
        }
    }
}
