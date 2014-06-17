package ninedays.ui.contextMenu
{
    import flash.display.DisplayObjectContainer;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Rectangle;
    
    import ninedays.component.Button;
    import ninedays.framework.Global;
    import ninedays.display.IContextMenuPanel;
    import ninedays.managers.LayerManager;

    public class BaseContextMenuPanel extends Sprite implements IContextMenuPanel
    {
        protected var background:Shape;

        protected var pools:Vector.<BaseContextMenuPanelItem> = new Vector.<BaseContextMenuPanelItem>();

        protected var items:Vector.<BaseContextMenuPanelItem>;

        public function initContextMenu(contextMenu:ContextMenu):void
        {
            if (background == null)
            {
                background = new Shape();
                background.graphics.beginFill(0xFFFFFF, .8);
                background.graphics.drawRoundRect(0, 0, 100, 100, 5, 5);
                background.graphics.endFill();
                background.scale9Grid = new Rectangle(20, 20, 60, 60);
                addChild(background);
            }

            if (items)
            {
                removeAllItem();
            }
            else
            {
                items = new Vector.<BaseContextMenuPanelItem>();
            }
            addChild(background);

            var lastY:int = 5;
            for each (var contextMenuItem:ContextMenuItem in contextMenu.customItems)
            {
                var item:BaseContextMenuPanelItem;
                if (pools.length)
                    item = pools.pop();
                else
                    item = new BaseContextMenuPanelItem();
                item.data = contextMenuItem;
                addChild(item);
                item.y = lastY;
                lastY += item.height + 2;
                items.push(item);
                item.addEventListener(MouseEvent.CLICK, onItemClickHandle, false, 0, true);
            }

            background.width = 100;
            background.height = lastY + 3;
        }

        protected function removeAllItem():void
        {
            while (items.length)
            {
                var item:BaseContextMenuPanelItem = items.pop();
                removeChild(item);
                pools.push(item);
            }
        }

        protected function onItemClickHandle(event:MouseEvent):void
        {
            var item:BaseContextMenuPanelItem = event.currentTarget as BaseContextMenuPanelItem;
            if (item.data.handle != null)
            {
                item.data.handle();
                hide();
            }
        }

        public function show(container:DisplayObjectContainer):void
        {
            container.addChild(this);
            layout();
        }

        public function hide():void
        {
            if (parent)
                parent.removeChild(this);
        }

        public function layout():void
        {
            if (!parent)
            {
                return;
            }

            this.x = parent.mouseX;
            this.y = parent.mouseY;
            if (this.x + this.width > Global.layerManager.stage.stageWidth)
            {
                this.x = parent.mouseX - this.width;
            }
            if (this.y + this.height > Global.layerManager.stage.stageHeight)
            {
                this.y = parent.mouseY - this.height;
            }
        }
    }
}


