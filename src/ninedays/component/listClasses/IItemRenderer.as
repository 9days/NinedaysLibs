package ninedays.component.listClasses
{
    import flash.events.IEventDispatcher;
    
    import ninedays.core.IDestroyable;
    import ninedays.display.mediator.IButtonSelectable;

    public interface IItemRenderer extends IEventDispatcher, IDestroyable, IButtonSelectable
    {
        function set x(value:Number):void;
        function set y(value:Number):void;
        function set width(value:Number):void;
        function set height(value:Number):void;
        function set itemWidth(value:uint):void;
        function get itemWidth():uint;
        function set itemHeight(value:uint):void;
        function get itemHeight():uint;
        function set data(value:Object):void;
        function get data():Object;
        function set listData(value:ListData):void;
        function get listData():ListData;
		function set index(value:int):void;
		function get index():int;
    }
}