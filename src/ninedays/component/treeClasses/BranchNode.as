package ninedays.component.treeClasses
{
	/**
	 * 分支节点（For Tree） 
	 * @author riggzhuo
	 * 
	 */	
    public class BranchNode extends LeafNode
    {
        protected var _children:Array;

        protected var _isOpen:Boolean;

        protected var _nodeState:String;

        public function BranchNode(treeDataProvider:TreeDataProvider)
        {
            super(treeDataProvider);
            _nodeType = TreeDataProvider.BRANCH_NODE;
            _nodeState = TreeDataProvider.CLOSED_NODE;
            _children = [];
            _isOpen = false;
        }

        public function get nodeState():String
        {
            return _nodeState;
        }

        public function isOpen():Boolean
        {
            return _isOpen;
        }

		/**
		 * 可视大小。 
		 * @return 
		 * 
		 */		
        override public function getVisibleSize():int
        {
            var total:int = 0;

            if (!(this.isVisible()))
            {
                return 0;
            }

            if (!(this.isOpen()))
            {
                return 1;
            }

            for each (var child:TNode in _children)
            {
                if (child is LeafNode || !((child as BranchNode).isOpen()))
                {
                    total += 1;
                }
                else if (child is BranchNode && (child as BranchNode).isOpen())
                {
                    total += (child as BranchNode).getVisibleSize();
                }
            }

            return total + 1;
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
				
                if (isOpen())
                {
                    for each (var child:TNode in _children)
                    {
                        child.drawNode();
                    }
                }
            }
        }

        override public function hideNode():void
        {
            if (_parentDataProvider.getItemIndex(this) != -1 && !isVisible())
            {
                _parentDataProvider.removeItem(this);
                for each (var child:TNode in _children)
                {
                    child.hideNode();
                }
            }
        }

        public function closeNode():void
        {
            this._isOpen = false;
            this._nodeState = TreeDataProvider.CLOSED_NODE;
            for each (var child:TNode in _children)
            {
                child.hideNode();
            }
        }

        public function openNode():void
        {
            this._isOpen = true;
            this._nodeState = TreeDataProvider.OPEN_NODE;
            for each (var child:TNode in _children)
            {
                child.drawNode();
            }
        }

        override public function checkForValue(fieldName:String, value:String):TNode
        {
            if (attributes[fieldName] == value)
            {
                return (this as TNode);
            }
            else
            {
                for each (var child:TNode in _children)
                {
                    var foundNode:TNode = (child as LeafNode).checkForValue(fieldName, value);
                    if (foundNode != null)
                    {
                        return foundNode;
                    }
                }
                return null;
            }
        }

        public function openAllChildren():void
        {
            this.openNode();
            for each (var child:TNode in _children)
            {
                if (child is BranchNode)
                {
					(child as BranchNode).openAllChildren();
                }
            }
        }

        public function closeAllChildren():void
        {
            this.closeNode();
            for each (var child:TNode in _children)
            {
                if (child is BranchNode)
                {
                    (child as BranchNode).closeAllChildren();
                }
            }
        }

        public function get children():Array
        {
            return _children;
        }

        public function addChildNodeAt(childNode:TNode, index:int):void
        {
            _children.splice(index, 0, childNode);
            childNode.parentNode = this;
            childNode.nodeLevel = this.nodeLevel + 1;
            if (isOpen() && isVisible())
            {
                childNode.drawNode();
            }
        }

        public function addChildNode(childNode:TNode):void
        {
            addChildNodeAt(childNode, _children.length);
        }

        public function removeChild(child:TNode):TNode
        {
            var childindex:int = _children.indexOf(child);
            if (childindex >= 0)
            {
                child.hideNode();
                _children.splice(childindex, 1);
                return child;
            }
            return null;
        }
    }
}