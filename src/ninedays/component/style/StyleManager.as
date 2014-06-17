package ninedays.component.style
{
    import flash.display.Bitmap;
    import flash.display.DisplayObject;
    import flash.text.TextFormat;
    import flash.utils.Dictionary;
    import flash.utils.getDefinitionByName;
    import flash.utils.getQualifiedClassName;
    import flash.utils.getQualifiedSuperclassName;
    
    import ninedays.core.Singleton;

    public class StyleManager
    {
		private static var _instance:StyleManager;
        public static function get instance():StyleManager
        {
            return _instance ||= new StyleManager();
        }

        private var globalStyles:Dictionary;

        public function StyleManager()
        {
            globalStyles = new Dictionary();
        }

        public function getStyleInstance(definition:String):Object
        {
			var style:Object = getStyle(definition);
			if(style == null)
				return null;
			
            var tempClass:Class = null;
            var superClassName:String = null;
			if(style is String)
            	tempClass = getDefinitionByName(style as String) as Class;
			else if(style is Class)
				tempClass = style as Class;
			else if(style is DisplayObject)
				return style;
			else 
				return null;
			
			if(tempClass == null)
				return null;
			
            superClassName = getQualifiedSuperclassName(tempClass).split("::").pop();
            if (superClassName == "BitmapData")
            {
                return (new Bitmap(new tempClass(0, 0), "auto", true));
            }
            return new tempClass();
        }

        public function setStyle(name:String, style:Object):void
        {
            if (globalStyles[name] === style && !(style is TextFormat))
            {
                return;
            }
			globalStyles[name] = style;
        }
		
		public function setClassDefaultStyle(clazz:Class, styleName:String, styleValue:Object):void
		{
			setStyle(getQualifiedClassName(clazz) + "|" + styleName, styleValue);
		}

        public function clearStyle(name:String):void
        {
            setStyle(name, null);
        }

        public function getStyle(name:String):Object
        {
            return globalStyles[name];
        }
    }
}