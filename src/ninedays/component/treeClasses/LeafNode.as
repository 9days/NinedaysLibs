package ninedays.component.treeClasses
{

	/**
	 * 叶子节点（For Tree） 
	 * @author riggzhuo
	 * 
	 */	
    public class LeafNode extends TNode
    {
        protected var _nodeType:String;
		
        public function LeafNode(treeDataProvider:TreeDataProvider)
        {
            super(treeDataProvider);
            _nodeType = TreeDataProvider.LEAF_NODE;
        }

        public function get nodeType():String
        {
            return _nodeType;
        }

        public function checkForValue(fieldName:String, value:String):TNode
        {
            if (attributes[fieldName] == value)
            {
                return (this as TNode);
            }
            else
            {
                return null;
            }
        }

        public function getVisibleSize():int
        {
            return 1;
        }

        override public function drawNode():void
        {
            if (_parentDataProvider.getItemIndex(this) == -1 && isVisible())
            {
                var myIndex:int = _parentNode.children.indexOf(this);
                var actualIndex:int = 0;
                for (var i:int = 0; i < myIndex; i++)
                {
                    actualIndex += _parentNode.children[i].getVisibleSize();
                }
                if (_parentNode is RootNode)
                {
                    if (_parentDataProvider.length > 0)
                    {
                        _parentDataProvider.addItemAt(this, actualIndex);
                    }
                    else
                    {
                        _parentDataProvider.addItem(this);
                    }
                }
                else
                {
                    var parentIndex:int = _parentDataProvider.getItemIndex(_parentNode);
                    _parentDataProvider.addItemAt(this, parentIndex + actualIndex + 1);
                }
            }
        }

        override public function hideNode():void
        {
            if (_parentDataProvider.getItemIndex(this) != -1 && !isVisible())
            {
                _parentDataProvider.removeItem(this);
            }
        }
    }
}