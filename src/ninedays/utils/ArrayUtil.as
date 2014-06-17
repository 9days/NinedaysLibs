package ninedays.utils
{

    public class ArrayUtil
    {
		/**
		 * 得到数组里的匹配项 
		 * @param inArray	数组
		 * @param key	键
		 * @param match	匹配值
		 * @return 
		 * 
		 */		
        public static function getItemsByKey(inArray:Array, key:String, match:Object):Array
        {
            var item:Object;
            var result:Array = [];
            for each (item in inArray)
            {
                if (item.hasOwnProperty(key))
                {
                    if (item[key] == match)
                    {
                        result.push(item);
                    }
                }
            }
            return result;
        }
		
		/**
		 * 俩数组是否相等 
		 * @param arr1	数组1
		 * @param arr2	数组2
		 * @return 
		 * 
		 */	
		public static function arraysAreEqual(arr1:Array, arr2:Array):Boolean
		{
			if(arr1.length != arr2.length)
			{
				return false;
			}
			
			var len:Number = arr1.length;
			
			for(var i:Number = 0; i < len; i++)
			{
				if(arr1[i] !== arr2[i])
				{
					return false;
				}
			}
			
			return true;
		}
    }
}