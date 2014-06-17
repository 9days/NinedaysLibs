package ninedays.display
{

    /**
     * 时间轴
     * @author riggzhuo
     *
     */
    public class TimeLine
    {
        protected var _isPlaying:Boolean;

        protected var _repeatCount:uint;

        protected var _totalFrames:uint;

        protected var _currentFrame:uint;

        protected var _time:uint;

        protected var _percent:Number = 0;

        protected var _timeRate:uint = 33;

        protected var _duration:uint;

        protected var _totalTime:uint;

        /**速度，默认为1**/
        public var speed:Number = 1.0;

        public function TimeLine(timeRate:uint = 33)
        {
            _timeRate = timeRate;
        }

        /**
         * 重置
         *
         */
        public function reset():void
        {
            _currentFrame = 0;
            _time = 0;
            _percent = 0;
        }

        /**
         * 当前时间
         * @return
         *
         */
        public function get time():uint
        {
            return _time;
        }

        /**
         * 进度百分比
         * @return
         *
         */
        public function get percent():Number
        {
            return _percent;
        }

        public function set percent(value:Number):void
        {
            if (value > 1)
            {
                value = 1;
            }
            else if (value < 0)
            {
                value = 0;
            }
            _percent = value;
            if (_duration > 0)
            {
                _time = _percent * _duration;
                updateForTime();
            }
            else if (_totalTime > 0)
            {
                _time = _percent * _totalTime;
                updateForTime();
            }
        }

        /**
         * 持续时间
         * @return
         *
         */
        public function get duration():uint
        {
            return _duration;
        }

        public function set duration(value:uint):void
        {
            _duration = value;
            setTotalTime();
        }

        /**
         * 重复次数
         * @return
         *
         */
        public function get repeatCount():uint
        {
            return _repeatCount;
        }

        public function set repeatCount(value:uint):void
        {
            _repeatCount = value;
            setTotalTime();
        }

        /**
         * 一帧的时间
         * @return
         *
         */
        public function get timeRate():uint
        {
            return _timeRate;
        }

        public function set timeRate(value:uint):void
        {
            _timeRate = value;
            setTotalTime();
        }

        public function setInterval(value:uint):Boolean
        {
            if (!_isPlaying)
                return false;

            return setTime(_time + value * speed);
        }

        public function setTime(value:uint):Boolean
        {
            _time = value;
            if (_duration > 0)
            {
                if (_time >= _duration)
                {
                    _percent = 1;
                    return false;
                }
                _percent = _time / _duration;
            }
            else if (_totalTime > 0)
            {
                if (_repeatCount > 0)
                {
                    if (_time >= _totalTime)
                    {
                        _percent = 1;
                        return false;
                    }
                }
                _percent = _time / _totalTime;
            }
            updateForTime();
            return true;
        }

        protected function setTotalTime():void
        {
            if (_duration > 0)
            {
                if (_repeatCount > 0)
                {
                    _totalTime = _duration / _repeatCount;
                }
                else
                {
                    _totalTime = _totalFrames * _timeRate;
                }
            }
            else if (_totalFrames > 0)
            {
                _totalTime = _totalFrames * _timeRate;
            }
        }

        protected function updateForTime():void
        {
            if (_totalFrames > 0)
            {
                var _frame:int = Math.round(_time % _totalTime / _totalTime * _totalFrames) + 1;
                if (_frame > _totalFrames)
                {
                    _frame = _totalFrames;
                }
                if (_currentFrame == _frame)
                {
                    return;
                }
                _currentFrame = _frame;
                update();
            }
        }

        /**
         * 总帧数
         * @return
         *
         */
        public function get totalFrames():uint
        {
            return _totalFrames;
        }

        /**
         * 当前帧
         * @return
         *
         */
        public function get currentFrame():uint
        {
            return _currentFrame;
        }

        public function set currentFrame(value:uint):void
        {
            if (_currentFrame == value)
            {
                return;
            }
            _currentFrame = value;
            if (_totalFrames > 0)
            {
                if (_currentFrame > _totalFrames)
                {
                    _currentFrame = _totalFrames;
                }
                update();
            }
        }

        /**
         * 开始播放
         *
         */
        public function play():void
        {
            _isPlaying = true;
        }

        /**
         * 停止播放
         *
         */
        public function stop():void
        {
            _isPlaying = false;
        }

        /**
         * 上一帧
         *
         */
        public function prevFrame():void
        {
            if (_totalFrames > 1)
            {
                currentFrame = _currentFrame - 1;
                if (_currentFrame < 0)
                {
                    currentFrame = _totalFrames;
                }
            }
        }

        /**
         * 下一帧
         *
         */
        public function nextFrame():void
        {
            if (_totalFrames > 1)
            {
                currentFrame = _currentFrame + 1;
                if (_currentFrame == _totalFrames)
                {
                    currentFrame = 1;
                }
            }
        }

        /**
         * 更新
         *
         */
        protected function update():void
        {
        }
    }
}