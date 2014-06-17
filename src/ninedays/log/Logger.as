package ninedays.log
{
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;



    public class Logger extends EventDispatcher implements ILogger
    {
        private var _level:LogLevel;


        public function Logger()
        {
            _level = LogLevel.TRACE;
        }

        public function get level():LogLevel
        {
            return _level;
        }

        public function set level(level:LogLevel):void
        {
            _level = level;
        }

        public function isTraceEnabled():Boolean
        {
            return (level.toValue() <= LogLevel.TRACE.toValue());
        }

        public function isDebugEnabled():Boolean
        {
            return (level.toValue() <= LogLevel.DEBUG.toValue());
        }

        public function isInfoEnabled():Boolean
        {
            return (level.toValue() <= LogLevel.INFO.toValue());
        }

        public function isWarnEnabled():Boolean
        {
            return (level.toValue() <= LogLevel.WARN.toValue());
        }

        public function isErrorEnabled():Boolean
        {
            return (level.toValue() <= LogLevel.ERROR.toValue());
        }

        public function isFatalEnabled():Boolean
        {
            return (level.toValue() <= LogLevel.FATAL.toValue());
        }

        public function trace(context:Object, message:String, ... params):void
        {
            if (!isTraceEnabled())
                return;
            dispatch(LogLevel.TRACE, context, message, params);
        }

        public function debug(context:Object, message:String, ... params):void
        {
            if (!isDebugEnabled())
                return;
            dispatch(LogLevel.DEBUG, context, message, params);
        }

        public function info(context:Object, message:String, ... params):void
        {
            if (!isInfoEnabled())
                return;
            dispatch(LogLevel.INFO, context, message, params);
        }

        public function warn(context:Object, message:String, ... params):void
        {
            if (!isWarnEnabled())
                return;
            dispatch(LogLevel.WARN, context, message, params);
        }

        public function error(context:Object, message:String, ... params):void
        {
            if (!isErrorEnabled())
                return;
            dispatch(LogLevel.ERROR, context, message, params);
        }

        public function fatal(context:Object, message:String, ... params):void
        {
            if (!isFatalEnabled())
                return;
            dispatch(LogLevel.FATAL, context, message, params);
        }

        private function dispatch(level:LogLevel, context:Object, message:String, params:Array):void
        {
            dispatchEvent(new LogEvent(level, LogUtil.buildLogMessage(level, context, message, params)));
        }
    }
}