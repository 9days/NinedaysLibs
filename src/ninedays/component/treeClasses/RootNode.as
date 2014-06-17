package ninedays.component.treeClasses
{
	/**
	 * 根节点（For Tree） 
	 * @author riggzhuo
	 * 
	 */	
    public class RootNode extends BranchNode
    {
        public function RootNode(treeDataProvider:TreeDataProvider)
        {
			super(treeDataProvider);
            _nodeLevel = -1;
            _nodeType = TreeDataProvider.ROOT_NODE;
            _nodeState = TreeDataProvider.OPEN_NODE;
        }

        override public function set nodeLevel(value:int):void
        {

        }

        override public function drawNode():void
        {
            for each (var child:TNode in _children)
            {
                child.drawNode();
            }
        }

        override public function hideNode():void
        {
        }

        override public function addChildNodeAt(childNode:TNode, index:int):void
        {
            _children.splice(index, 0, childNode);
            childNode.parentNode = this as BranchNode;
            childNode.nodeLevel = this.nodeLevel + 1;
            childNode.drawNode();
        }

    }
}