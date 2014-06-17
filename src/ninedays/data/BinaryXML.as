package ninedays.data
{
    import flash.utils.ByteArray;

    public class BinaryXML
    {
        public var nodeName:String;

        public var simpleContent:String;

        protected var _attributes:Object;

        protected var _children:Vector.<BinaryXML>;

        protected var _parentNode:BinaryXML;

        public function BinaryXML()
        {
            clear();
        }

        public function clear():void
        {
            _children = new Vector.<BinaryXML>();
            nodeName = null;
            simpleContent = null;
            _parentNode = null;
        }

        public function get children():Vector.<BinaryXML>
        {
            return _children;
        }

        public function attribute(attributeName:String):String
        {
            return _attributes ? _attributes[attributeName] : null;
        }

        public function set attributes(value:Object):void
        {
            _attributes = value;
        }

        public function get attributes():Object
        {
            return _attributes;
        }

        public function set parentNode(value:BinaryXML):void
        {
            if (value.children.indexOf(this) >= 0)
            {
                _parentNode = value;
            }
        }

        public function get parentNode():BinaryXML
        {
            return _parentNode;
        }

        /**
         * 列出nodeName为name的元素。
         * @return
         *
         */
        public function elements(name:String):Vector.<BinaryXML>
        {
            var result:Vector.<BinaryXML> = new Vector.<BinaryXML>();
            for each (var node:BinaryXML in _children)
            {
                if (node.nodeName == name)
                {
                    result.push(node);
                }
            }
            return result;
        }

        /**
         * 列出nodeName为name的所有后代（子级、孙级、曾孙级等）。
         * @return
         *
         */
        public function descendants(name:String):Vector.<BinaryXML>
        {
            var result:Vector.<BinaryXML> = new Vector.<BinaryXML>();
            findChildByNodeName(result, name, this);
            return result;
        }

        private function findChildByNodeName(result:Vector.<BinaryXML>, findNodeName:String, parent:BinaryXML):void
        {
            for each (var node:BinaryXML in parent.children)
            {
                if (node.nodeName == findNodeName)
                {
                    result.push(node);
                }
				findChildByNodeName(result, findNodeName, node);
            }
        }

        /**
         * 确定该对象在其父项上下文中从 0 开始编制索引的位置。
         * @return
         *
         */
        public function get index():int
        {
            return _parentNode ? _parentNode.children.indexOf(this) : -1;
        }

        /**
         * child的索引
         * @return
         *
         */
        public function getChildIndex(child:BinaryXML):int
        {
            return _children.indexOf(child);
        }

        public function addChild(node:BinaryXML):void
        {
            _children.push(node);
        }

        public function removeChild(node:BinaryXML):Boolean
        {
            var index:int = _children.indexOf(node);
            if (index >= 0)
            {
                _children.splice(index, 1);
                return true;
            }
            return false;
        }

        public function removeChildAt(index:int):Boolean
        {
            if (_children.length < index)
            {
                _children.splice(index, 1);
                return true;
            }
            return false;
        }


        public function importXML(xml:XML):void
        {
            clear();
            parseXMLNode(xml, this, null);
        }
		
		public function appendXML(xml:XML):void
		{
			parseXMLNode(xml, this, null);
		}

        private function parseXMLNode(xml:XML, node:BinaryXML, parentNode:BinaryXML):void
        {
			node.nodeName = xml.name();
			node.simpleContent = null;
			
			if(node.nodeName == null)
			{
				node.simpleContent = xml.toString();
			}
			
            var attrs:XMLList = xml.attributes();
			if(attrs.length() > 0)
			{
				node.attributes = {};
				for each (var attr:XML in attrs)
				{
					node.attributes[attr.localName()] = attr.toString();
				}
			}
			else
			{
				node.attributes = null;
			}

            if (parentNode)
            {
                parentNode.addChild(node);
                node.parentNode = parentNode;
            }


            for each (var child:XML in xml.children())
            {
                parseXMLNode(child, new BinaryXML(), node);
            }
        }

		/**
		 * 导出 ByteArray
		 * @param compressAlgorithm	压缩算法，null为不压缩
		 * @return 
		 * 
		 */		
        public function exportByteArray(compressAlgorithm:String = "zlib"):ByteArray
        {
            var result:ByteArray = new ByteArray();
            encryptToByteArray(result, this);
			compressAlgorithm && result.compress();
            return result;
        }

        private function encryptToByteArray(bytes:ByteArray, node:BinaryXML):void
        {
            var len:int = node.children.length;
			if(node.nodeName)
			{
				bytes.writeByte(1);
				bytes.writeUTF(node.nodeName);
			}
			else
			{
				bytes.writeByte(0);
			}
			
			if(node.simpleContent)
			{
				bytes.writeByte(1);
				bytes.writeUTF(node.simpleContent);
			}
			else
			{
				bytes.writeByte(0);
			}
			
			if(node.attributes)
			{
				bytes.writeByte(1);
				bytes.writeObject(node.attributes);
			}
			else
			{
				bytes.writeByte(0);
			}
			
            bytes.writeUnsignedInt(len);
            for (var i:int = 0; i < len; i++)
            {
                encryptToByteArray(bytes, node.children[i]);
            }
        }

        private function decryptByteArray(bytes:ByteArray, node:BinaryXML):void
        {
			var hasNodeName:int = bytes.readByte();
			if(hasNodeName)
			{
				node.nodeName = bytes.readUTF();
			}
			else
			{
				node.nodeName = null;
			}
			var hasSimpleContent:int = bytes.readByte();
			if(hasSimpleContent)
			{
				node.simpleContent = bytes.readUTF();
			}
			else
			{
				node.simpleContent = null;
			}
			
			var hasAttribytes:int = bytes.readByte();
			if(hasAttribytes)
			{
				node.attributes = bytes.readObject();
			}
			else
			{
				node.attributes = null;
			}
           
            var len:int = bytes.readUnsignedInt();
            for (var i:int = 0; i < len; i++)
            {
                var newNode:BinaryXML = new BinaryXML();
                node.addChild(newNode);
                newNode.parentNode = node;
                decryptByteArray(bytes, newNode);
            }
        }

		/**
		 * 导入ByteArray 
		 * @param bytes
		 * @param uncompressAlgorithm	解压算法，null为不解压
		 * 
		 */		
        public function importByteArray(bytes:ByteArray, uncompressAlgorithm:String = "zlib"):void
        {
			uncompressAlgorithm && bytes.uncompress(uncompressAlgorithm);
            clear();
            decryptByteArray(bytes, this);
        }
    }
}