package ninedays.log
{
    import flash.utils.getQualifiedClassName;

    public class LogUtil
    {
        public static function buildLogMessage(level:LogLevel, context:Object, message:String, params:Array):String
        {
            if (params == null)
                return message;

            var className:String = "";
            if (context == null)
            {
                className = "unknow class type or static class";
            }
            else
            {
                className = getQualifiedClassName(context);
				className = className.replace("::", ".");
            }

            for (var i:int = 0; i < params.length; i++)
            {
                var param:* = params[i];
                if (param is Error)
                {
                    var e:Error = param as Error;
                    param = "\n" + e.getStackTrace();
                }
                message = message.replace(new RegExp("\\{" + i + "\\}", "g"), param);
            }
            return pad("[" + level.toString() + "] " + className) + " : " + message;
        }

        private static function pad(str:String):String
        {
            while (str.length < 50)
            {
                str += " ";
            }
            return str;
        }
    }
}