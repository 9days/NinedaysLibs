package ninedays.display
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.geom.Matrix;
    import flash.geom.Rectangle;

    /**
     * 九宫格位图
     * @author riggzhuo
     *
     */
    public class Scale9GridBitmap extends Bitmap
    {

        protected var source:BitmapData;

        protected var _scale9Grid:Rectangle;

        protected var _width:Number = 0;

        protected var _height:Number = 0;


        public function Scale9GridBitmap(bitmapData:BitmapData, scale9Grid:Rectangle)
        {
            _width = bitmapData ? bitmapData.width : 0;
            _height = bitmapData ? bitmapData.height : 0;
            source = bitmapData;
            _scale9Grid = scale9Grid
            render();
        }


        protected function render():void
        {
            if (source == null)
            {
                super.bitmapData = null;
                return;
            }
			
			super.bitmapData = new BitmapData(_width, _height, true, 0x000000);
			
            if (illegalScale9Grid)
            {
				bitmapData.draw(source, new Matrix(_width / source.width, 0, 0, _height / source.height));
                return;
            }

            var rightColWidth:Number = source.width - (scale9Grid.x + scale9Grid.width);
            var bottomRowHeight:Number = source.height - (scale9Grid.y + scale9Grid.height);

            var drawClipRect:Rectangle;

            var scaleMatrix:Matrix;

            var tW:Number;
            var tH:Number;

            var tWScale:Number;
            var tHScale:Number;

            var tWOuterScale1:Number;
            var tHOuterScale1:Number;
            var tWOuterScale2:Number;
            var tHOuterScale2:Number;

            var tX2:Number;
            var tX3:Number;

            var tY2:Number;
            var tY3:Number;

            tW = _width - scale9Grid.x - rightColWidth;
            tH = _height - scale9Grid.y - bottomRowHeight;
			
			if(tW < 0)
				tW = 0;
			if(tH < 0)
				tH = 0;
			
            tWScale = tW / scale9Grid.width;
            tHScale = tH / scale9Grid.height;

			bitmapData.lock();

            tX2 = scale9Grid.x - scale9Grid.x * tWScale;
            tY2 = scale9Grid.y - scale9Grid.y * tHScale;
			
			tWOuterScale1 = tW > 0 ? 1 : (_width / (scale9Grid.x + source.width - scale9Grid.right));
			tHOuterScale1 = tH > 0 ? 1 : (_height / (scale9Grid.y + source.height - scale9Grid.bottom));
			
			tX3 = (scale9Grid.x * tWOuterScale1 + tW);
			tY3 = (scale9Grid.y * tHOuterScale1 + tH);
			
			// [1] | [2] | [3]
			// ---------------
			// [4] | [5] | [6]
			// ---------------
			// [7] | [8] | [9]

            // [1]
            scaleMatrix = new Matrix(tWOuterScale1, 0, 0, tHOuterScale1, 0, 0);
            drawClipRect = new Rectangle(0, 0, scale9Grid.x * tWOuterScale1, scale9Grid.y * tHOuterScale1);
            bitmapData.draw(source, scaleMatrix, null, null, drawClipRect);

            // [2]
            scaleMatrix = new Matrix(tWScale, 0, 0, tHOuterScale1, tX2, 0);
            drawClipRect = new Rectangle(scale9Grid.x, 0, tW > 0 ? tW : 0, scale9Grid.y * tHOuterScale1);
            bitmapData.draw(source, scaleMatrix, null, null, drawClipRect);

            // [3]
            scaleMatrix = new Matrix(tWOuterScale1, 0, 0, tHOuterScale1, tW - scale9Grid.width, 0);
            drawClipRect = new Rectangle(tX3, 0, rightColWidth * tWOuterScale1, scale9Grid.y * tHOuterScale1);
            bitmapData.draw(source, scaleMatrix, null, null, drawClipRect);

            // [4]
            scaleMatrix = new Matrix(tWOuterScale1, 0, 0, tHScale, 0, tY2);
            drawClipRect = new Rectangle(0, scale9Grid.y, scale9Grid.x * tWOuterScale1, tH > 0 ? tH : 0);
            bitmapData.draw(source, scaleMatrix, null, null, drawClipRect);

            // [5]
            scaleMatrix = new Matrix(tWScale, 0, 0, tHScale, tX2, tY2);
            drawClipRect = new Rectangle(scale9Grid.x, scale9Grid.y, tW > 0 ? tW : 0, tH > 0 ? tH : 0);
            bitmapData.draw(source, scaleMatrix, null, null, drawClipRect);

            // [6]
            scaleMatrix = new Matrix(tWOuterScale1, 0, 0, tHScale, tW - scale9Grid.width, tY2);
            drawClipRect = new Rectangle(tX3, scale9Grid.y, rightColWidth * tWOuterScale1, tH > 0 ? tH : 0);
            bitmapData.draw(source, scaleMatrix, null, null, drawClipRect);

            // [7]
            scaleMatrix = new Matrix(tWOuterScale1, 0, 0, tHOuterScale1, 0, tH - scale9Grid.height);
            drawClipRect = new Rectangle(0, tY3, scale9Grid.x * tWOuterScale1, bottomRowHeight * tHOuterScale1);
            bitmapData.draw(source, scaleMatrix, null, null, drawClipRect);

            // [8]
            scaleMatrix = new Matrix(tWScale, 0, 0, tHOuterScale1, tX2, tH - scale9Grid.height);
            drawClipRect = new Rectangle(scale9Grid.x, tY3, tW > 0 ? tW : 0, bottomRowHeight * tHOuterScale1);
            bitmapData.draw(source, scaleMatrix, null, null, drawClipRect);

            // [9]
            scaleMatrix = new Matrix(tWOuterScale1, 0, 0, tHOuterScale1, tW - scale9Grid.width, tH - scale9Grid.height);
            drawClipRect = new Rectangle(tX3, tY3, rightColWidth * tWOuterScale1, bottomRowHeight * tHOuterScale1);
            bitmapData.draw(source, scaleMatrix, null, null, drawClipRect);
			
			bitmapData.unlock();
        }

        /**
         * 设置的九宫格是否非法
         * @return
         *
         */
        private function get illegalScale9Grid():Boolean
        {
            return scale9Grid == null || source.width < scale9Grid.width + scale9Grid.x || source.height < scale9Grid.height + scale9Grid.y || scale9Grid.width <= 0 || scale9Grid.height <= 0;
        }


        override public function set bitmapData(value:BitmapData):void
        {
            source = value;
            render();
        }

        override public function set scale9Grid(rect:Rectangle):void
        {
            _scale9Grid = rect;
            render();
        }

        override public function get scale9Grid():Rectangle
        {
            return _scale9Grid;
        }

        override public function set width(value:Number):void
        {
            if (isNaN(value))
                value = 0;
            value = Math.max(1, value);
            _width = Math.round(value);
            render();
        }

        override public function get width():Number
        {
            return _width;
        }

        override public function set height(value:Number):void
        {
            if (isNaN(value))
                value = 0;
            value = Math.max(1, value);
            _height = Math.round(value);
            render();
        }

        override public function get height():Number
        {
            return _height;
        }

        override public function set scaleX(value:Number):void
        {
            width = source.width * value;
        }

        override public function get scaleX():Number
        {
            return width / source.width;
        }

        override public function set scaleY(value:Number):void
        {
            height = source.height * value;
        }

        override public function get scaleY():Number
        {
            return height / source.height;
        }

        override public function set x(value:Number):void
        {
            super.x = Math.round(value);
        }

        override public function set y(value:Number):void
        {
            super.y = Math.round(value);
        }
		
		public function destroy():void
		{
			bitmapData.dispose();
			source = null;
			_scale9Grid = null;
		}
    }
}