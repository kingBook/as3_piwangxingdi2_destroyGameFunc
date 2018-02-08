package framework.events
{
   import flash.events.Event;
   
   public class ScorllEvent extends Event
   {
      
      public function ScorllEvent(type:String, info:* = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         this.info = info;
         super(type,bubbles,cancelable);
      }
      
      public static var UPDATE:String = "update";
      
      public var info:*;
      
      override public function clone() : Event
      {
         return new ScorllEvent(type,this.info,bubbles,cancelable);
      }
   }
}
