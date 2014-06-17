package ninedays.command
{
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;

	[Event(name="queue_start", type="ninedays.command.QueueEvent")]
	[Event(name="queue_complete", type="ninedays.command.QueueEvent")]
	[Event(name="queue_error", type="ninedays.command.QueueEvent")]
	
    public class Command extends EventDispatcher implements ICommand
    {
		public static const WAIT:uint = 1;
		public static const EXECUTING:uint = 2;
		public static const COMPLETE:uint = 3;
		public static const ERROR:uint = 4;
		
        protected var _id:String;

        protected var _stutus:int;

        protected var _destroyed:Boolean;
		
		public function Command()
		{
			_stutus = WAIT;
		}

        public function get id():String
        {
            return _id;
        }

        public function get stutus():int
        {
            return _stutus;
        }

        public function execute():void
        {
			_stutus = EXECUTING;
			doExecute();
			dispatchEvent(new QueueEvent(QueueEvent.QUEUE_START));
        }
		
		protected function doExecute():void
		{
		}

        public function complete():void
        {
			_stutus = COMPLETE;
			dispatchEvent(new QueueEvent(QueueEvent.QUEUE_COMPLETE));
			end();
        }

        public function fault():void
        {
			_stutus = ERROR;
			dispatchEvent(new QueueEvent(QueueEvent.QUEUE_ERROR));
			end();
        }

        public function end():void
        {
        }

        final public function destroy():void
        {
			if(!_destroyed)
			{
				doDestroy();
				_destroyed = true;
			}
        }

        public function get destroyed():Boolean
        {
            return _destroyed;
        }
		
		protected function doDestroy():void
		{
		}
    }
}