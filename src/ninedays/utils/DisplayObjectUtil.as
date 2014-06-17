package ninedays.utils
{
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.MovieClip;

    public class DisplayObjectUtil
    {
        /**
         * 获得子对象数组
         * @param container
         *
         */
        public static function getChildren(container:DisplayObjectContainer):Array
        {
            var result:Array = [];
            for (var i:int = 0; i < container.numChildren; i++)
                result.push(container.getChildAt(i));

            return result;
        }

        /**
         * 移除所有子对象
         * @param container	目标
         *
         */
        public static function removeAllChildren(container:DisplayObjectContainer):void
        {
            while (container.numChildren)
                container.removeChildAt(0);
        }

        public static function removeForParent(view:DisplayObject, gc:Boolean = true):void
        {
            var container:DisplayObjectContainer;
            if (view == null)
            {
                return;
            }
            if (view.parent == null)
            {
                return;
            }
            if (gc)
            {
                container = (view as DisplayObjectContainer);
                if (container)
                {
                    stopAllMovieClip(container);
                    container = null;
                }
            }
            view.parent.removeChild(view);
        }

        public static function stopAllMovieClip(container:DisplayObjectContainer, frame:uint = 0):void
        {
            var child:DisplayObjectContainer;
            var mc:MovieClip = container as MovieClip;
            if (mc)
            {
                if (frame > 0)
                {
                    mc.gotoAndStop(frame);
                }
                else
                {
                    mc.stop();
                }
                mc = null;
            }
            var num:int = container.numChildren;
            for (var i:int = 0; i < num; i++)
            {
                child = container.getChildAt(i) as DisplayObjectContainer;
                if (child != null)
                {
                    stopAllMovieClip(child, frame);
                }
            }
        }
    }
}