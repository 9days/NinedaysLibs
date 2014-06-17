package ninedays.loading.items
{

    public class JSONItem extends BinaryItem
    {
        private var _jsonObj:Object;
		
		public function JSONItem(url:String, id:String)
		{
			super(url, id);	
		}

        override protected function decode():void
        {
            try
            {
                _jsonObj = JSON.parse(_data.readUTFBytes(_data.length));
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
            return _jsonObj;
        }

        /**
         * 获得Object
         *
         * @return
         */
        public function get jsonObj():Object
        {
            return _jsonObj;
        }
    }
}