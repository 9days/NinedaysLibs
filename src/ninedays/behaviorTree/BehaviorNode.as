package ninedays.behaviorTree
{

    public class BehaviorNode
    {
        public static const INACTIVE:int = 0;

        public static const RUNNING:int = 1;

        public static const SUCCESS:int = 2;

        public static const FAIL:int = 3;


        protected var _state:int;

        internal var parentNode:CompositeNode;


        public function execute():void
        {
            _state = RUNNING;
        }

        public function returnResultToParent(value:Boolean):void
        {
            if (parentNode)
            {
                parentNode.childResult = value;
            }
            _state = SUCCESS;
        }

        public function get isExcuting():Boolean
        {
            return _state == RUNNING;
        }

        public function destroy():void
        {
        }

        public function stop():void
        {
            _state = INACTIVE;
        }
    }
}