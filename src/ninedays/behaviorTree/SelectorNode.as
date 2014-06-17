package ninedays.behaviorTree
{

    public class SelectorNode extends CompositeNode
    {
        public function SelectorNode()
        {
            super();
        }

        override public function set childResult(value:Boolean):void
        {
            if (value == true)
            {
                returnResultToParent(true);
            }
            else
            {
                _currentChildNodeIndex++;
                if (currentChildNode == null)
                {
                    returnResultToParent(false);
                }
                else
                {
                    executeChildNode();
                }
            }
        }

    }
}