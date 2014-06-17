package ninedays.loading.items
{

    public class XMLItem extends BinaryItem
    {
        private var _xml:XML;
		
		public function XMLItem(url:String, id:String)
		{
			super(url, id);	
		}

        override protected function decode():void
        {
            try
            {
                var value:String = _data.readUTFBytes(_data.length);
                _xml = new XML(value);
                _data.clear();
                complete();
            }
            catch (e:Error)
            {
                fault();
            }
        }
		
		override public function get content():*
		{
			return _xml;
		}

        /**
         * 获得XML
         *
         * @return
         */
        public function get xml():XML
        {
            return _xml;
        }
    }
}