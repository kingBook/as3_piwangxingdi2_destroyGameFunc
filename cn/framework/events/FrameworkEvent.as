package framework.events
{
   import flash.events.Event;
   
   public class FrameworkEvent extends Event
   {
      
      public function FrameworkEvent(type:String, info:* = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         this.info = info;
         super(type,bubbles,cancelable);
      }
      
      public static var CHANGE_CURRENT_WORLD:String = "changeCurrentWorld";
      
      public static var DESTROY_ALL:String = "destroyAll";
      
      private static var _destroyAllEvt:FrameworkEvent;
      
      public static function getDestroyAllEvent(info:* = null) : FrameworkEvent
      {
         if(_destroyAllEvt == null)
         {
            _destroyAllEvt = new FrameworkEvent(DESTROY_ALL,info);
         }
         else
         {
            _destroyAllEvt.info = info;
         }
         return _destroyAllEvt;
      }
      
      public static var PAUSE:String = "pause";
      
      private static var _pauseEvt:FrameworkEvent;
      
      public static function getPauseEvent(info:* = null) : FrameworkEvent
      {
         if(_pauseEvt == null)
         {
            _pauseEvt = new FrameworkEvent(PAUSE,info);
         }
         else
         {
            _pauseEvt.info = info;
         }
         return _pauseEvt;
      }
      
      public static var RESUME:String = "resume";
      
      private static var _resumeEvt:FrameworkEvent;
      
      public static function getResumeEvent(info:* = null) : FrameworkEvent
      {
         if(_resumeEvt == null)
         {
            _resumeEvt = new FrameworkEvent(RESUME,info);
         }
         else
         {
            _resumeEvt.info = info;
         }
         return _resumeEvt;
      }
      
      public static var INITIALIZE_MODEL:String = "initializeModel";
      
      private static var _initModelEvt:FrameworkEvent;
      
      public static function getInitModelEvent(info:* = null) : FrameworkEvent
      {
         if(_initModelEvt == null)
         {
            _initModelEvt = new FrameworkEvent(INITIALIZE_MODEL,info);
         }
         else
         {
            _initModelEvt.info = info;
         }
         return _initModelEvt;
      }
      
      public static var INITIALIZE_MODEL_COMPLETE:String = "initializeModelComplete";
      
      private static var _initModelCompleteEvt:FrameworkEvent;
      
      public static function getInitModelCompleteEvent(info:* = null) : FrameworkEvent
      {
         if(_initModelCompleteEvt == null)
         {
            _initModelCompleteEvt = new FrameworkEvent(INITIALIZE_MODEL_COMPLETE,info);
         }
         else
         {
            _initModelCompleteEvt.info = info;
         }
         return _initModelCompleteEvt;
      }
      
      public static var DESTROY_VIEW:String = "destroyView";
      
      private static var _destroyViewEvt:FrameworkEvent;
      
      public static function getDestroyViewEvent(info:* = null) : FrameworkEvent
      {
         if(_destroyViewEvt == null)
         {
            _destroyViewEvt = new FrameworkEvent(DESTROY_VIEW,info);
         }
         else
         {
            _destroyViewEvt.info = info;
         }
         return _destroyViewEvt;
      }
      
      public var info:*;
      
      override public function clone() : Event
      {
         return new FrameworkEvent(type,this.info,bubbles,cancelable);
      }
      
      override public function toString() : String
      {
         return formatToString("FrameworkEvent","type","info","bubbles","cancelable","eventPhase");
      }
   }
}
