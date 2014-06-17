package ninedays.component
{
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;

    public class Label extends Component
    {
        protected var _autoSize:Boolean = true;

        protected var _text:String = "";

        protected var _textfield:TextField;

        public function Label(text:String = "")
        {
            this.text = text;
			mouseEnabled = false;
			mouseChildren = false;
        }

        override protected function creatChildren():void
        {
            _height = 18;
            _textfield = new TextField();
            _textfield.selectable = false;
            _textfield.mouseEnabled = false;
            _textfield.defaultTextFormat = new TextFormat(null, 12);
            _textfield.text = _text;
            addChild(_textfield);
        }

        override public function draw():void
        {
            super.draw();
            _textfield.text = _text;
            if (_autoSize)
            {
                _textfield.autoSize = TextFieldAutoSize.LEFT;
                _width = _textfield.width;
            }
            else
            {
                _textfield.autoSize = TextFieldAutoSize.NONE;
                _textfield.width = _width;
            }
            _textfield.height = _height;
        }

        public function set text(t:String):void
        {
            if (_text != t)
            {
                _text = t;
                if (_text == null)
                {
                    _text = "";
                }
                invalidate();
            }
        }

        public function get text():String
        {
            return _text;
        }

        public function set autoSize(b:Boolean):void
        {
            if (_autoSize != b)
            {
                _autoSize = b;
                invalidate();
            }
        }

        public function get autoSize():Boolean
        {
            return _autoSize;
        }

        public function get textField():TextField
        {
            return _textfield;
        }
    }
}