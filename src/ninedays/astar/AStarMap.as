package ninedays.astar
{

    public class AStarMap
    {
        private var _startNode:AStarNode;

        private var _endNode:AStarNode;

        private var _nodes:Array;

        private var _numCols:int;

        private var _numRows:int;

        private var type:int;

        private var _straightCost:Number = 1.0;

        private var _diagCost:Number = Math.SQRT2;

        public function AStarMap(numCols:int, numRows:int)
        {
            _numCols = numCols;
            _numRows = numRows;
            _nodes = new Array();
            for (var i:int = 0; i < _numCols; i++)
            {
                _nodes[i] = new Array();
                for (var j:int = 0; j < _numRows; j++)
                {
                    _nodes[i][j] = new AStarNode(i, j);
                }
            }
        }

        /**
         *
         * @param    type    0四方向 1八方向 2跳棋
         */
        public function calculateLinks(type:int = 0):void
        {
            this.type = type;
            for (var i:int = 0; i < _numCols; i++)
            {
                for (var j:int = 0; j < _numRows; j++)
                {
                    initNodeLink(_nodes[i][j], type);
                }
            }
        }

        public function getType():int
        {
            return type;
        }

        /**
         *
         * @param    node
         * @param    type    0八方向 1四方向 2跳棋
         */
        private function initNodeLink(node:AStarNode, type:int):void
        {
            var startX:int = Math.max(0, node.x - 1);
            var endX:int = Math.min(numCols - 1, node.x + 1);
            var startY:int = Math.max(0, node.y - 1);
            var endY:int = Math.min(numRows - 1, node.y + 1);
            node.links = [];
            for (var i:int = startX; i <= endX; i++)
            {
                for (var j:int = startY; j <= endY; j++)
                {
                    var test:AStarNode = getNode(i, j);
                    if (test == node || !test.walkable)
                    {
                        continue;
                    }
                    if (type != 2 && i != node.x && j != node.y)
                    {
                        var test2:AStarNode = getNode(node.x, j);
                        if (!test2.walkable)
                        {
                            continue;
                        }
                        test2 = getNode(i, node.y);
                        if (!test2.walkable)
                        {
                            continue;
                        }
                    }
                    var cost:Number = _straightCost;
                    if (!((node.x == test.x) || (node.y == test.y)))
                    {
                        if (type == 1)
                        {
                            continue;
                        }
                        if (type == 2 && (node.x - test.x) * (node.y - test.y) == 1)
                        {
                            continue;
                        }
                        if (type == 2)
                        {
                            cost = _straightCost;
                        }
                        else
                        {
                            cost = _diagCost;
                        }
                    }
                    node.links.push(new Link(test, cost));
                }
            }
        }

        public function getNode(x:int, y:int):AStarNode
        {
            return _nodes[x][y];
        }
		
		/**
		 * 设置起点 
		 * @param x
		 * @param y
		 * 
		 */		
		public function setStartNode(x:int, y:int):void
		{
			_startNode = _nodes[x][y];
		}
		
		/**
		 * 设置终点 
		 * @param x
		 * @param y
		 * 
		 */		
        public function setEndNode(x:int, y:int):void
        {
            _endNode = _nodes[x][y];
        }

		/**
		 * 设置是否可行走 
		 * @param x
		 * @param y
		 * @param value
		 * 
		 */		
        public function setWalkable(x:int, y:int, value:Boolean):void
        {
            _nodes[x][y].walkable = value;
        }

        public function get endNode():AStarNode
        {
            return _endNode;
        }

        public function get numCols():int
        {
            return _numCols;
        }

        public function get numRows():int
        {
            return _numRows;
        }

        public function get startNode():AStarNode
        {
            return _startNode;
        }
		
		public function destroy():void
		{
			_startNode = null;
			_endNode = null;
			_nodes = null;
		}
    }
}