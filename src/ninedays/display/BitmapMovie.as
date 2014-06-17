package ninedays.display
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.filters.GlowFilter;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.utils.ByteArray;
    import flash.utils.getTimer;
    
    import ninedays.core.IDestroyable;
    import ninedays.core.Tick;

    public class BitmapMovie extends TimeLine implements IDestroyable
    {
        protected var frames:Vector.<BitmapFrame>;

        /**
         * 当前帧
         */
        protected var _currentBitmapFrame:BitmapFrame;

        protected var _content:Sprite;

        protected var _bitmap:Bitmap;

        protected var _needPain:Boolean;

        protected var _isDestroyed:Boolean;

        /**
         * 位图序列动画渲染器构造函数
         * @param	frames 默认帧序列
         *
         */
        public function BitmapMovie(frames:Vector.<BitmapFrame> = null)
        {
            super();
            _needPain = false;
            _content = new Sprite();
            _bitmap = new Bitmap(null, "auto", true);
            _content.addChild(_bitmap);
            frameList = frames;

            Tick.instance.register(onTick);
        }


        public function get content():DisplayObject
        {
            return _content;
        }


        public function set frameList(value:Vector.<BitmapFrame>):void
        {
            frames = value;
            if (value == null)
            {
                if (_bitmap)
                {
                    _bitmap.bitmapData = null;
                }
                return;
            }
            _totalFrames = frames.length;
            _currentFrame = 1;
            setTotalTime();
            update();
        }


        /**
         * 当前帧标签，类似MovieClip的currentFrameLabel属性
         *
         */
        public function get currentFrameLabel():String
        {
            return frames[_currentFrame - 1].frameLabel;
        }

        /**
         * 是否正在播放
         *
         */
        public function get isPlay():Boolean
        {
            return _isPlaying;
        }

        protected function onTick(interval:int):void
        {
            if (setInterval(interval) == false && _needPain)
            {
                paint();
//                _currentFrame++;
//                if (_currentFrame > _totalFrames)
//                    _currentFrame = 1;
//                _gotoFrame(_currentFrame);
            }
        }


        override protected function update():void
        {
            _currentBitmapFrame = frames[_currentFrame - 1];
            paint();
        }


        protected function paint():void
        {
            if (needPaint)
            {
                _bitmap.bitmapData = _currentBitmapFrame.bitmapData;
                _bitmap.smoothing = true;
                _bitmap.x = _currentBitmapFrame.x;
                _bitmap.y = _currentBitmapFrame.y;
                _needPain = false;
            }
            else if (!_needPain)
            {
                _bitmap.bitmapData = null;
                _needPain = true;
            }
        }


        protected function get needPaint():Boolean
        {
            return _bitmap.visible && _bitmap.stage;
        }

        /**
         * 跳转到目标帧开始播放
         * @param	target  如果是int则表示帧索引，从1到totalFrames,如果是String表示存在的帧标签
         *
         */
        public function gotoAndPlay(target:*):void
        {
            _gotoFrame(target);
            if (!_isPlaying)
            {
                play();
            }
        }

        /**
         * 跳转到目标帧并停止播放
         * @param	target  如果是int则表示帧索引，从1到totalFrames,如果是String表示存在的帧标签
         *
         */
        public function gotoAndStop(target:*):void
        {
            _gotoFrame(target);
            if (_isPlaying)
            {
                stop();
            }
        }

        /**
         * 前往目标帧
         */
        protected function _gotoFrame(target:*):void
        {
            if (target is int)
            {
                if (target <= _totalFrames || target > 0)
                {
                    _currentFrame = target;
                }
                else
                {
                    throw new ArgumentError("帧索引超出范围！");
                }
            }
            else if (target is String)
            {
                for (var i:int = 0; i < frames.length; i++)
                {
                    var frame:BitmapFrame = frames[i];
                    if (frame.frameLabel == target)
                    {
                        _currentFrame = i + 1;
                        break;
                    }
                }
            }
            if (_currentBitmapFrame != frames[_currentFrame - 1])
            {
                _currentBitmapFrame = frames[_currentFrame - 1];
                paint();
            }
        }

        /**
         * 检查是否真正需要响应鼠标事件
         */
        public function hasPixel(x:int, y:int):Boolean
        {
            if (_bitmap.bitmapData)
            {
                var color:uint = _bitmap.bitmapData.getPixel32(x, y);
                return color > 0;
            }
            else
            {
                return false;
            }
        }


        public function set x(value:int):void
        {
            _content.x = value;
        }

        public function get x():int
        {
            return _content.x;
        }

        public function set y(value:int):void
        {
            _content.y = value;
        }

        public function get y():int
        {
            return _content.y;
        }

        /**
         * 克隆
         * @return 	克隆对象
         *
         */
        public function clone():BitmapMovie
        {
            var movie:BitmapMovie = new BitmapMovie(frames);
            return movie;
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
            _isPlaying = false;
            frames = null;
            if (_bitmap)
            {
                _bitmap.bitmapData = null;
                _bitmap = null;
            }
            _currentBitmapFrame = null;
            Tick.instance.unregister(onTick);
        }
    }
}
