package ninedays.data
{
    import flash.utils.Dictionary;

    public class HashMap implements ICollection
    {
        private var _length:int;

        private var _content:Dictionary;

        private var _weakKeys:Boolean;

        public function HashMap(weakKeys:Boolean = false)
        {
            this._weakKeys = weakKeys;
            this._length = 0;
            this._content = new Dictionary(weakKeys);
        }

        public function get weakKeys():Boolean
        {
            return this._weakKeys;
        }

        public function get length():int
        {
            return this._length;
        }

        public function isEmpty():Boolean
        {
            return this._length == 0;
        }

        public function getKeys():Array
        {
            var result:Array = [];
            for (var key:Object in this._content)
            {

                result.push(key);
            }
            return result;
        }

        public function getValues():Array
        {
            var result:Array = [];
            for each (var value:Object in this._content)
            {

                result.push(value);
            }
            return result;
        }

        public function eachKey(func:Function):void
        {
            for (var key:Object in this._content)
            {
                func(key);
            }
        }

        public function eachValue(func:Function):void
        {
            for each (var value:Object in _content)
            {
                func(value);
            }
        }

        public function forEach(func:Function):void
        {
            for (var key:Object in this._content)
            {
                func(key, this._content[key]);
            }
        }

        public function containsValue(value:Object):Boolean
        {
            for each (var value2:Object in this._content)
            {
                if (value2 === value)
                {
                    return true;
                }
            }
            return false;
        }

        public function some(func:Function):Boolean
        {
            for (var key:Object in this._content)
            {
                if (func(key, this._content[key]))
                {
                    return true;
                }
            }
            return false;
        }

        public function every(func:Function):Boolean
        {
            for (var key:Object in this._content)
            {
                if (!func(key, this._content[key]))
                {
                    return false;
                }
            }
            return true;
        }

        public function filter(func:Function):Array
        {
            var result:Array = [];
            for (var key:Object in this._content)
            {
                var value:Object = this._content[key];
                if (func(key, value))
                {
                    result.push(value);
                }
            }
            return result;
        }

        public function containsKey(key:Object):Boolean
        {
            return (key in _content);
        }

        public function getValue(key:Object):Object
        {
            return _content[key];
        }

        public function getKey(value:Object):Object
        {
            for (var key:Object in this._content)
            {
                if (this._content[key] == value)
                {
                    return key;
                }
            }
            return null;
        }

        public function add(key:Object, value:Object):Object
        {
            if (key == null)
            {
                throw new ArgumentError("cannot put a value with undefined or null key!");
            }
            if (!(key in this._content))
            {
                _length++;
            }
            var oldValue:Object = this.getValue(key);
            this._content[key] = value;
            return oldValue;
        }

        public function remove(key:Object):Object
        {
            if (!(key in _content))
            {
                return null;
            }
            var value:Object = _content[key];
            delete _content[key];
            _length--;
            return value;
        }

        public function clear():void
        {
            this._length = 0;
            this._content = new Dictionary(this._weakKeys);
        }

        public function clone():HashMap
        {
            var result:HashMap = new HashMap(this._weakKeys);
            for (var key:Object in this._content)
            {

                result.add(key, this._content[key]);
            }
            return result;
        }
    }
}