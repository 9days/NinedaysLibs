package ninedays.utils.camera
{
	import flash.display.DisplayObject;

	public class Camera
	{
		protected var _focus:DisplayObject;
		protected var _cameraTarget:ICameraTarget;
		
		public function Camera(target:ICameraTarget, focus:DisplayObject)
		{
			_cameraTarget = target;
			this.focus = focus;
		}
		
		public function set focus(value:DisplayObject):void
		{
			_focus = value;
		}
		
		public function get focus():DisplayObject
		{
			return _focus;
		}
		
		public function update():void
		{
			
		}
	}
}