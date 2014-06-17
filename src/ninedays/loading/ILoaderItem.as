package ninedays.loading
{
    import ninedays.core.IDestroyable;

    public interface ILoaderItem extends IDestroyable
    {
        function load():void;
        function stop():void;
        function get content():*;
        function get bytesLoaded():int;
        function get bytesTotal():int;
    }
}