package ninedays.command
{

    public interface IQueue extends ICommand
    {
        /**
         * 推入队列
         *
         */
        function addChild(child:ICommand):void;

        /**
         * 移出队列
         *
         */
        function removeChild(child:ICommand):void;
		
		function next():Boolean;
		
		function get maxExecuting():int;
		
		function get children():Vector.<ICommand>;
		
		function getChildByID(id:String):ICommand;
    }
}