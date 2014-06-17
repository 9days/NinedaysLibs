package ninedays.log
{

    public class LogLevel
    {
        public static const OFF:LogLevel = new LogLevel(100, "OFF");

        public static const FATAL:LogLevel = new LogLevel(16, "FATAL");

        public static const ERROR:LogLevel = new LogLevel(8, "ERROR");

        public static const WARN:LogLevel = new LogLevel(4, "WARN");

        public static const INFO:LogLevel = new LogLevel(2, "INFO");

        public static const DEBUG:LogLevel = new LogLevel(1, "DEBUG");

        public static const TRACE:LogLevel = new LogLevel(0, "TRACE");


        private var _value:uint;

        private var _string:String;

        public function LogLevel(value:uint, name:String)
        {
            _value = value;
            _string = name;
        }

        public function toValue():uint
        {
            return _value;
        }

        public function toString():String
        {
            return _string;
        }
    }
}