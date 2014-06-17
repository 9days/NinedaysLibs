package ninedays.component
{
    import flash.events.MouseEvent;

    public class BaseButton extends Component
    {
        public function BaseButton()
        {
        }

        override protected function addListeners():void
        {
            this.addEventListener(MouseEvent.ROLL_OVER, mouseHandle);
            this.addEventListener(MouseEvent.ROLL_OUT, mouseHandle);
            this.addEventListener(MouseEvent.MOUSE_DOWN, mouseHandle);
            this.addEventListener(MouseEvent.MOUSE_UP, mouseHandle);
        }

        protected function mouseHandle(e:MouseEvent):void
        {
            switch (e.type)
            {
                case MouseEvent.MOUSE_DOWN:
                    toMouseDownState();
                    break;
                case MouseEvent.MOUSE_UP:
                    toMouseUpState();
                    break;
                case MouseEvent.ROLL_OVER:
                    toMouseOverState();
                    break;
                case MouseEvent.ROLL_OUT:
                    toMouseOutState();
                    break;
            }
        }

        protected function toMouseDownState():void
        {
        }

        protected function toMouseUpState():void
        {
        }

        protected function toMouseOverState():void
        {
        }

        protected function toMouseOutState():void
        {
        }
    }
}