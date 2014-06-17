package ninedays.log
{
    public interface IAppender
    {
        function set threshold(level:LogLevel):void;

        function get threshold():LogLevel;

        function registerLogger(logger:Logger):void;
    }
}