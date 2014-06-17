package ninedays.behaviorTree
{
    public class SequenceNode extends CompositeNode
    {
        override public function set childResult(value:Boolean):void
        {
            if (value == false)
            {
                returnResultToParent(false);
            }
            else
            {
                _currentChildNodeIndex++;
                if (currentChildNode == null)
                {
                    returnResultToParent(true);
                }
                else
                {
                    executeChildNode();
                }
            }
        }
    }
}