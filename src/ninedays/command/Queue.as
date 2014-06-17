package ninedays.command
{
    import flash.events.IEventDispatcher;

	[Event(name="child_start", type="ninedays.command.QueueEvent")]
	[Event(name="child_complete", type="ninedays.command.QueueEvent")]
	[Event(name="child_error", type="ninedays.command.QueueEvent")]
	
	/**
	 * 队列 
	 * @author riggzhuo
	 * 
	 */	
    public class Queue extends Command implements IQueue
    {
        protected var _children:Vector.<ICommand>;

		/**同时执行的数量**/
        protected var _maxExecuting:int = 1;

        protected var _executeIndex:int;

		/**正在执行的数量**/
        protected var _executingCount:int;
		
		/**完成的数量**/
		protected var _completeCount:int;
		/**出错的数量**/
		protected var _errorCount:int;
		

        override protected function doExecute():void
        {
            next();
        }

        public function next():Boolean
        {
            if (_executingCount < maxExecuting)
            {
                var child:ICommand = getNextExecuteChild();
                if (child)
                {
                    _executingCount++;
                    addChildListeners(child);
                    child.execute();
                    next();
                    return true;
                }
            }
            return false;
        }
		
		public function set maxExecuting(value:int):void
		{
			if(value > _maxExecuting)
			{
				_maxExecuting = value;
				next();
				return;
			}
			_maxExecuting = value;
		}

        public function get maxExecuting():int
        {
            return _maxExecuting;
        }

        public function addChild(child:ICommand):void
        {
            children.push(child);
            if (stutus == EXECUTING)
            {
                next();
            }
        }

        public function removeChild(child:ICommand):void
        {
            var index:int = children.indexOf(child);
            if (index == -1)
                return;

            children.splice(index, 1);
            if (child.stutus == EXECUTING)
            {
                next();
            }
        }

        protected function addChildListeners(child:ICommand):void
        {
            child.addEventListener(QueueEvent.QUEUE_START, onChildStart);
            child.addEventListener(QueueEvent.QUEUE_COMPLETE, onChildComplete);
            child.addEventListener(QueueEvent.QUEUE_ERROR, onChildError);
        }

        protected function removeChildListeners(child:ICommand):void
        {
            child.removeEventListener(QueueEvent.QUEUE_START, onChildStart);
            child.removeEventListener(QueueEvent.QUEUE_COMPLETE, onChildComplete);
            child.removeEventListener(QueueEvent.QUEUE_ERROR, onChildError);
        }

        protected function onChildStart(event:QueueEvent):void
        {
			var newEvent:QueueEvent = new QueueEvent(QueueEvent.CHILD_START);
			newEvent.child = event.currentTarget as ICommand;
			dispatchEvent(newEvent);
        }

        protected function onChildComplete(event:QueueEvent):void
        {
            var newEvent:QueueEvent = new QueueEvent(QueueEvent.CHILD_COMPLETE);
            newEvent.child = event.currentTarget as ICommand;
            dispatchEvent(newEvent);
            removeChildListeners(newEvent.child);
            _executingCount--;
			_completeCount++;
			
			if(_completeCount + _errorCount >= children.length)
			{
				complete();
			}
			else
			{
				next();
			}
        }

        protected function onChildError(event:QueueEvent):void
        {
			var newEvent:QueueEvent = new QueueEvent(QueueEvent.CHILD_ERROR);
			newEvent.child = event.currentTarget as ICommand;
			dispatchEvent(newEvent);
			
            removeChildListeners(event.currentTarget as ICommand);
            _executingCount--;
			_errorCount++;
			
			if(_completeCount + _errorCount >= children.length)
			{
				complete();
			}
			else
			{
				next();
			}
        }

        public function getChildByID(id:String):ICommand
        {
            for each (var child:ICommand in children)
            {
                if (child.id == id)
                    return child;
            }
            return null;
        }

        public function get children():Vector.<ICommand>
        {
            return _children ||= new Vector.<ICommand>;
        }

        /**
         * 下一个执行的operation
         * @return
         *
         */
        public function getNextExecuteChild():ICommand
        {
            for each (var child:ICommand in _children)
            {
                if (child.stutus == WAIT)
                {
                    return child;
                }
            }
            return null;
        }

        /**
         * 正在执行的operation
         * @return
         *
         */
        public function getExecutingChildren():Vector.<ICommand>
        {
            return getChildrenByStatus(EXECUTING);
        }

        /**
         * 已经完成的operation
         * @return
         *
         */
        public function getCompleteChildren():Vector.<ICommand>
        {
            return getChildrenByStatus(COMPLETE);
        }

        /**
         * 出错的operation
         * @return
         *
         */
        public function getErrorChildren():Vector.<ICommand>
        {
            return getChildrenByStatus(ERROR);
        }

        protected function getChildrenByStatus(status:int):Vector.<ICommand>
        {
            var result:Vector.<ICommand> = new Vector.<ICommand>();
            for each (var child:ICommand in _children)
            {
                if (child.stutus == status)
                {
                    result.push(child);
                }
            }
            return result;
        }
		
		protected function destroyChildCommand(child:ICommand):void
		{
			removeChildListeners(child);
			child.destroy();
		}
		
		public function destroyAllChildren():void
		{
			if(_children)
			{
				while(_children.length)
				{
					destroyChildCommand(_children.pop());
				}
			}
			_stutus = WAIT;
			_executingCount = 0;
			_completeCount = 0;
			_errorCount = 0;
		}
		
		override protected function doDestroy():void
		{
			super.doDestroy();
			destroyAllChildren();
		}
    }
}