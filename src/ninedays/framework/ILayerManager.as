package ninedays.framework
{
    import flash.display.Sprite;
    import flash.display.Stage;
    
    import ninedays.display.Layer;

    public interface ILayerManager
    {
        function setup(root:Sprite):void;
        function get stage():Stage;
        function get root():Sprite;
        function get mapLayer():Layer;
        function get uiLayer():Layer;
        function get popupLayer():Layer;
        function get alertLayer():Layer;
        function get tipsLevel():Layer;
        function get contextMenuLayer():Layer;
        function get mouseLayer():Layer;
    }
}