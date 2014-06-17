package ninedays.component.treeClasses
{
    import flash.display.DisplayObject;
    import flash.events.MouseEvent;

    import ninedays.component.Tree;
    import ninedays.component.listClasses.ListData;
    import ninedays.component.listClasses.ItemRenderer;

    public class TreeItemRenderer extends ItemRenderer
    {
        public function TreeItemRenderer()
        {
            this.addEventListener(MouseEvent.CLICK, handleClickEvent);
        }

        private function handleClickEvent(event:MouseEvent):void
        {
            var currentNode:TNode = data as TNode;
            if (this.icon != null && currentNode is BranchNode)
            {
                event.stopImmediatePropagation();
                if ((currentNode as BranchNode).isOpen())
                {
                    (currentNode as BranchNode).closeNode();
                }
                else
                {
                    (currentNode as BranchNode).openNode();
                }
            }
        }

        override public function set listData(value:ListData):void
        {
            _listData = value;
            label = _listData.label;
            var parentTree:Tree = _listData.owner as Tree;
            if (data.nodeType == TreeDataProvider.BRANCH_NODE)
            {
                if (data.nodeState == TreeDataProvider.OPEN_NODE)
                {
                    if (parentTree.iconFunction != null)
                    {
                        setStyle("icon", parentTree.iconFunction(data));
                    }
                    else if (parentTree.openBranchIconField != null && data.hasOwnProperty(parentTree.openBranchIconField))
                    {
                        setStyle("icon", data[parentTree.openBranchIconField]);
                    }
                    else
                    {
                        setStyle("icon", getStyle("openBranchIcon"));
                    }
                }
                else
                {
                    if (parentTree.iconFunction != null)
                    {
                        setStyle("icon", parentTree.iconFunction(data));
                    }
                    else if (parentTree.closedBranchIconField != null && data.hasOwnProperty(parentTree.closedBranchIconField))
                    {
                        setStyle("icon", data[parentTree.closedBranchIconField]);
                    }
                    else
                    {
                        setStyle("icon", getStyle("closeBranchIcon"));
                    }
                }
            }
            else
            {
                if (parentTree.iconFunction != null)
                {
                    setStyle("icon", parentTree.iconFunction(data));
                }
                else if (parentTree.leafIconField != null && data.hasOwnProperty(parentTree.leafIconField))
                {
                    setStyle("icon", data.hasOwnProperty(parentTree.leafIconField));
                }
                else
                {
                    setStyle("icon", getStyle("leafIcon"));
                }
            }
        }


        override protected function drawLayout():void
        {
            var textPadding:Number = Number(getStyle("textPadding"));
            var nodeIndent:Number = Number(getStyle("nodeIndent"));
            var leftMargin:Number = Number(getStyle("leftMargin"));
            var textFieldX:Number = textPadding + leftMargin + data.nodeLevel * nodeIndent;

            if (icon != null)
            {
                icon.x = leftMargin + data.nodeLevel * nodeIndent;
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