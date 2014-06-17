package ninedays.utils
{
    import flash.display.DisplayObject;
    import flash.display.Sprite;

    /**
     * 快速深度排序(二分算法优化)
     *
     */
    public final class DepthSort
    {
        private var _layer:Sprite;

        public function DepthSort(layer:Sprite)
        {
            _layer = layer;
        }

		/**
		 * 使用二分插入显示对象
		 * @param value
		 * 
		 */		
        public function add(value:DisplayObject):void
        {
            if (value.parent == _layer)
            {
                return;
            }
            _layer.addChildAt(value, getIndex(value, 0, _layer.numChildren - 1));
        }

		/**
		 * 使用二分查找重置深度 
		 * @param value
		 * 
		 */		
        public function reset(value:DisplayObject):void
        {
            if (value.parent != _layer)
            {
                return;
            }
            var index:int = _layer.getChildIndex(value);
            if (index > 0 && compare(value, _layer.getChildAt(index - 1)) < 0)
            {
                if (index == 1)
                {
                    _layer.setChildIndex(value, 0);
                    return;
                }
                _layer.setChildIndex(value, getIndex(value, 0, index - 1));
                return;
            }
            var right:int = _layer.numChildren - 1;
            if (index < right && compare(value, _layer.getChildAt(index + 1)) > 0)
            {
                if (index + 1 == right)
                {
                    _layer.setChildIndex(value, right);
                    return;
                }
                var result:int = getIndex(value, index + 1, right) - 1;
                _layer.setChildIndex(value, result);
            }
        }
		
		/**
		 * 比较深度
		 * @param source
		 * @param target
		 * @return 
		 * 
		 */		
		private function compare(source:DisplayObject, target:DisplayObject):int
		{
			if (source.y > target.y)
			{
				return 1;
			}
			if (source.y < target.y)
			{
				return -1;
			}
			return 1;
		}
		
		/**
		 * 二分查找
		 * @param value
		 * @param left
		 * @param right
		 * @return 
		 * 
		 */		
		private function getIndex(value:DisplayObject, left:int, right:int):int
		{
			var result:int;
			while (left <= right)
			{
				var mid:int = (left + right) >> 1;
				result = compare(value, _layer.getChildAt(mid));
				if (result > 0)
				{
					left = mid + 1;
				}
				else
				{
					right = mid - 1;
				}
			}
			return left;
		}
    }
}