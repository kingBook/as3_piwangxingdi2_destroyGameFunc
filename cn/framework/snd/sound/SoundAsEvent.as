package framework.snd.sound
{
   import flash.events.Event;
   
   public class SoundAsEvent extends Event
   {
      
      public function SoundAsEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
      
      public static const MUTE:String = "mute";
      
      private static var _muteEvent:SoundAsEvent;
      
      public static function getMuteEvent() : SoundAsEvent
      {
         return _muteEvent = _muteEvent || new SoundAsEvent(MUTE);
      }
      
      override public function clone() : Event
      {
         return new SoundAsEvent(type,bubbles,cancelable);
      }
      
      override public function toString() : String
      {
         return formatToString("SoundAsEvent","type","bubbles","cancelable","eventPhase");
      }
   }
}
