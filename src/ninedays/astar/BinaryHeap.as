package ninedays.astar
{

    internal class BinaryHeap
    {
        public var array:Array = [];

        public var justMinFun:Function = function(x:Object, y:Object):Boolean
            {
                return x < y;
            }

        public function BinaryHeap(justMinFun:Function = null)
        {
            array.push(-1);
            if (justMinFun != null)
                this.justMinFun = justMinFun;
        }

        /*public function ins(value:Object):void
           {
           var arrayLength:int = a.length;
           var len:int = arrayLength;
           var index:int = len = len >> 1;
           while (len > 1) {
           len = Math.ceil(len * 0.5 );
           if (index > 0 && index < arrayLength && a[index].f > value.f) {
           index -= len;
           } else {
           index += len;
           }
           }
           a.splice(index, 0, value);
           }

           public function pop():Object
           {
           return a.pop();
         }*/

        public function ins(value:Object):void
        {
            var p:int = array.length;
            array[p] = value;
            var pp:int = p >> 1;
            while (p > 1 && justMinFun(array[p], array[pp]))
            {
                var temp:Object = array[p];
                array[p] = array[pp];
                array[pp] = temp;
                p = pp;
                pp = p >> 1;
            }
        }

        public function pop():Object
        {
            var min:Object = array[1];
            array[1] = array[array.length - 1];
            array.pop();
            var p:int = 1;
            var l:int = array.length;
            var sp1:int = p << 1;
            var sp2:int = sp1 + 1;
            while (sp1 < l)
            {
                if (sp2 < l)
                {
                    var minp:int = justMinFun(array[sp2], array[sp1]) ? sp2 : sp1;
                }
                else
                {
                    minp = sp1;
                }
                if (justMinFun(array[minp], array[p]))
                {
                    var temp:Object = array[p];
                    array[p] = array[minp];
                    array[minp] = temp;
                    p = minp;
                    sp1 = p << 1;
                    sp2 = sp1 + 1;
                }
                else
                {
                    break;
                }
            }
            return min;
        }
		
		public function destroy():void
		{
			array = null;
			justMinFun = null;
		}
    }
}