package ninedays.component.treeClasses
{
    import flash.events.EventDispatcher;
    
    import ninedays.data.BinaryXML;
    import ninedays.data.DataProvider;




    public class TreeDataProvider extends DataProvider
    {

        public static const OPEN_NODE:String = "openNode";

        public static const CLOSED_NODE:String = "closedNode";

        public static const BRANCH_NODE:String = "branchNode";

        public static const LEAF_NODE:String = "leafNode";

        public static const ROOT_NODE:String = "rootNode";

        public var rootNode:TNode;


        public function TreeDataProvider(value:Object = null)
        {
            data = [];
            super(value);
        }


        public function toggleNode(nodeIndex:int):void
        {
            var currentNode:TNode = this.getItemAt(nodeIndex) as TNode;
            if (currentNode is BranchNode && !(currentNode is RootNode))
            {
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

        public function createTreeFromBinaryXML(xml:BinaryXML):void
        {

            rootNode = new RootNode(this);

            rootNode.drawNode();
            for each (var child:BinaryXML in xml.children)
            {
				parseBinaryXMLNode(child, rootNode as BranchNode);
            }
        }
		
		private function parseBinaryXMLNode(xml:BinaryXML, parentNode:BranchNode):void
		{
			var newNode:TNode;
			
			if (xml.children.length > 0)
			{
				newNode = new BranchNode(this);
			}
			else
			{
				newNode = new LeafNode(this);
			}
			
			newNode.attributes = xml.attributes;
			
			parentNode.addChildNode(newNode);
			
			
			for each (var child:BinaryXML in xml.children)
			{
				parseBinaryXMLNode(child, newNode as BranchNode);
			}
		}
		
        public function createTreeFromXML(xml:XML):void
        {

            rootNode = new RootNode(this);

            rootNode.drawNode();
            for each (var child:XML in xml.children())
            {
                parseXMLNode(child, rootNode as BranchNode);
            }
        }

        private function parseXMLNode(xml:XML, parentNode:BranchNode):void
        {
            var newNode:TNode;

            if (xml.children().length() > 0)
            {
                newNode = new BranchNode(this);
            }
            else
            {
                newNode = new LeafNode(this);
            }

            var attrs:XMLList = xml.attributes();
            for each (var attr:XML in attrs)
            {
                newNode.attributes[attr.localName()] = attr.toString();
            }

            parentNode.addChildNode(newNode);


            for each (var child:XML in xml.children())
            {
                parseXMLNode(child, newNode as BranchNode);
            }

        }

        private function isTreeNode(obj:Object):Boolean
        {
            return (obj is TNode);
        }

        override protected function getDataFromObject(obj:Object):Array
        {
            if (obj is XML)
            {
                var xml:XML = obj as XML;
                createTreeFromXML(xml);
                return this.toArray();
            }
			else if(obj is BinaryXML)
			{
				createTreeFromBinaryXML(obj as BinaryXML);
				return this.toArray();
			}
            else
            {
                throw new TypeError("Error: Type Coercion failed: cannot convert " + obj + " to TreeDataProvider.");
                return null;
            }
        }
    }
}