package ninedays.component.events
{
    import flash.events.Event;

    public class ScrollEvent extends Event
    {
        public static const SCROLL:String = "scroll";


        public var position:Number;

        public var oldPosition:Number;

        public var percent:Number;

        public var direction:String;

        public function ScrollEvent(direction:String, position:Number, oldPosition:Number, percent:Number)
        {
            super(SCROLL, false, false);
            this.direction = direction;
            this.position = position;
            this.oldPosition = oldPosition;
            this.percent = percent;
        }
    }
}