package ninedays.log
{

    public class Appender implements IAppender
    {
        private var needsLineFeed:Boolean;

        private var _threshold:LogLevel;

        public function Appender()
        {
            _threshold = LogLevel.TRACE;
        }

        public function set threshold(level:LogLevel):void
        {
            _threshold = level;
        }

        public function get threshold():LogLevel
        {
            return _threshold;
        }

        public function registerLogger(logger:Logger):void
        {
            logger.addEventListener(LogEvent.LOG, handleLogEvent);
        }

        protected function handleLogEvent(event:LogEvent):void
        {
            if (isBelowThreshold(event.level))
            {
                return;
            }
            trace(event.message);
        }

        protected function isBelowThreshold(level:LogLevel):Boolean
        {
            return (level.toValue() < _threshold.toValue());
        }
    }
}