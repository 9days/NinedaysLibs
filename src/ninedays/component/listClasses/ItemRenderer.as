package ninedays.component.listClasses
{
    import flash.display.DisplayObject;
    import flash.display.Graphics;
    import flash.events.MouseEvent;
    
    import ninedays.component.List;
    import ninedays.component.Button;
    import ninedays.component.style.StyleManager;

    public class ItemRenderer extends Button implements IItemRenderer
    {
        protected var _data:Object;

        protected var _selected:Boolean;

        protected var _index:int;

        protected var _listData:ListData;

        protected var icon:DisplayObject;

        public function ItemRenderer()
        {
            super();
            creatChildren();
            addListeners();
        }

        override protected function setShape(g:Graphics, color:uint):void
        {
            g.clear();
            g.beginFill(color);
            g.drawRect(0, 0, 10, 10);
            g.endFill();
        }

        public function set selected(value:Boolean):void
        {
            if (value != _selected)
            {
                value ? toMouseDownState() : toMouseUpState();

                _selected = value;
            }
        }

        public function get selected():Boolean
        {
            return _selected;
        }

        public function set data(value:Object):void
        {
            _data = value;
            if (value is String)
            {
                textField.htmlText = value as String;
            }
            else if (value.hasOwnProperty("label"))
            {
                textField.htmlText = value.label;
            }
        }

        public function get data():Object
        {
            return _data;
        }

        public function get listData():ListData
        {
            return _listData;
        }

        public function set listData(value:ListData):void
        {
            _listData = value;
            setStyle("icon", _listData.icon);
        }

        public function set index(value:int):void
        {
            _index = value;
        }

        public function get index():int
        {
            return _index;
        }

        override protected function mouseHandle(e:MouseEvent):void
        {
            if (e.type == MouseEvent.MOUSE_UP)
            {
                selected = !selected;
            }
            else
            {
                super.mouseHandle(e);
            }
        }


        override protected function toMouseOverState():void
        {
            if (_selected == false)
                super.toMouseOverState();
        }


        override protected function toMouseOutState():void
        {
            if (_selected == false)
                super.toMouseOutState();
        }

        override public function draw():void
        {
			if (hasUI == false)
			{
				creatChildren();
				addListeners();
			}
            drawIcon();
			drawLayout();
        }

        protected function drawIcon():void
        {
            if (icon && icon.parent)
            {
                icon.parent.removeChild(icon);
				icon = null;
            }

            var iconStyle:Object = getStyle("icon");
            if (iconStyle != null)
            {
                icon = getDisplayObjectInstance(iconStyle);
            }
            if (icon != null)
            {
                addChildAt(icon, 1);
            }
        }
		
		override protected function drawLayout():void
		{
			var textPadding:Number = Number(getStyle("textPadding"));
			var leftMargin:Number = Number(getStyle("leftMargin"));
			var textFieldX:Number = textPadding;
			
			if (icon != null)
			{
				icon.x = leftMargin;
				icon.y = Math.round((height - icon.height) >> 1);
				textFieldX = icon.x + icon.width + textPadding;
			}
			
			
			if (label.length > 0)
			{
				textField.visible = true;
				var textWidth:Number = Math.max(0, width - textFieldX - textPadding * 2);
				textField.width = textWidth;
				textField.height = textField.textHeight + 4;
				textField.x = textFieldX;
				textField.y = Math.round((height - textField.height) >> 1);
			}
			else
			{
				textField.visible = false;
			}
			
			background.width = width;
			background.height = height;
		}
    }
}