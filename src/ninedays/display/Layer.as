package ninedays.display
{
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.utils.Dictionary;
    
    import ninedays.data.AlignInfo;
    
	/**
	 * 层，增加对child的布局，通过appendChild调用，布局属性center,left,right,middle,top,bottom。
	 * @author riggzhuo
	 * 
	 */
    public class Layer extends NoScaleSprite
    {
        protected var _alignInfosMap:Dictionary;

        public function Layer()
        {
        }

        override public function removeChild(child:DisplayObject):DisplayObject
        {
			if(_alignInfosMap)
			{
				_alignInfosMap[child] = null;
				delete _alignInfosMap[child];
			}
            
            return super.removeChild(child);
        }

        override public function removeChildAt(index:int):DisplayObject
        {
            var child:DisplayObject = super.removeChildAt(index);
            if (child && _alignInfosMap)
            {
                _alignInfosMap[child] = null;
                delete _alignInfosMap[child];
            }
            return child;
        }

		/**
		 * 添加孩子 
		 * @param child
		 * @param alignInfo	布局属性
		 * 
		 */	
        public function appendChild(child:DisplayObject, alignInfo:AlignInfo):void
        {
            addChild(child);

            if (alignInfo)
            {
                var willAddToMap:Boolean = false;
                if (!isNaN(alignInfo.x))
                {
                    child.x = alignInfo.x;
                }
                else if (alignInfo.center || isNaN(alignInfo.left) == false || isNaN(alignInfo.right) == false)
                {
                    willAddToMap = true;
                }

                if (!isNaN(alignInfo.y))
                {
                    child.x = alignInfo.y;
                }
				else if (alignInfo.middle || isNaN(alignInfo.top) == false || isNaN(alignInfo.bottom) == false)
                {
                    willAddToMap = true;
                }
				
				if(_alignInfosMap == null)
				{
					_alignInfosMap = new Dictionary();
				}

                if (willAddToMap)
                {
                    _alignInfosMap[child] = alignInfo;
                    alignChild(child, alignInfo);
                }
            }
        }
		
		override protected function onResize():void
		{
			if(_alignInfosMap)
			{
				for(var child:* in _alignInfosMap)
				{
					alignChild(child as DisplayObject, _alignInfosMap[child]);
				}
			}
		}

        protected function alignChild(child:DisplayObject, alignInfo:AlignInfo):void
        {
			child.x = AlignInfo.getXPosition(_width, child.width, alignInfo);
			child.y = AlignInfo.getYPosition(_height, child.height, alignInfo);
        }
    }
}