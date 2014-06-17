package ninedays.behaviorTree
{

    public class CompositeNode extends LeafNode
    {
        protected var _childNodes:Vector.<BehaviorNode>;

        protected var _currentChildNodeIndex:int = 0;

        public function CompositeNode()
        {
            _childNodes = new Vector.<BehaviorNode>();
        }

        public function set childResult(value:Boolean):void
        {
        }

        public function addChildNode(node:BehaviorNode):void
        {
            this._childNodes.push(node);
            node.parentNode = this;
        }

        override public function execute():void
        {
            super.execute();
            _currentChildNodeIndex = 0;
            executeChildNode();
        }

        public function executeChildNode():void
        {
            currentChildNode.execute();
        }

        protected function get currentChildNode():BehaviorNode
        {
            if (_childNodes == null)
            {
                throw new Error("child nodes is empty!");
            }
            if (_currentChildNodeIndex >= _childNodes.length)
            {
                return null;
            }
            return _childNodes[_currentChildNodeIndex];
        }
    }
}