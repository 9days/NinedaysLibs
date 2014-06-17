package ninedays.component
{
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.geom.Rectangle;
    import flash.ui.Keyboard;
    import flash.utils.Dictionary;
    
    import ninedays.component.constants.InvalidationType;
    import ninedays.component.events.ListEvent;
    import ninedays.component.listClasses.ListData;
    import ninedays.core.IDestroyable;
    import ninedays.data.DataProvider;
    import ninedays.events.DataChangeEvent;
    import ninedays.events.DataChangeType;
    import ninedays.component.listClasses.IItemRenderer;

    public class List extends ScrollPane
    {
        protected var container:Sprite;

        protected var _dataProvider:DataProvider;

        protected var activeCellRenderers:Vector.<IItemRenderer>;

        protected var availableCellRenderers:Vector.<IItemRenderer>;

        protected var _allowMultipleSelection:Boolean = false;

        protected var _selectable:Boolean = true;

        protected var _selectedIndices:Array;

        protected var caretIndex:int = -1;

        protected var lastCaretIndex:int = -1;

        protected var _rowHeight:Number = 20;

        protected var preChangeItems:Array;

        protected var _labelField:String = "label";

        protected var _iconField:String = "icon";

        protected var _labelFunction:Function;

        protected var _iconFunction:Function;

        public var itemFunction:Function;

        public var itemRendererClass:Class;


        public function List(width:int = 100, height:int = 100)
        {
            super(width, height);
            creatChildren();
            addListeners();
            activeCellRenderers = new Vector.<IItemRenderer>();
            availableCellRenderers = new Vector.<IItemRenderer>();
            _selectedIndices = [];
            if (dataProvider == null)
            {
                dataProvider = new DataProvider();
            }
        }

        public function get labelField():String
        {
            return _labelField;
        }

        public function set labelField(value:String):void
        {
            if (value == _labelField)
            {
                return;
            }
            _labelField = value;
            invalidate(InvalidationType.DATA);
        }

        public function get labelFunction():Function
        {
            return _labelFunction;
        }

        public function set labelFunction(value:Function):void
        {
            if (_labelFunction == value)
            {
                return;
            }
            _labelFunction = value;
            invalidate(InvalidationType.DATA);
        }

        public function get iconField():String
        {
            return _iconField;
        }

        public function set iconField(value:String):void
        {
            if (value == _iconField)
            {
                return;
            }
            _iconField = value;
            invalidate(InvalidationType.DATA);
        }

        public function get iconFunction():Function
        {
            return _iconFunction;
        }

        public function set iconFunction(value:Function):void
        {
            if (_iconFunction == value)
            {
                return;
            }
            _iconFunction = value;
            invalidate(InvalidationType.DATA);
        }

        override protected function addListeners():void
        {
            super.addListeners();
            addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
        }

        override public function set enabled(value:Boolean):void
        {
            super.enabled = value;
            container.mouseChildren = _enabled;
        }

        public function get dataProvider():DataProvider
        {
            return _dataProvider;
        }

        public function set dataProvider(value:DataProvider):void
        {
            if (_dataProvider != null)
            {
                _dataProvider.removeEventListener(DataChangeEvent.DATA_CHANGE, handleDataChange);
                _dataProvider.removeEventListener(DataChangeEvent.PRE_DATA_CHANGE, onPreChange);
            }
            _dataProvider = value;
            _dataProvider.addEventListener(DataChangeEvent.DATA_CHANGE, handleDataChange);
            _dataProvider.addEventListener(DataChangeEvent.PRE_DATA_CHANGE, onPreChange);
            clearSelection();
            invalidateList();
        }

        override public function get maxHorizontalScrollPosition():Number
        {
            return _maxHorizontalScrollPosition;
        }

        public function set maxHorizontalScrollPosition(value:Number):void
        {
            _maxHorizontalScrollPosition = value;
            invalidate(InvalidationType.SIZE);
        }

        public function get length():uint
        {
            return _dataProvider.length;
        }

        /**
         * 允许选择多项
         * @return
         *
         */
        public function get allowMultipleSelection():Boolean
        {
            return _allowMultipleSelection;
        }

        public function set allowMultipleSelection(value:Boolean):void
        {
            if (value == _allowMultipleSelection)
            {
                return;
            }
            _allowMultipleSelection = value;
            if (!value && _selectedIndices.length > 1)
            {
                _selectedIndices = [ _selectedIndices.pop()];
                invalidate(InvalidationType.DATA);
            }
        }

        public function get selectable():Boolean
        {
            return _selectable;
        }

        public function set selectable(value:Boolean):void
        {
            if (value == _selectable)
            {
                return;
            }
            if (!value)
            {
                selectedIndices = [];
            }
            _selectable = value;
        }

        /**
         * 选择的索引
         * @return
         *
         */
        public function get selectedIndex():int
        {
            return (_selectedIndices.length == 0) ? -1 : _selectedIndices[_selectedIndices.length - 1];
        }


        public function set selectedIndex(value:int):void
        {
            selectedIndices = (value == -1) ? null : [ value ];
        }

        /**
         * 获得选择的选项
         * @return
         *
         */
        public function get selectedIndices():Array
        {
            return _selectedIndices.concat();
        }

        public function set selectedIndices(value:Array):void
        {
            if (!_selectable)
            {
                return;
            }
            _selectedIndices = (value == null) ? [] : value.concat();
            invalidate(InvalidationType.SELECTED);
        }

        public function get selectedItem():Object
        {
            return (_selectedIndices.length == 0) ? null : _dataProvider.getItemAt(selectedIndex);
        }

        public function set selectedItem(value:Object):void
        {
            var index:int = _dataProvider.getItemIndex(value);
            selectedIndex = index;
        }

        public function get selectedItems():Array
        {
            var items:Array = [];
            for (var i:uint = 0; i < _selectedIndices.length; i++)
            {
                items.push(_dataProvider.getItemAt(_selectedIndices[i]));
            }
            return items;
        }


        public function set selectedItems(value:Array):void
        {
            if (value == null)
            {
                selectedIndices = null;
                return;
            }
            var indices:Array = [];
            for (var i:uint = 0; i < value.length; i++)
            {
                var index:int = _dataProvider.getItemIndex(value[i]);
                if (index != -1)
                {
                    indices.push(index);
                }
            }
            selectedIndices = indices;
        }

        public function get rowHeight():Number
        {
            return _rowHeight;
        }

        public function set rowHeight(value:Number):void
        {
            _rowHeight = value;
            invalidate(InvalidationType.SIZE);
        }

        public function get rowCount():uint
        {
            return Math.ceil(calculateAvailableHeight() / rowHeight);
        }

        protected function calculateAvailableHeight():Number
        {
            return height;
        }

        /**
         * 清除选择
         *
         */
        public function clearSelection():void
        {
            selectedIndex = -1;
        }

        public function itemToItemRenderer(item:Object):IItemRenderer
        {
            if (item != null)
            {
                for (var i:int = 0; i < activeCellRenderers.length; i++)
                {
                    var renderer:IItemRenderer = activeCellRenderers[i];
                    if (renderer.data == item)
                    {
                        return renderer;
                    }
                }
            }
            return null;
        }

        public function addItem(item:Object):void
        {
            _dataProvider.addItem(item);
            invalidateList();
        }

        public function addItemAt(item:Object, index:uint):void
        {
            _dataProvider.addItemAt(item, index);
            invalidateList();
        }

        public function removeAll():void
        {
            _dataProvider.removeAll();
        }

        public function getItemAt(index:uint):Object
        {
            return _dataProvider.getItemAt(index);
        }

        public function removeItem(item:Object):Object
        {
            return _dataProvider.removeItem(item);
        }

        public function removeItemAt(index:uint):Object
        {
            return _dataProvider.removeItemAt(index);
        }

        public function replaceItemAt(item:Object, index:uint):Object
        {
            return _dataProvider.replaceItemAt(item, index);
        }

        public function invalidateList():void
        {
            _invalidateList();
            invalidate(InvalidationType.DATA);
        }

        public function sortItems(... sortArgs:Array):*
        {
            return _dataProvider.sort.apply(_dataProvider, sortArgs);
        }

        public function sortItemsOn(field:String, options:Object = null):*
        {
            return _dataProvider.sortOn(field, options);
        }

        public function isItemSelected(item:Object):Boolean
        {
            return selectedItems.indexOf(item) > -1;
        }

        public function scrollToSelected():void
        {
            scrollToIndex(selectedIndex);
        }

        public function scrollToIndex(newCaretIndex:int):void
        {
            draw();
            var lastVisibleItemIndex:uint = Math.floor((_verticalScrollPosition + availableHeight) / rowHeight) - 1;
            var firstVisibleItemIndex:uint = Math.ceil(_verticalScrollPosition / rowHeight);
            if (newCaretIndex < firstVisibleItemIndex)
            {
                verticalScrollPosition = newCaretIndex * rowHeight;
            }
            else if (newCaretIndex > lastVisibleItemIndex)
            {
                verticalScrollPosition = (newCaretIndex + 1) * rowHeight - availableHeight;
            }
        }

        override protected function creatChildren():void
        {
            super.creatChildren();

            container = new Sprite();
            addChildAt(container, 0);
			container.scrollRect = contentScrollRect;
        }

        protected function _invalidateList():void
        {
            var item:Sprite;
            while (availableCellRenderers.length > 0)
            {
                item = availableCellRenderers.pop() as Sprite;
                removeItemListeners(item);
            }


            while (activeCellRenderers.length > 0)
            {
                item = activeCellRenderers.pop() as Sprite;
                removeItemListeners(item);
                if (item.parent)
                    item.parent.removeChild(item);
            }
        }

        protected function handleDataChange(event:DataChangeEvent):void
        {
            var startIndex:int = event.startIndex;
            var endIndex:int = event.endIndex;
            var changeType:String = event.changeType;
            var i:uint;
            if (changeType == DataChangeType.ADD)
            {
                for (i = 0; i < _selectedIndices.length; i++)
                {
                    if (_selectedIndices[i] >= startIndex)
                    {
                        _selectedIndices[i] += startIndex - endIndex;
                    }
                }
            }
            else if (changeType == DataChangeType.REMOVE)
            {
                for (i = 0; i < _selectedIndices.length; i++)
                {
                    if (_selectedIndices[i] >= startIndex)
                    {
                        if (_selectedIndices[i] <= endIndex)
                        {
                            delete(_selectedIndices[i]);
                        }
                        else
                        {
                            _selectedIndices[i] -= startIndex - endIndex + 1;
                        }
                    }
                }
            }
            else if (changeType == DataChangeType.REMOVE_ALL)
            {
                clearSelection();
            }
            else if (changeType == DataChangeType.REPLACE)
            {
                // doesn't need to do anything.
            }
            else
            {
                // Using preChangeItems to remember selection
                //clearSelection();
                selectedItems = preChangeItems;
                preChangeItems = null;
            }
            invalidate(InvalidationType.DATA);
        }

        protected function handleCellRendererMouseEvent(event:MouseEvent):void
        {
            var renderer:IItemRenderer = event.target as IItemRenderer;
            var evtType:String = (event.type == MouseEvent.ROLL_OVER) ? ListEvent.ITEM_ROLL_OVER : ListEvent.ITEM_ROLL_OUT;
            dispatchEvent(new ListEvent(evtType, false, false, renderer.listData.column, renderer.listData.row, renderer.listData.index, renderer.data));
        }

        protected function handleCellRendererClick(event:MouseEvent):void
        {
            if (!_enabled)
            {
                return;
            }
            var renderer:IItemRenderer = event.currentTarget as IItemRenderer;
            var itemIndex:uint = renderer.listData.index;
            // this event is cancellable:
            if (!dispatchEvent(new ListEvent(ListEvent.ITEM_CLICK, false, true, 0, itemIndex, itemIndex, renderer.data)) || !_selectable)
            {
                return;
            }
            var selectIndex:int = selectedIndices.indexOf(itemIndex);
            var i:int;
            if (!_allowMultipleSelection)
            {
                if (selectIndex != -1)
                {
                    return;
                }
                else
                {
                    renderer.selected = true;
                    _selectedIndices = [ itemIndex ];
                }
                lastCaretIndex = caretIndex = itemIndex;
            }
            else
            {
                if (event.shiftKey)
                {
                    var oldIndex:uint = (_selectedIndices.length > 0) ? _selectedIndices[0] : itemIndex;
                    _selectedIndices = [];
                    if (oldIndex > itemIndex)
                    {
                        for (i = oldIndex; i >= itemIndex; i--)
                        {
                            _selectedIndices.push(i);
                        }
                    }
                    else
                    {
                        for (i = oldIndex; i <= itemIndex; i++)
                        {
                            _selectedIndices.push(i);
                        }
                    }
                    caretIndex = itemIndex;
                }
                else if (event.ctrlKey)
                {
                    if (selectIndex != -1)
                    {
                        renderer.selected = false;
                        _selectedIndices.splice(selectIndex, 1);
                    }
                    else
                    {
                        renderer.selected = true;
                        _selectedIndices.push(itemIndex);
                    }
                    caretIndex = itemIndex;
                }
                else
                {
                    _selectedIndices = [ itemIndex ];
                    lastCaretIndex = caretIndex = itemIndex;
                }
            }
            dispatchEvent(new Event(Event.CHANGE));
            invalidate(InvalidationType.DATA);
        }

        protected function handleCellRendererDoubleClick(event:MouseEvent):void
        {
            if (!_enabled)
            {
                return;
            }
            var renderer:IItemRenderer = event.currentTarget as IItemRenderer;
            var itemIndex:uint = renderer.listData.index;
            dispatchEvent(new ListEvent(ListEvent.ITEM_DOUBLE_CLICK, false, true, 0, itemIndex, itemIndex, renderer.data));
        }


        override public function draw():void
        {
            var contentHeightChanged:Boolean = (contentHeight != rowHeight * length);
            contentHeight = rowHeight * length;
            super.draw();

            if (contentHeightChanged)
                drawLayout();

            if (isInvalid(InvalidationType.STYLES, InvalidationType.SIZE, InvalidationType.DATA, InvalidationType.SCROLL, InvalidationType.SELECTED))
            {
                drawList();
            }
        }

        override protected function drawScrollRect():void
        {
        }
		
		override protected function drawLayout():void
		{
			super.drawLayout();
			container.scrollRect = contentScrollRect;
		}


        protected function drawList():void
        {
            var rect:Rectangle = container.scrollRect;
            rect.x = _horizontalScrollPosition;

            rect.y = Math.floor(_verticalScrollPosition) % rowHeight;
			container.scrollRect = rect;

            var startIndex:uint = Math.floor(_verticalScrollPosition / rowHeight);
            var endIndex:uint = Math.min(length, startIndex + rowCount + 1);


            var i:uint;
            var item:Object;
            var renderer:IItemRenderer;

            var itemHash:Dictionary = new Dictionary(true);
            for (i = startIndex; i < endIndex; i++)
            {
                itemHash[_dataProvider.getItemAt(i)] = true;
            }

            var itemToRendererHash:Dictionary = new Dictionary(true);
            while (activeCellRenderers.length > 0)
            {
                renderer = activeCellRenderers.pop() as IItemRenderer;
                item = renderer.data;
                if (itemHash[item] == null)
                {
                    availableCellRenderers.push(renderer);
                }
                else
                {
                    itemToRendererHash[item] = renderer;
                }
                container.removeChild(renderer as DisplayObject);
            }

            for (i = startIndex; i < endIndex; i++)
            {
                var reused:Boolean = false;
                item = _dataProvider.getItemAt(i);
                if (itemToRendererHash[item] != null)
                {
                    reused = true;
                    renderer = itemToRendererHash[item];
                    delete itemToRendererHash[item];
                }
                else if (availableCellRenderers.length > 0)
                {
                    renderer = availableCellRenderers.pop();
                }
                else
                {
                    renderer = getNewItemRenderer(item);
                }
                container.addChild(renderer as Sprite);
                activeCellRenderers.push(renderer);

                renderer.y = rowHeight * (i - startIndex);
                renderer.width = availableWidth + _maxHorizontalScrollPosition;
                renderer.height = rowHeight;

                var label:String = itemToLabel(item);

                var icon:Object = null;
                if (_iconFunction != null)
                {
                    icon = _iconFunction(item);
                }
                else if (_iconField != null)
                {
                    icon = item.hasOwnProperty(_iconField) ? item[_iconField] : null;
                }

                if (!reused)
                {
                    renderer.data = item;
                }

                renderer.listData = new ListData(label, icon, this, i, i, 0);
                renderer.selected = (_selectedIndices.indexOf(i) != -1);

                if (renderer is Component)
                {
                    (renderer as Component).draw();
                }
            }

            for (var key:*in itemHash)
            {
                itemHash[key] == null;
                delete itemHash[key];
            }

            for (key in itemToRendererHash)
            {
                renderer = itemToRendererHash[key];
                removeItemListeners(renderer as Sprite);
                itemToRendererHash[key] == null;
                delete itemToRendererHash[key];
            }
        }

        public function itemToLabel(item:Object):String
        {
            if (_labelFunction != null)
            {
                return String(_labelFunction(item));
            }
            else
            {
                return item.hasOwnProperty(_labelField) ? String(item[_labelField]) : "";
            }
        }


        protected function getNewItemRenderer(data:Object):IItemRenderer
        {
            var item:IItemRenderer;
            if (itemFunction != null)
            {
                item = itemFunction(data) as IItemRenderer;
            }
            else if (itemRendererClass != null)
            {
                item = new itemRendererClass() as IItemRenderer;
            }
            else
            {
				var defaultRenderer:Class = getStyle("itemRenderer") as Class;
				if(defaultRenderer)
					item = new defaultRenderer() as IItemRenderer;
				else
                	throw new TypeError("Error: itemFunction 和 itemRendererClass 不能同时为 null ！");
            }

            if (item != null)
            {
                var rendererSprite:Sprite = item as Sprite;
                if (rendererSprite != null)
                {
                    addItemListeners(rendererSprite);
                }
            }
            else
            {
                throw new TypeError("Error: itemFunction 和 itemRendererClass 都不合法！");
            }
            return item;
        }

        protected function keyDownHandler(event:KeyboardEvent):void
        {
            if (!selectable)
            {
                return;
            }
            switch (event.keyCode)
            {
                case Keyboard.UP:
                case Keyboard.DOWN:
                case Keyboard.END:
                case Keyboard.HOME:
                case Keyboard.PAGE_UP:
                case Keyboard.PAGE_DOWN:
                    moveSelectionVertically(event.keyCode, event.shiftKey && _allowMultipleSelection, event.ctrlKey && _allowMultipleSelection);
                    break;
                case Keyboard.LEFT:
                case Keyboard.RIGHT:
                    moveSelectionHorizontally(event.keyCode, event.shiftKey && _allowMultipleSelection, event.ctrlKey && _allowMultipleSelection);
                    break;
                case Keyboard.SPACE:
                    if (caretIndex == -1)
                    {
                        caretIndex = 0;
                    }
                    doKeySelection(caretIndex, event.shiftKey, event.ctrlKey);
                    scrollToSelected();
                    break;
            }
            event.stopPropagation();
        }

        protected function moveSelectionHorizontally(code:uint, shiftKey:Boolean, ctrlKey:Boolean):void
        {
        }

        protected function moveSelectionVertically(code:uint, shiftKey:Boolean, ctrlKey:Boolean):void
        {
            var pageSize:int = Math.max(Math.floor(calculateAvailableHeight() / rowHeight), 1);
            var newCaretIndex:int = -1;
            var dir:int = 0;
            switch (code)
            {
                case Keyboard.UP:
                    if (caretIndex > 0)
                    {
                        newCaretIndex = caretIndex - 1;
                    }
                    break;
                case Keyboard.DOWN:
                    if (caretIndex < length - 1)
                    {
                        newCaretIndex = caretIndex + 1;
                    }
                    break;
                case Keyboard.PAGE_UP:
                    if (caretIndex > 0)
                    {
                        newCaretIndex = Math.max(caretIndex - pageSize, 0);
                    }
                    break;
                case Keyboard.PAGE_DOWN:
                    if (caretIndex < length - 1)
                    {
                        newCaretIndex = Math.min(caretIndex + pageSize, length - 1);
                    }
                    break;
                case Keyboard.HOME:
                    if (caretIndex > 0)
                    {
                        newCaretIndex = 0;
                    }
                    break;
                case Keyboard.END:
                    if (caretIndex < length - 1)
                    {
                        newCaretIndex = length - 1;
                    }
                    break;
            }
            if (newCaretIndex >= 0)
            {
                doKeySelection(newCaretIndex, shiftKey, ctrlKey);
                scrollToSelected();
            }
        }

        protected function doKeySelection(newCaretIndex:int, shiftKey:Boolean, ctrlKey:Boolean):void
        {
            var selChanged:Boolean = false;
            if (shiftKey)
            {
                var i:int;
                var selIndices:Array = [];
                var startIndex:int = lastCaretIndex;
                var endIndex:int = newCaretIndex;
                if (startIndex == -1)
                {
                    startIndex = caretIndex != -1 ? caretIndex : newCaretIndex;
                }
                if (startIndex > endIndex)
                {
                    endIndex = startIndex;
                    startIndex = newCaretIndex;
                }
                for (i = startIndex; i <= endIndex; i++)
                {
                    selIndices.push(i);
                }
                selectedIndices = selIndices;
                caretIndex = newCaretIndex;
                selChanged = true;
            }
            else
            {
                selectedIndex = newCaretIndex;
                caretIndex = lastCaretIndex = newCaretIndex;
                selChanged = true;
            }
            if (selChanged)
            {
                dispatchEvent(new Event(Event.CHANGE));
            }
            invalidate(InvalidationType.DATA);
        }

        protected function onPreChange(event:DataChangeEvent):void
        {
            switch (event.changeType)
            {
                case DataChangeType.REMOVE:
                case DataChangeType.ADD:
                case DataChangeType.REMOVE_ALL:
                case DataChangeType.REPLACE:
                    break;
                default:
                    preChangeItems = selectedItems;
                    break;
            }
        }

        protected function addItemListeners(item:Sprite):void
        {
            item.addEventListener(MouseEvent.CLICK, handleCellRendererClick);
            item.addEventListener(MouseEvent.ROLL_OVER, handleCellRendererMouseEvent);
            item.addEventListener(MouseEvent.ROLL_OUT, handleCellRendererMouseEvent);
            item.doubleClickEnabled = true;
            item.addEventListener(MouseEvent.DOUBLE_CLICK, handleCellRendererDoubleClick);
        }


        protected function removeItemListeners(item:Sprite):void
        {
            item.removeEventListener(MouseEvent.CLICK, handleCellRendererClick);
            item.removeEventListener(MouseEvent.ROLL_OVER, handleCellRendererMouseEvent);
            item.removeEventListener(MouseEvent.ROLL_OUT, handleCellRendererMouseEvent);
            item.doubleClickEnabled = false;
            item.removeEventListener(MouseEvent.DOUBLE_CLICK, handleCellRendererDoubleClick);

            if (item is IDestroyable)
                (item as IDestroyable).destroy();
        }


        override protected function doDestroy():void
        {
            super.doDestroy();
            _invalidateList();
            availableCellRenderers = null;
            activeCellRenderers = null;
            _selectedIndices = null;
            preChangeItems = null;
            itemFunction = null;
            itemRendererClass = null;
        }
    }
}