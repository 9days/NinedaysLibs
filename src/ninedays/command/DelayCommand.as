package ninedays.command
{
	import flash.utils.setTimeout;

	/**
	 * 延迟命令 
	 * @author riggzhuo
	 * 
	 */	
	public class DelayCommand extends Command
	{
		protected var _millisecond:int;
		
		public function DelayCommand(millisecond:int)
		{
			_millisecond = millisecond;
		}
		
		override public function execute():void
		{
			_stutus = EXECUTING;
			setTimeout(doExecute, _millisecond);
			dispatchEvent(new QueueEvent(QueueEvent.QUEUE_START));
		}
	}
}