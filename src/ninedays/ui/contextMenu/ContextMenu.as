package ninedays.ui.contextMenu
{

    public class ContextMenu
    {
        public var customItems:Array;

        public function ContextMenu()
        {
            customItems = [];
        }

        public function addItem(item:ContextMenuItem):void
        {
            removeItem(item);
            customItems.push(item);
        }

        public function removeItem(item:ContextMenuItem):Boolean
        {
            var index:int = customItems.indexOf(item);
            if (index != -1)
            {
                customItems.splice(index, 1);
                return true;
            }
            return false;
        }

        public function removeAllItems():void
        {
            customItems = [];
        }
    }
}