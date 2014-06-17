package ninedays.utils.drag
{
    import flash.display.InteractiveObject;
    import flash.events.Event;

    public class DragEvent extends Event
    {
        public static const Drop:String = "DragEvent.Drop";

        public static const MOVE:String = "DragEvent.Move";

        public static const OUT:String = "DragEvent.Out";

        public static const OVER:String = "DragEvent.Over";

        private var _data:Object;

        private var _source:InteractiveObject;


        public function DragEvent(type:String, data:Object, source:InteractiveObject, bubbles:Boolean = true, cancelable:Boolean = false)
        {
            super(type, bubbles, cancelable);

            _data = data;
            _source = source;
        }


        public function get data():Object
        {
            return _data;
        }

        public function get source():InteractiveObject
        {
            return _source;
        }
    }
}