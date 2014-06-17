package ninedays.display
{
	import ninedays.core.IDestroyable;
	
	public interface IContainer extends IDestroyable
	{
		function stopAllChildren():void;
	}
}