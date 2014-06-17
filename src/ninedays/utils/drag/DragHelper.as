package ninedays.utils.drag
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.display.InteractiveObject;
    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.events.MouseEvent;
    import flash.geom.Matrix;
    import flash.geom.Rectangle;

    import ninedays.utils.FilterUtils;

    public class DragHelper
    {
        protected var _target:InteractiveObject;

        protected var _data:*;

        public function set data(v:*):void
        {
            _data = v;
        }

        protected var _dragedElement:DisplayObject;

        protected var _dragRender:Function;

        protected var _isMoved:Boolean = false;

        public function DragHelper(target:InteractiveObject, data:* = null, dragRender:Function = null)
        {
            _target = target;
            _data = data;
            _dragRender = dragRender;

            _target.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
        }

        protected function mouseDown(e:MouseEvent):void
        {
            var target:DisplayObject = e.target as DisplayObject;
            target.stage.addEventListener(MouseEvent.MOUSE_OUT, onStageOutHandle);
            target.stage.addEventListener(MouseEvent.MOUSE_OVER, onStageOverHandle);
            target.stage.addEventListener(MouseEvent.MOUSE_MOVE, onStageMoveHandle);
            target.stage.addEventListener(MouseEvent.MOUSE_UP, onStageUpHandle);
            _isMoved = false;
        }

        protected function onStageOutHandle(e:MouseEvent):void
        {
            (e.target as DisplayObject).dispatchEvent(new DragEvent(DragEvent.OUT, _data, _target));
        }

        protected function onStageOverHandle(e:MouseEvent):void
        {
            (e.target as DisplayObject).dispatchEvent(new DragEvent(DragEvent.OVER, _data, _target));
        }

        protected function onStageMoveHandle(e:MouseEvent):void
        {
            if (_dragedElement == null)
            {
                if (_dragRender == null)
                {
                    var bmd:BitmapData = new BitmapData(_target.width / _target.scaleX, _target.height / _target.scaleY, true, 0);
                    var rect:Rectangle = _target.getBounds(_target);
                    var matrix:Matrix = _target.root.transform.concatenatedMatrix;
                    matrix.tx = -rect.x;
                    matrix.ty = -rect.y;
                    bmd.draw(_target, new Matrix(1, 0, 0, 1, -rect.x, -rect.y));
                    _dragedElement = new Bitmap(bmd);
                    _dragedElement.transform.matrix = _target.transform.concatenatedMatrix;
                }
                else
                {
                    _dragedElement = _dragRender(_data);
                }
                _target.filters = FilterUtils.GRAY_FILTER;
//                MatrixUtil.getDecolorMatrix().apply(_target as DisplayObject);
                if (_dragedElement is Sprite)
                {
                    (_dragedElement as Sprite).mouseEnabled = false;
                    (_dragedElement as Sprite).mouseChildren = false;
                }
                (e.currentTarget as DisplayObject).stage.addChild(_dragedElement);
            }

            var bound:Rectangle = _dragedElement.getBounds(_dragedElement);
            var centerX:int = (bound.left + bound.right) / 2;
            var centerY:int = (bound.top + bound.bottom) / 2;
            /*__dragedElement.x = (e.currentTarget as DisplayObject).stage.mouseX - __dragedElement.width / 2;
             __dragedElement.y = (e.currentTarget as DisplayObject).stage.mouseY - __dragedElement.height / 2;*/
            _dragedElement.x = (e.currentTarget as DisplayObject).stage.mouseX - centerX;
            _dragedElement.y = (e.currentTarget as DisplayObject).stage.mouseY - centerY;
            (e.target as DisplayObject).dispatchEvent(new DragEvent(DragEvent.MOVE, _data, _target));
            _isMoved = true;
        }

        protected function onStageUpHandle(e:MouseEvent):void
        {
            (e.currentTarget as Stage).removeEventListener(MouseEvent.MOUSE_OUT, onStageOutHandle);
            (e.currentTarget as Stage).removeEventListener(MouseEvent.MOUSE_OVER, onStageOverHandle);
            (e.currentTarget as Stage).removeEventListener(MouseEvent.MOUSE_MOVE, onStageMoveHandle);
            (e.currentTarget as Stage).removeEventListener(MouseEvent.MOUSE_UP, onStageUpHandle);
            if (_dragedElement == null)
            {
            }
            else
            {
                _dragedElement.parent.removeChild(_dragedElement);
                if (_dragedElement is Bitmap && _dragRender == null)
                {
                    (_dragedElement as Bitmap).bitmapData.dispose();
                }
                _dragedElement = null;
            }
            _target.filters = [];
//            MatrixUtil.getDecolorMatrix().unapply(_target as DisplayObject);
            if (_isMoved)
                (e.target as DisplayObject).dispatchEvent(new DragEvent(DragEvent.Drop, _data, _target));
        }

        public function destroy():void
        {
            _target.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
            _target = null;
            _dragRender = null;
            _dragedElement = null;
        }
    }
}