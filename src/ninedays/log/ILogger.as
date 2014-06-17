package ninedays.log
{

    public interface ILogger
    {
        function isTraceEnabled():Boolean;

        function isDebugEnabled():Boolean;

        function isInfoEnabled():Boolean;

        function isWarnEnabled():Boolean;

        function isErrorEnabled():Boolean;

        function isFatalEnabled():Boolean;

        function trace(context:Object, message:String, ... rest):void;

        function debug(context:Object, message:String, ... rest):void;

        function info(context:Object, message:String, ... rest):void;

        function warn(context:Object, message:String, ... rest):void;

        function error(context:Object, message:String, ... rest):void;

        function fatal(context:Object, message:String, ... rest):void;
    }
}