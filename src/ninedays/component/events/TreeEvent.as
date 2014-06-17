package ninedays.component.events
{
    import flash.events.Event;
    
    import ninedays.component.listClasses.IItemRenderer;

    public class TreeEvent extends Event
    {
        public static const ITEM_CLOSE:String = "itemClose";

        public static const ITEM_OPEN:String = "itemOpen";

        public function TreeEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, item:Object = null, itemRenderer:IItemRenderer = null, triggerEvent:Event = null)
        {
            super(type, bubbles, cancelable);

            this.item = item;
            this.itemRenderer = itemRenderer;
            this.triggerEvent = triggerEvent;
        }

        public var item:Object;

        public var itemRenderer:IItemRenderer;

        public var triggerEvent:Event;

        override public function clone():Event
        {
            return new TreeEvent(type, bubbles, cancelable, item, itemRenderer, triggerEvent);
        }
    }
}