package ninedays.astar
{
	public class AStarNode
	{
		public var x:int;
		
		public var y:int;
		
		public var f:Number;
		
		public var g:Number;
		
		public var h:Number;
		
		public var walkable:Boolean = true;
		
		public var parent:AStarNode;
		
		public var version:int = 1;
		
		public var links:Array;
		
		public function AStarNode(x:int, y:int)
		{
			this.x = x;
			this.y = y;
		}
	}
}