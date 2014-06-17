package ninedays.command
{
    import flash.events.IEventDispatcher;
    
    import ninedays.core.IDestroyable;

	/**
	 * 命令接口 
	 * @author riggzhuo
	 * 
	 */	
    public interface ICommand extends IEventDispatcher, IDestroyable
    {
        function get id():String;
		function get stutus():int;

        /**
         * 立即执行
         *
         */
        function execute():void;

        /**
         * 成功函数
         *
         */
        function complete():void;

        /**
         * 失败函数
         *
         */
        function fault():void;
		
		/**
		 * 结束 
		 * 
		 */		
		function end():void;
    }
}