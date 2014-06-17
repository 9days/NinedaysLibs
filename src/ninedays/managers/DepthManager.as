package ninedays.managers
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.utils.Dictionary;

	/**
	 * 深度管理器 
	 * @author riggzhuo
	 * 
	 */	
    public class DepthManager
    {
        private static var managers:Dictionary;

        private var depths:Dictionary;

        public function DepthManager()
        {
            super();
            this.depths = new Dictionary(true);
        }

        public static function getManager(container:DisplayObjectContainer):DepthManager
        {
            if (!managers)
            {
                managers = new Dictionary(true);
            }
            var m:DepthManager = managers[container];
            if (!m)
            {
                m = new DepthManager();
                managers[container] = m;
            }
            return m;
        }

        public static function swapDepth(child:DisplayObject, depth:Number):int
        {
            return getManager(child.parent).swapChildDepth(child, depth);
        }

		/**
		 * 排序所有孩子 
		 * @param container	容器
		 * 
		 */		
        public static function swapDepthAll(container:DisplayObjectContainer):void
        {
            var child:DisplayObject = null;
            var i:int = 0;
			var dm:DepthManager = getManager(container);
            var len:int = container.numChildren;
            var arr:Array = [];
            i = 0;
            while (i < len)
            {
                child = container.getChildAt(i);
                arr.push(child);
                i++;
            }
            arr.sortOn("y", Array.NUMERIC);
            arr.forEach(function(item:DisplayObject, index:int, array:Array):void
                {
                    container.setChildIndex(item, index);
                    dm.setDepth(item, item.y);
                });
            arr = null;
        }

		/**
		 * 清除管理器 
		 * @param container
		 * 
		 */		
        public static function clear(container:DisplayObjectContainer):void
        {
			managers[container] = null;
            delete managers[container];
        }

		/**
		 * 清除所有 
		 * 
		 */		
        public static function clearAll():void
        {
            managers = null;
        }

		/**
		 * 移到底层 
		 * @param mc
		 * 
		 */		
        public static function bringToBottom(mc:DisplayObject):void
        {
            var parent:DisplayObjectContainer = mc.parent;
            if (parent == null)
            {
                return;
            }
            if (parent.getChildIndex(mc) != 0)
            {
                parent.setChildIndex(mc, 0);
            }
        }

		/**
		 * 移到顶层 
		 * @param mc
		 * 
		 */		
        public static function bringToTop(mc:DisplayObject):void
        {
            var parent:DisplayObjectContainer = mc.parent;
            if (parent == null)
            {
                return;
            }
            parent.addChild(mc);
        }

        public function getDepth(child:DisplayObject):Number
        {
            if (this.depths[child] == null)
            {
                return this.countDepth(child, child.parent.getChildIndex(child), 0);
            }
            return this.depths[child];
        }

        private function countDepth(child:DisplayObject, index:int, n:Number = 0):Number
        {
            if (this.depths[child] == null)
            {
                if (index == 0)
                {
                    return 0;
                }
                return this.countDepth(child.parent.getChildAt((index - 1)), index - 1, n + 1);
            }
            return this.depths[child] + n;
        }

        public function setDepth(child:DisplayObject, d:Number):void
        {
            this.depths[child] = d;
        }

        public function swapChildDepth(child:DisplayObject, depth:Number):int
        {
            var mid:int;
            var midDepth:Number;
            var container:DisplayObjectContainer = child.parent;
            if (container == null)
            {
                throw(new Error("child is not in a container!!"));
            }
            var index:int = container.getChildIndex(child);
            var oldDepth:Number = this.getDepth(child);
            if (depth == oldDepth)
            {
                this.setDepth(child, depth);
                return index;
            }
            var n:int = container.numChildren;
            if (n < 2)
            {
                this.setDepth(child, depth);
                return index;
            }
            if (depth < this.getDepth(container.getChildAt(0)))
            {
                container.setChildIndex(child, 0);
                this.setDepth(child, depth);
                return 0;
            }
            if (depth >= this.getDepth(container.getChildAt((n - 1))))
            {
                container.setChildIndex(child, (n - 1));
                this.setDepth(child, depth);
                return n - 1;
            }
            var left:int;
            var right:int = n - 1;
            if (depth > oldDepth)
            {
                left = index;
                right = n - 1;
            }
            else
            {
                left = 0;
                right = index;
            }
            while (right > left + 1)
            {
                mid = left + (right - left) * 0.5;
                midDepth = this.getDepth(container.getChildAt(mid));
                if (midDepth > depth)
                {
                    right = mid;
                }
                else
                {
                    if (midDepth < depth)
                    {
                        left = mid;
                    }
                    else
                    {
                        container.setChildIndex(child, mid);
                        this.setDepth(child, depth);
                        return mid;
                    }
                }
            }
			
            var leftDepth:Number = this.getDepth(container.getChildAt(left));
            var rightDepth:Number = this.getDepth(container.getChildAt(right));
            var destIndex:int;
            if (depth >= rightDepth)
            {
                if (index <= right)
                {
                    destIndex = Math.min(right, n - 1);
                }
                else
                {
                    destIndex = Math.min(right + 1, n - 1);
                }
            }
            else
            {
                if (depth < leftDepth)
                {
                    if (index < left)
                    {
                        destIndex = Math.max(left - 1, 0);
                    }
                    else
                    {
                        destIndex = left;
                    }
                }
                else
                {
                    if (index <= left)
                    {
                        destIndex = left;
                    }
                    else
                    {
                        destIndex = Math.min(left + 1, n - 1);
                    }
                }
            }
            container.setChildIndex(child, destIndex);
            this.setDepth(child, depth);
            return destIndex;
        }
    }
}