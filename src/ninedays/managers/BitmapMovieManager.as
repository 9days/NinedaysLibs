package ninedays.managers
{
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import ninedays.core.Singleton;
	import ninedays.display.BitmapFrame;
	import ninedays.display.BitmapMovie;

	public class BitmapMovieManager extends Singleton
	{
		private static var _instance:BitmapMovieManager;
		public static function get instance():BitmapMovieManager
		{
			return _instance ||= new BitmapMovieManager();
		}




		private var pools:Dictionary = new Dictionary();

		/**
		 * 用影片剪辑注册
		 * @param mc
		 * @param id
		 *
		 */
		public function registerByMovieClip(mc:MovieClip, id:String = null):void
		{
			id ||= mc.name;
			if (pools[id] == null)
			{
				var bitmapFrame:BitmapFrame;
				var frames:Vector.<BitmapFrame> = new Vector.<BitmapFrame>();
				mc.gotoAndStop(1);
				var bitmapData:BitmapData;
				var resultBitmapData:BitmapData;
				var rect:Rectangle;
				var i:int = 0;
				var x:int;
				var y:int;
				var totalFrames:int = mc.totalFrames;

				while (i++ < totalFrames)
				{
					mc.gotoAndStop(i);
					rect = mc.getBounds(mc);
					x = rect.x;
					y = rect.y;
					bitmapData = null;
					resultBitmapData = null;
					if (int(rect.width) > 0 && int(rect.height) > 0)
					{
						bitmapData = new BitmapData(rect.width, rect.height, true, 0);
						bitmapData.draw(mc, new Matrix(1, 0, 0, 1, -rect.x, -rect.y), null, null, null, true);
					}

					if (bitmapData != null)
					{
						rect = bitmapData.getColorBoundsRect(0xFF000000, 0, false);
						x += rect.x;
						y += rect.y;
						
						if(rect.width > 0 && rect.height > 0)
						{
							resultBitmapData = new BitmapData(rect.width, rect.height, true, 0)
							resultBitmapData.copyPixels(bitmapData, rect, new Point());
						}
						
						bitmapData.dispose();
					}

					if (bitmapFrame != null && bitmapFrame.bitmapData && resultBitmapData != null)
					{
						//和上一帧的位图比较，如果相同就用同一个位图
						if (bitmapFrame.bitmapData.compare(resultBitmapData) == 0)
						{
							resultBitmapData.dispose();
							resultBitmapData = bitmapFrame.bitmapData;
						}
					}
					bitmapFrame = new BitmapFrame();
					bitmapFrame.bitmapData = resultBitmapData;
					bitmapFrame.frameLabel = mc.currentFrameLabel;
					bitmapFrame.x = x;
					bitmapFrame.y = y;
					frames.push(bitmapFrame);
				}

				pools[id] = frames;
			}
		}


		/**
		 * 用位图注册
		 * @param source	位图数据
		 * @param col	列数
		 * @param totalFrames	总帧数
		 * @param id
		 *
		 */
		public function registerByBitmap(source:BitmapData, col:int, totalFrames:int, id:String):void
		{
			if (pools[id] == null)
			{
				var bitmapFrame:BitmapFrame;
				var frames:Vector.<BitmapFrame> = new Vector.<BitmapFrame>();
				var bitmapData:BitmapData;
				var resultBitmapData:BitmapData;

				var row:int = Math.ceil(totalFrames / col);
				var w:Number = source.width / col;
				var h:Number = source.height / row;
				var rect:Rectangle = new Rectangle(0, 0, w, h);
				var point:Point = new Point();
				var num:int = 0;
				for (var i:int = 0; i < row; i++)
				{
					for (var j:int = 0; j < col; j++)
					{
						if (num == totalFrames)
						{
							pools[id] = frames;
							return;
						}
						rect.x = j * w;
						rect.y = i * h;
						bitmapData = new BitmapData(w, h, true, 0);
						bitmapData.copyPixels(source, rect, point);

						var rect2:Rectangle = bitmapData.getColorBoundsRect(0xFF000000, 0, false);
						resultBitmapData = new BitmapData(rect2.width, rect2.height, true, 0)
						resultBitmapData.copyPixels(bitmapData, rect2, new Point());
						bitmapData.dispose();

						bitmapFrame = new BitmapFrame();
						bitmapFrame.bitmapData = resultBitmapData;
						bitmapFrame.frameLabel = null;
						bitmapFrame.x = rect2.x;
						bitmapFrame.y = rect2.y;
						frames.push(bitmapFrame);

						num++;
					}
				}

				pools[id] = frames;
			}
		}


		public function getBitmapFrames(id:String):Vector.<BitmapFrame>
		{
			if (pools[id] == null)
			{
				return null;
			}
			return pools[id] as Vector.<BitmapFrame>;
		}
		
		
		public function getBitmapMovie(id:String):BitmapMovie
		{
			if (pools[id] == null)
			{
				return null;
			}
			return new BitmapMovie(pools[id] as Vector.<BitmapFrame>);
		}
	}
}
