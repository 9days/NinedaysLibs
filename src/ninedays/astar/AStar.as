package ninedays.astar
{
    import flash.utils.getTimer;

    public class AStar
    {
        private var _open:BinaryHeap;

        private var _map:AStarMap;

        private var _endNode:AStarNode;

        private var _startNode:AStarNode;

        private var _path:Array;

        private var _straightCost:Number = 1.0;

        private var _diagCost:Number = Math.SQRT2;

        private var nowversion:int = 1;

        public function AStar(map:AStarMap)
        {
            this._map = map;
        }

        private function justMin(x:AStarNode, y:AStarNode):Boolean
        {
            return x.f < y.f;
        }

        public function findPath():Boolean
        {
            _endNode = _map.endNode;
            nowversion++;
            _startNode = _map.startNode;
            _open = new BinaryHeap(justMin);
            _startNode.g = 0;
            return search();
        }

        public function search():Boolean
        {
            var node:AStarNode = _startNode;
            node.version = nowversion;
            while (node != _endNode)
            {
                var len:int = node.links.length;
                for (var i:int = 0; i < len; i++)
                {
                    var test:AStarNode = node.links[i].node;
                    var cost:Number = node.links[i].cost;
                    var g:Number = node.g + cost;
                    var h:Number = heuristic(test);
                    var f:Number = g + h;
                    if (test.version == nowversion)
                    {
                        if (test.f > f)
                        {
                            test.f = f;
                            test.g = g;
                            test.h = h;
                            test.parent = node;
                        }
                    }
                    else
                    {
                        test.f = f;
                        test.g = g;
                        test.h = h;
                        test.parent = node;
                        _open.ins(test);
                        test.version = nowversion;
                    }
                }
                if (_open.array.length == 1)
                {
                    return false;
                }
                node = _open.pop() as AStarNode;
            }
            buildPath();
            return true;
        }

        private function buildPath():void
        {
            _path = [];
            var node:AStarNode = _endNode;
            _path.push(node);
            while (node != _startNode)
            {
                node = node.parent;
                _path.unshift(node);
            }
        }

        public function get path():Array
        {
            return _path;
        }


		private function heuristic(node:AStarNode):Number
        {
            var dx:Number = node.x - _endNode.x;
            var dy:Number = node.y - _endNode.y;
            return dx * dx + dy * dy;
        }
		
		public function destroy():void
		{
			_map.destroy();
			_map = null;
			_startNode = null;
			_endNode = null;
			_path = null;
		}
    }
}