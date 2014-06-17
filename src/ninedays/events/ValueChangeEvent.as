package ninedays.events
{
    import flash.events.Event;

    public class ValueChangeEvent extends Event
    {
        public var valueName:String;

        public var oldValue:Object;

        public var newValue:Object;

        public static const VALUE_CHANGE:String = "valueChange";

        public function ValueChangeEvent(type:String, valueName:String = "", oldValue:Object = null, newValue:Object = null)
        {
            super(type);
            this.valueName = valueName;
            this.oldValue = oldValue;
            this.newValue = newValue;
        }
    }
}