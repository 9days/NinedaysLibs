package ninedays.command
{
    import flash.events.Event;

    public class QueueEvent extends Event
    {
        public static const QUEUE_START:String = "queue_start";

        public static const QUEUE_COMPLETE:String = "queue_complete";

        public static const QUEUE_ERROR:String = "queue_error";

        public static const CHILD_START:String = "child_start";

        public static const CHILD_COMPLETE:String = "child_complete";

        public static const CHILD_ERROR:String = "child_error";

        public var child:ICommand;

        public function QueueEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            super(type, bubbles, cancelable);
        }
    }
}