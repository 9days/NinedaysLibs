package ninedays.log
{
    import flash.events.Event;

    public class LogEvent extends Event
    {
        private var _level:LogLevel;

        private var _message:String;

        public static const LOG:String = "log";


        public function LogEvent(level:LogLevel, message:String)
        {
            super(LOG);
            _level = level;
            _message = message;
        }

        public function get level():LogLevel
        {
            return _level;
        }

        public function get message():String
        {
            return _message;
        }

        public override function clone():Event
        {
            return new LogEvent(level, message);
        }
    }
}