package ninedays.component
{
    import flash.events.KeyboardEvent;
    import flash.ui.Keyboard;
    
    import ninedays.component.events.ListEvent;
    import ninedays.component.events.TreeEvent;
    import ninedays.component.treeClasses.BranchNode;
    import ninedays.component.treeClasses.LeafNode;
    import ninedays.component.treeClasses.RootNode;
    import ninedays.component.treeClasses.TNode;
    import ninedays.component.treeClasses.TreeDataProvider;
    import ninedays.component.treeClasses.TreeItemRenderer;
    import ninedays.data.BinaryXML;
    import ninedays.data.DataProvider;
    import ninedays.events.DataChangeEvent;

    public class Tree extends List
    {

        public var leafIconField:String = "leafIcon";

        public var openBranchIconField:String = "openBranchIcon";

        public var closedBranchIconField:String = "closedBranchIcon";


        public function Tree(width:int = 100, height:int = 100)
        {
            super(width, height);
            addEventListener(ListEvent.ITEM_CLICK, nodeClick);
            addEventListener(ListEvent.ITEM_DOUBLE_CLICK, nodeClick);
        }

        public function openAllNodes():void
        {
            var visibleNodes:Array = dataProvider.toArray();
            for each (var node:TNode in visibleNodes)
            {
                if ((node is BranchNode) && (node.nodeLevel == 0))
                {
                    (node as BranchNode).openAllChildren();
                }
            }
        }

        public function closeAllNodes():void
        {
            var visibleNodes:Array = dataProvider.toArray();
            for each (var node:TNode in visibleNodes)
            {
                if ((node is BranchNode) && (node.nodeLevel == 0))
                {
                    (node as BranchNode).closeAllChildren();
                }
            }
        }

        public function findNode(fieldName:String, fieldValue:String):TNode
        {
            var visibleNodes:Array = dataProvider.toArray();
            for each (var node:TNode in visibleNodes)
            {
                if (node.nodeLevel == 0)
                {
                    var foundNode:TNode = (node as BranchNode).checkForValue(fieldName, fieldValue);
                    if (foundNode != null)
                    {
                        return foundNode;
                    }
                }
            }
            return null;
        }

        public function showNode(foundNode:TNode):int
        {
            if (foundNode != null)
            {
                var parentPointer:TNode = foundNode.parentNode;
                while (!(parentPointer is RootNode))
                {
                    (parentPointer as BranchNode).openNode();
                    parentPointer = parentPointer.parentNode;
                }
                var foundIndex:int = dataProvider.getItemIndex(foundNode);
                return foundIndex;
            }
            return -1;
        }

        public function exposeNode(fieldName:String, fieldValue:String):TNode
        {
            var foundNode:TNode = findNode(fieldName, fieldValue);
            if (foundNode != null)
            {
                showNode(foundNode);
                return (foundNode);
            }
            return null;
        }

        public function toggleNode(node:BranchNode):void
        {
            if (node.nodeState == TreeDataProvider.OPEN_NODE)
            {
                node.closeNode();
            }
            else
            {
                node.openNode();
            }
        }

        private function nodeClick(event:ListEvent):void
        {
            var dp:TreeDataProvider = dataProvider as TreeDataProvider;
            var node:Object = dp.getItemAt(event.index);
            dp.toggleNode(event.index);
        }
		
		override public function itemToLabel(item:Object):String
		{
			if (_labelFunction != null)
			{
				return String(_labelFunction(item));
			}
			else
			{
				return ((item as TNode).attributes[_labelField] != null) ? String((item as TNode).attributes[_labelField]) : "";
			}
		}

		
		public function set xml(value:XML):void
		{
			if(value)
			{
				dataProvider = new TreeDataProvider(value);
			}
		}
		
		public function set binaryXML(value:BinaryXML):void
		{
			if(value)
			{
				dataProvider = new TreeDataProvider(value);
			}
		}


        override public function set dataProvider(value:DataProvider):void
        {
            if ((value is DataProvider && value.length == 0) || value is TreeDataProvider)
            {
                if (_dataProvider != null)
                {
                    _dataProvider.removeEventListener(DataChangeEvent.DATA_CHANGE, handleDataChange);
                    _dataProvider.removeEventListener(DataChangeEvent.PRE_DATA_CHANGE, onPreChange);
                }
                _dataProvider = value;

                _dataProvider.addEventListener(DataChangeEvent.DATA_CHANGE, handleDataChange, false, 0, true);
                _dataProvider.addEventListener(DataChangeEvent.PRE_DATA_CHANGE, onPreChange, false, 0, true);
                clearSelection();
                invalidateList();
            }
            else
            {
                throw new TypeError("不合法的TreeDataProvider！");
            }
        }


        override protected function keyDownHandler(event:KeyboardEvent):void
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
                case Keyboard.SPACE:
                case Keyboard.ENTER:
                    if (caretIndex == -1)
                    {
                        caretIndex = 0;
                    }
                    var renderer:TreeItemRenderer = event.currentTarget as TreeItemRenderer;

                    var node:TNode = selectedItem as TNode;


                    if (node is BranchNode)
                    {
                        var branchNode:BranchNode = node as BranchNode;
                        if (branchNode.isOpen())
                        {
                            branchNode.closeNode();

                            var closeEvent:TreeEvent = new TreeEvent(TreeEvent.ITEM_CLOSE);
                            closeEvent.triggerEvent = event;
                            closeEvent.itemRenderer = renderer;
                            dispatchEvent(closeEvent);

                        }

                        else
                        {
                            branchNode.openNode();

                            var openEvent:TreeEvent = new TreeEvent(TreeEvent.ITEM_OPEN);
                            openEvent.triggerEvent = event;
                            openEvent.itemRenderer = renderer;
                            dispatchEvent(openEvent);
                        }
                    }
                    break;
            }
            event.stopPropagation();
        }
    }
}