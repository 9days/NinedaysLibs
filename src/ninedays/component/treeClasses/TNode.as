package ninedays.component.treeClasses
{

    public class TNode extends Object
    {
        protected var _parentNode:BranchNode;

        protected var _nodeLevel:int;

        protected var _parentDataProvider:TreeDataProvider;
		
		public var attributes:Object;

        public function TNode(treeDataProvider:TreeDataProvider)
        {
			_parentDataProvider = treeDataProvider;
			attributes = {};
        }

		/**
		 * 是否可见 
		 * @return 
		 * 
		 */		
        public function isVisible():Boolean
        {
            var nodePointer:BranchNode = _parentNode as BranchNode;

            while (!(nodePointer is RootNode))
            {
                if (!(nodePointer.isOpen()))
                {
                    return false;
                }
                nodePointer = nodePointer.parentNode;
            }

            return true;
        }

        public function drawNode():void
        {
        }

        public function hideNode():void
        {
        }

        public function removeNode():TNode
        {
            this.parentNode.removeChild(this);
            return this;
        }

		/**
		 * 节点等级 
		 * @param value
		 * 
		 */		
        public function set nodeLevel(value:int):void
        {
            if (value == _parentNode.nodeLevel + 1)
            {
                _nodeLevel = value;
            }
        }

        public function get nodeLevel():int
        {
            return _nodeLevel;
        }

        public function set parentNode(value:BranchNode):void
        {
            if (value.children.indexOf(this) >= 0)
            {
                _parentNode = value;
            }
        }

        public function get parentNode():BranchNode
        {
            return _parentNode;
        }
    }
}