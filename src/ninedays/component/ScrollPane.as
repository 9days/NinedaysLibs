package ninedays.component
{
    import flash.display.DisplayObject;
    import flash.display.Graphics;
    import flash.display.Shape;
    import flash.events.MouseEvent;
    import flash.geom.Rectangle;

    import ninedays.component.constants.InvalidationType;
    import ninedays.component.events.ScrollEvent;

    public class ScrollPane extends Component
    {
        protected var _verticalScrollBar:ScrollBar;

        protected var _horizontalScrollBar:ScrollBar;

        protected var contentScrollRect:Rectangle;

        protected var background:DisplayObject;

        protected var _horizontalScrollPosition:Number = 0;

        protected var _verticalScrollPosition:Number = 0;

        /**内容宽度**/
        protected var contentWidth:Number = 0;

        /**内容高度**/
        protected var contentHeight:Number = 0;

        /**可见宽度**/
        protected var availableWidth:Number;

        /**可见高度**/
        protected var availableHeight:Number;

        protected var _maxHorizontalScrollPosition:Number = 0;

        /**横向一页滚动大小**/
        protected var _horizontalPageScrollSize:Number = 0;

        /**纵向一页滚动大小**/
        protected var _verticalPageScrollSize:Number = 0;

        protected var useFixedHorizontalScrolling:Boolean = false;



        public function ScrollPane(width:int = 100, height:int = 100)
        {
            this.width = width;
            this.height = height;

            contentScrollRect = new Rectangle(0, 0, availableWidth, availableHeight);
            scrollRect = contentScrollRect;

            _verticalScrollBar = new ScrollBar(ScrollBar.VERTICAL);
            addChild(_verticalScrollBar);
            _verticalScrollBar.visible = false;
			_verticalScrollBar.addEventListener(ScrollEvent.SCROLL, handleScroll);

            _horizontalScrollBar = new ScrollBar(ScrollBar.HORIZONTAL);
            addChild(_horizontalScrollBar);
            _horizontalScrollBar.visible = false;
			_horizontalScrollBar.addEventListener(ScrollEvent.SCROLL, handleScroll);
        }


        public function set verticalScrollBar(value:ScrollBar):void
        {
            if (_verticalScrollBar)
            {
                _verticalScrollBar.destroy();
            }
            _verticalScrollBar = value;
//			addChild(_verticalScrollBar);
            if (_verticalScrollBar)
            {
                _verticalScrollBar.addEventListener(ScrollEvent.SCROLL, handleScroll);
                _verticalScrollBar.visible = false;
                invalidate(InvalidationType.STATE);
            }
        }

        public function get verticalScrollBar():ScrollBar
        {
            return _verticalScrollBar;
        }

        public function set horizontalScrollBar(value:ScrollBar):void
        {
            if (_horizontalScrollBar)
            {
                _horizontalScrollBar.destroy();
            }
            _horizontalScrollBar = value;
//			addChild(_horizontalScrollBar);
            if (_horizontalScrollBar)
            {
                _horizontalScrollBar.addEventListener(ScrollEvent.SCROLL, handleScroll);
                _horizontalScrollBar.visible = false;
                invalidate(InvalidationType.STATE);
            }
        }

        public function get horizontalScrollBar():ScrollBar
        {
            return _horizontalScrollBar;
        }


        override protected function addListeners():void
        {
            super.addListeners();
            addEventListener(MouseEvent.MOUSE_WHEEL, handleWheel);
        }


        override public function set enabled(value:Boolean):void
        {
            if (enabled == value)
            {
                return;
            }
            if (_verticalScrollBar)
                _verticalScrollBar.enabled = value;
            if (_horizontalScrollBar)
                _horizontalScrollBar.enabled = value;
            super.enabled = value;
        }

        /**
         * 横向滚动大小
         * @return
         *
         */
        public function get horizontalLineScrollSize():Number
        {
            return _horizontalScrollBar ? _horizontalScrollBar.lineScrollSize : 0;
        }

        public function set horizontalLineScrollSize(value:Number):void
        {
            if (_horizontalScrollBar)
                _horizontalScrollBar.lineScrollSize = value;
        }

        /**
         * 纵向滚动大小
         * @return
         *
         */
        public function get verticalLineScrollSize():Number
        {
            return _verticalScrollBar ? _verticalScrollBar.lineScrollSize : 0;
        }


        public function set verticalLineScrollSize(value:Number):void
        {
            if (_verticalScrollBar)
                _verticalScrollBar.lineScrollSize = value;
        }

        public function get horizontalScrollPosition():Number
        {
            return _horizontalScrollBar ? _horizontalScrollBar.scrollPosition : 0;
        }

        public function set horizontalScrollPosition(value:Number):void
        {
            if (_horizontalScrollBar)
            {
                draw();

                _horizontalScrollBar.scrollPosition = value;
                setHorizontalScrollPosition(_horizontalScrollBar.scrollPosition, false);
            }
        }


        public function get verticalScrollPosition():Number
        {
            return _verticalScrollBar ? _verticalScrollBar.scrollPosition : 0;
        }

        public function set verticalScrollPosition(value:Number):void
        {
            if (_verticalScrollBar)
            {
                draw();

                _verticalScrollBar.scrollPosition = value;
                setVerticalScrollPosition(_verticalScrollBar.scrollPosition, false);
            }
        }

        /**
         * 横向最大滚动位置
         * @return
         *
         */
        public function get maxHorizontalScrollPosition():Number
        {
            return Math.max(0, contentWidth - availableWidth);
        }

        /**
         * 纵向最大滚动位置
         * @return
         *
         */
        public function get maxVerticalScrollPosition():Number
        {
            return Math.max(0, contentHeight - availableHeight);
        }


        /**
         * 横向页滚动大小
         * @return
         *
         */
        public function get horizontalPageScrollSize():Number
        {
            return (_horizontalPageScrollSize == 0 && !isNaN(availableWidth)) ? availableWidth : _horizontalPageScrollSize;
        }

        public function set horizontalPageScrollSize(value:Number):void
        {
            _horizontalPageScrollSize = value;
            invalidate(InvalidationType.SIZE);
        }


        /**
         * 纵向页滚动大小
         * @param value
         *
         */
        public function get verticalPageScrollSize():Number
        {
            return (_verticalPageScrollSize == 0 && !isNaN(availableHeight)) ? availableHeight : _verticalPageScrollSize;
        }

        public function set verticalPageScrollSize(value:Number):void
        {
            _verticalPageScrollSize = value;
            invalidate(InvalidationType.SIZE);
        }

        /**
         * 设置内容大小
         * @param width
         * @param height
         *
         */
        public function setContentSize(width:Number, height:Number):void
        {
            if ((contentWidth == width || useFixedHorizontalScrolling) && contentHeight == height)
            {
                return;
            }

            contentWidth = width;
            contentHeight = height;
            invalidate(InvalidationType.SIZE);
        }

        /**
         * 处理滚动条事件
         * @param event
         *
         */
        protected function handleScroll(event:ScrollEvent):void
        {
            if (event.target == _verticalScrollBar)
            {
                setVerticalScrollPosition(event.position);
            }
            else
            {
                setHorizontalScrollPosition(event.position);
            }
        }

        protected function handleWheel(event:MouseEvent):void
        {
            if (!enabled || _verticalScrollBar == null || !_verticalScrollBar.visible || contentHeight <= availableHeight)
            {
                return;
            }
            var oldValue:Number = _verticalScrollBar.scrollPosition;
            _verticalScrollBar.scrollPosition -= event.delta * verticalLineScrollSize;
            setVerticalScrollPosition(_verticalScrollBar.scrollPosition);

            dispatchEvent(new ScrollEvent(ScrollBar.VERTICAL, verticalScrollPosition, oldValue, _verticalScrollBar.percent));
        }

        protected function setHorizontalScrollPosition(scroll:Number, fireEvent:Boolean = false):void
        {
            if (scroll == _horizontalScrollPosition)
            {
                return;
            }
            var oldPosition:Number = -_horizontalScrollPosition;
            _horizontalScrollPosition = scroll;
            if (fireEvent)
            {
                dispatchEvent(new ScrollEvent(ScrollBar.HORIZONTAL, _horizontalScrollPosition, oldPosition, horizontalScrollBar.percent));
            }
            invalidate(InvalidationType.SCROLL);
        }

        protected function setVerticalScrollPosition(scroll:Number, fireEvent:Boolean = false):void
        {
            if (scroll == _verticalScrollPosition)
            {
                return;
            }
            var oldPosition:Number = -_verticalScrollPosition;
            _verticalScrollPosition = scroll;
            if (fireEvent)
            {
                dispatchEvent(new ScrollEvent(ScrollBar.VERTICAL, _verticalScrollPosition, oldPosition, verticalScrollBar.percent));
            }
            invalidate(InvalidationType.SCROLL);
        }


        override public function draw():void
        {
            super.draw();
            if (isInvalid(InvalidationType.STYLES))
                drawBackground();
            if (isInvalid(InvalidationType.SIZE, InvalidationType.STATE))
                drawLayout();
            if (isInvalid(InvalidationType.SCROLL))
                drawScrollRect();
            updateChildren();
        }


        protected function drawBackground():void
        {
            if (background == null)
            {
                background = new Shape();
                var graphics:Graphics = (background as Shape).graphics;
                graphics.beginFill(0, 0);
                graphics.drawRect(0, 0, 10, 10);
                graphics.endFill();
            }
            background.width = width;
            background.height = height;
            addChildAt(background, 0);
        }

        protected function drawLayout():void
        {
            calculateAvailableSize();
            calculateContentWidth();

            background.width = width;
            background.height = height;

            if (_verticalScrollBar)
            {
                var vScrollBar:Boolean = contentHeight > availableHeight;
                if (vScrollBar)
                {
                    _verticalScrollBar.visible = true;
                    if (contains(_verticalScrollBar))
                    {
                        _verticalScrollBar.x = width - ScrollBar.WIDTH;
                        _verticalScrollBar.y = 0;
                        _verticalScrollBar.height = availableHeight;
                    }
                }
                else
                {
                    _verticalScrollBar.visible = false;
                }

                _verticalScrollBar.setScrollProperties(availableHeight, 0, contentHeight - availableHeight, verticalPageScrollSize);
                setVerticalScrollPosition(_verticalScrollBar.scrollPosition, false);
            }


            if (_horizontalScrollBar)
            {
                var hScrollBar:Boolean = contentWidth > availableWidth;
                if (hScrollBar)
                {
                    _horizontalScrollBar.visible = true;
                    if (contains(_horizontalScrollBar))
                    {
                        _horizontalScrollBar.x = 0;
                        _horizontalScrollBar.y = height - ScrollBar.WIDTH;
                        _horizontalScrollBar.width = availableWidth;
                    }
                }
                else
                {
                    _horizontalScrollBar.visible = false;
                }

                _horizontalScrollBar.setScrollProperties(availableWidth, 0, (useFixedHorizontalScrolling) ? _maxHorizontalScrollPosition : contentWidth - availableWidth, horizontalPageScrollSize);
                setHorizontalScrollPosition(_horizontalScrollBar.scrollPosition, false);
            }

            contentScrollRect = scrollRect;
            contentScrollRect.width = availableWidth;
            contentScrollRect.height = availableHeight;
            scrollRect = contentScrollRect;
        }


        protected function drawScrollRect():void
        {
            var rect:Rectangle = scrollRect;
            rect.x = _horizontalScrollPosition;

            rect.y = _verticalScrollPosition;
            scrollRect = rect;
        }

        /**
         * 计算可见大小
         *
         */
        protected function calculateAvailableSize():void
        {
            //overriden by subclasses
            availableHeight = height;
            availableWidth = width;
        }

        /**
         * 计算内容大小
         *
         */
        protected function calculateContentWidth():void
        {
            // Meant to be overriden by subclasses
        }

        protected function updateChildren():void
        {
            if (_verticalScrollBar)
            {
                _verticalScrollBar.enabled = enabled;
                _verticalScrollBar.draw();
            }
            if (_horizontalScrollBar)
            {
                _horizontalScrollBar.enabled = enabled;
                _horizontalScrollBar.draw();
            }
        }


        override protected function doDestroy():void
        {
            super.doDestroy();
            if (_horizontalScrollBar)
            {
                _horizontalScrollBar.destroy();
                _horizontalScrollBar = null;
            }
            if (_verticalScrollBar)
            {
                _verticalScrollBar.destroy();
                _verticalScrollBar = null;
            }
        }
    }
}