package framework.flintparticles.common.events
{
   import flash.events.Event;
   
   public class UpdateEvent extends Event
   {
      
      public function UpdateEvent(type:String, time:Number = NaN, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.time = time;
      }
      
      public static var UPDATE:String = "update";
      
      public var time:Number;
      
      override public function clone() : Event
      {
         return new UpdateEvent(type,this.time,bubbles,cancelable);
      }
   }
}
