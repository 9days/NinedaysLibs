package ninedays.display
{
	import ninedays.utils.DisplayObjectUtil;

	public class Container extends BaseSprite implements IContainer
	{
		public function Container()
		{
			super();
		}
		
		public function stopAllChildren():void
		{
			DisplayObjectUtil.stopAllMovieClip(this);
		}
	}
}