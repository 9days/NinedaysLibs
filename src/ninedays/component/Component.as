package ninedays.component
{
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.utils.getDefinitionByName;
    import flash.utils.getQualifiedClassName;
    import flash.utils.getQualifiedSuperclassName;
    import flash.utils.getTimer;
    
    import ninedays.component.constants.InvalidationType;
    import ninedays.component.style.StyleManager;
    import ninedays.display.BaseSprite;
    import ninedays.utils.DisplayObjectUtil;

    public class Component extends BaseSprite
    {
        protected var _x:Number;

        protected var _y:Number;

        protected var _width:Number = 0;

        protected var _height:Number = 0;

        protected var _enabled:Boolean = true;

        private var _hasUI:Boolean = false;

        protected var invalidHash:Object;

        protected var instanceStyles:Object;

        public function Component()
        {
            instanceStyles = {};
            validate();
            invalidate();
        }

        protected function get hasUI():Boolean
        {
            return _hasUI;
        }


        protected function set hasUI(value:Boolean):void
        {
            if (_hasUI != value)
            {
                _hasUI = value;
            }
        }

        protected function getDisplayObjectInstance(skin:Object):DisplayObject
        {
            var classDef:Object = null;
            if (skin is Class)
            {
                return (new skin()) as DisplayObject;
            }
            else if (skin is DisplayObject)
            {
                (skin as DisplayObject).x = 0;
                (skin as DisplayObject).y = 0;
                return skin as DisplayObject;
            }

            try
            {
                classDef = getDefinitionByName(skin.toString());
            }
            catch (e:Error)
            {
                try
                {
                    classDef = loaderInfo.applicationDomain.getDefinition(skin.toString()) as Object;
                }
                catch (e:Error)
                {
                    // Nothing
                }
            }

            if (classDef == null)
            {
                return null;
            }
            return (new classDef()) as DisplayObject;
        }

        /**
         * 设置样式
         * @param style
         * @param value
         *
         */
        public function setStyle(style:String, value:Object):void
        {
            if (instanceStyles[style] === value)
            {
                return;
            }
            instanceStyles[style] = value;
            invalidate(InvalidationType.STYLES);
        }

        /**
         * 获取样式
         * @param name
         * @return
         *
         */
        protected function getStyle(name:String):Object
        {
            var prev:int = getTimer();
            if (instanceStyles[name])
                return instanceStyles[name];

            //获取默认设置样式
            var result:Object;

            var className:String = getQualifiedClassName(this);
            var superClass:Class = getDefinitionByName(className) as Class;

            while (superClass != Component)
            {
                result = StyleManager.instance.getStyle(className + "|" + name);
                if (result != null)
                {
//                    trace("getStyle cost time: " + (getTimer() - prev) + " ms!");
                    return result;
                }

                className = getQualifiedSuperclassName(superClass);
                superClass = getDefinitionByName(className) as Class;
            }

            return result;
        }

        protected function creatChildren():void
        {
            hasUI = true;
        }

        protected function validate():void
        {
            invalidHash = {};
        }


        protected function invalidate(property:String = InvalidationType.ALL):void
        {
            invalidHash[property] = true;
            addEventListener(Event.ENTER_FRAME, onInvalidate);
        }

        protected function onInvalidate(event:Event):void
        {
            removeEventListener(Event.ENTER_FRAME, onInvalidate);
            draw();
            validate();
        }

        protected function isInvalid(property:String, ... properties:Array):Boolean
        {
            if (invalidHash[property] || invalidHash[InvalidationType.ALL])
            {
                return true;
            }
            while (properties.length > 0)
            {
                if (invalidHash[properties.pop()])
                {
                    return true;
                }
            }
            return false;
        }

        public function draw():void
        {
            if (hasUI == false)
            {
                creatChildren();
                addListeners();
            }
        }

        /**
         * 添加侦听
         */
        protected function addListeners():void
        {
        }

        /**
         * 移除侦听
         */
        protected function removeListeners():void
        {
        }

        public function setSize(w:Number, h:Number):void
        {
            _width = w;
            _height = h;
            invalidate(InvalidationType.SIZE);
        }

        override public function set width(value:Number):void
        {
            _width = value;
            invalidate(InvalidationType.SIZE);
        }

        override public function get width():Number
        {
            return _width;
        }

        override public function set height(value:Number):void
        {
            _height = value;
            invalidate(InvalidationType.SIZE);
        }

        override public function get height():Number
        {
            return _height;
        }

        public function move(x:Number, y:Number):void
        {
            _x = x;
            _y = y;
            super.x = Math.round(x);
            super.y = Math.round(y);
        }

        override public function get x():Number
        {
            return (isNaN(_x)) ? super.x : _x;
        }

        override public function set x(value:Number):void
        {
            move(value, _y);
        }

        override public function get y():Number
        {
            return (isNaN(_y)) ? super.y : _y;
        }

        override public function set y(value:Number):void
        {
            move(_x, value);
        }

        public function set enabled(value:Boolean):void
        {
            _enabled = value;
            mouseEnabled = mouseChildren = value;
            tabEnabled = value;
            alpha = _enabled ? 1.0 : 0.5;
        }

        public function get enabled():Boolean
        {
            return _enabled;
        }

        override protected function doDestroy():void
        {
            super.doDestroy();
            removeListeners();
            instanceStyles = null;
            invalidHash = null;
        }
    }
}
