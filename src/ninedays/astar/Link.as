package ninedays.astar
{
	internal class Link
	{
		public var node:AStarNode;
		
		public var cost:Number;
		
		public function Link(node:AStarNode, cost:Number)
		{
			this.node = node;
			this.cost = cost;
		}
	}
}