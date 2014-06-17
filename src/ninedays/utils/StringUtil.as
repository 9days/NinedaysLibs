package ninedays.utils
{

    public class StringUtil
    {
        /**
         * 去除两边空格
         * @param value
         * @return
         *
         */
        public static function trim(value:String):String
        {
            if (value == null)
            {
                return '';
            }
            return value.replace(/^\s+|\s+$/g, '');
        }

        /**
         * 去除左边空格
         * @param value
         * @return
         *
         */
        public static function trimLeft(value:String):String
        {
            if (value == null)
            {
                return '';
            }
            return value.replace(/^\s+/, '');
        }

        /**
         * 去除右边空格
         * @param value
         * @return
         *
         */
        public static function trimRight(value:String):String
        {
            if (value == null)
            {
                return '';
            }
            return value.replace(/\s+$/, '');
        }

        /**
         * 是否数字
         * @param value
         * @return
         *
         */
        public static function isNumeric(value:String):Boolean
        {
            if (value == null)
            {
                return false;
            }
            var regx:RegExp = /^[-+]?\d*\.?\d+(?:[eE][-+]?\d+)?$/;
            return regx.test(value);
        }

        /**
         * 反转
         * @param value
         * @return
         *
         */
        public static function reverse(value:String):String
        {
            if (value == null)
            {
                return '';
            }
            return value.split('').reverse().join('');
        }


        /**
         * 替代
         * example:
         * trace(StringUtils.substitute("${name}: ${say}", {name: "peter", say: "hello"}));
         * output: peter: hello
         *
         * @param str
         * @param replaceMap
         * @return
         *
         */
        public static function substitute(str:String, replaceMap:Object):String
        {
            var usdPrice:RegExp = /\$\{(.+?)\}+/g;
            var index:int = usdPrice.lastIndex;
            var r:Object;
            while (r = usdPrice.exec(str))
            {
                str = str.replace(r[0], replaceMap[r[1]]);
                usdPrice.lastIndex = 0;
            }
            return str;
        }

        /**
         * 获取文件后缀名（小写）
		 * example:
         * trace(StringUtils.getFileExtension("http://helloworld.com/file/a.Swf?0.213"}));
         * output: swf
		 * 
         * @param url
         * @return
         *
         */
        public static function getFileExtension(url:String):String
        {
            var searchString:String = url.indexOf("?") > -1 ? url.substring(0, url.indexOf("?")) : url;
            var finalPart:String = searchString.substring(searchString.lastIndexOf("/"));
            return finalPart.substring(finalPart.lastIndexOf(".") + 1).toLowerCase();
        }
    }
}