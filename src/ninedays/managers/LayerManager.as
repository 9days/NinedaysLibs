package ninedays.managers
{
    import flash.display.Sprite;
    import flash.display.Stage;
    
    import ninedays.controller.StageResizeController;
    import ninedays.display.Layer;
    import ninedays.framework.ILayerManager;

	/**
	 * 层管理 
	 * @author riggzhuo
	 * 
	 */	
    public class LayerManager implements ILayerManager
    {
        /**游戏舞台宽**/
        public var stageWidth:int;

        /**游戏舞台高**/
        public var stageHeight:int;

        private var _root:Sprite;

        private var _stage:Stage;


        /**地图层**/
        private var _mapLayer:Layer;

        /**ui层**/
        private var _uiLayer:Layer;

        /**弹出层**/
        private var _popupLayer:Layer;

        /**弹出层**/
        private var _alertLayer:Layer;

        /**tips层**/
        private var _tipsLayer:Layer;
		
		/**右键菜单层**/
		private var _contextMenuLayer:Layer;

        /**鼠标层**/
        private var _mouseLayer:Layer;

        public function setup(root:Sprite):void
        {
            _root = root;
            _stage = _root.stage;

            _mapLayer = new Layer();
            _mapLayer.mouseEnabled = false;
            _mapLayer.name = "mapLayer";
            _root.addChild(_mapLayer);

            _uiLayer = new Layer();
            _uiLayer.mouseEnabled = false;
            _uiLayer.name = "uiLayer";
            _root.addChild(_uiLayer);

            _popupLayer = new Layer();
            _popupLayer.mouseEnabled = false;
            _popupLayer.name = "popupLayer";
            _root.addChild(_popupLayer);

            _alertLayer = new Layer();
            _alertLayer.mouseEnabled = false;
            _alertLayer.name = "alertLayer";
            _root.addChild(_alertLayer);

            _tipsLayer = new Layer();
            _tipsLayer.mouseEnabled = false;
            _tipsLayer.name = "tipsLayer";
            _root.addChild(_tipsLayer);
			
			_contextMenuLayer = new Layer();
			_contextMenuLayer.mouseEnabled = false;
			_contextMenuLayer.name = "contextMenuLayer";
            _root.addChild(_contextMenuLayer);

            _mouseLayer = new Layer();
            _mouseLayer.mouseEnabled = false;
            _mouseLayer.name = "mouseLayer";
            _root.addChild(_mouseLayer);
			
			onResizeHandle();
			StageResizeController.instance.register(onResizeHandle);
        }
		
		protected function onResizeHandle():void
		{
			stageWidth = _stage.stageWidth;
			stageHeight = _stage.stageHeight;
			
			_mapLayer.width = stageWidth;
			_mapLayer.height = stageHeight;
			
			_uiLayer.width = stageWidth;
			_uiLayer.height = stageHeight;
			
			_popupLayer.width = stageWidth;
			_popupLayer.height = stageHeight;
			
			_alertLayer.width = stageWidth;
			_alertLayer.height = stageHeight;
			
			_tipsLayer.width = stageWidth;
			_tipsLayer.height = stageHeight;
			
			_contextMenuLayer.width = stageWidth;
			_contextMenuLayer.height = stageHeight;
			
			_mouseLayer.width = stageWidth;
			_mouseLayer.height = stageHeight;
		}

        public function get root():Sprite
        {
            return _root;
        }

        public function get stage():Stage
        {
            return _stage;
        }

        /**
         * 地图层
         * @return
         *
         */
        public function get mapLayer():Layer
        {
            return _mapLayer;
        }

        /**
         * ui层
         * @return
         *
         */
        public function get uiLayer():Layer
        {
            return _uiLayer;
        }

        /**
         * 弹出层
         * @return
         *
         */
        public function get popupLayer():Layer
        {
            return _popupLayer;
        }

        /**
         * 提示框层
         * @return
         *
         */
        public function get alertLayer():Layer
        {
            return _alertLayer;
        }

        /**
         * tips层
         * @return
         *
         */
        public function get tipsLevel():Layer
        {
            return _tipsLayer;
        }
		
		/**
		 * 右键菜单层
		 * @return 
		 * 
		 */		
        public function get contextMenuLayer():Layer
        {
            return _contextMenuLayer;
        }

        /**
         * 鼠标层
         * @return
         *
         */
        public function get mouseLayer():Layer
        {
            return _mouseLayer;
        }
    }
}