package ninedays.component.defaultSkin
{
	import ninedays.component.Button;

	public class DefaultScrollTrack extends Button
	{
		override protected function creatChildren():void
		{
			setStyle("upColor", 0XCCCCCC);
			setStyle("overColor", 0x999999);
			setStyle("downColor", 0x666666);
			super.creatChildren();
		}
	}
}