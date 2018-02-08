package framework.utils
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   
   public class Fps extends Object
   {
      
      public function Fps()
      {
         super();
      }
      
      private static var _stats:StatsKb;
      
      private static var _target:Sprite;
      
      public static function setup(target:Sprite) : void
      {
         _target = target;
         _stats = new StatsKb();
         if(_target.stage != null)
         {
            start();
         }
         else
         {
            _target.addEventListener(Event.ADDED_TO_STAGE,start);
         }
      }
      
      public static function set visible(value:Boolean) : void
      {
         if(value)
         {
            _target.addChild(_stats);
         }
         else if(_stats.parent != null)
         {
            _stats.parent.removeChild(_stats);
         }
         
      }
      
      public static function get visible() : Boolean
      {
         return _target.contains(_stats);
      }
      
      private static function start(evt:Event = null) : void
      {
         _target.stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDownHandler);
      }
      
      private static function onKeyDownHandler(evt:KeyboardEvent) : void
      {
         if((evt.shiftKey) && (evt.keyCode == 68))
         {
            visible = !visible;
         }
      }
   }
}
