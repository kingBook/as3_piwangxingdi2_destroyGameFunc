package framework.flintparticles.common.utils
{
   import flash.events.EventDispatcher;
   import flash.display.Shape;
   import flash.events.Event;
   import flash.utils.getTimer;
   import framework.flintparticles.common.events.UpdateEvent;
   
   public class FrameUpdater extends EventDispatcher
   {
      
      public function FrameUpdater()
      {
         super();
         this._shape = new Shape();
      }
      
      private static var _instance:FrameUpdater;
      
      public static function get instance() : FrameUpdater
      {
         if(_instance == null)
         {
            _instance = new FrameUpdater();
         }
         return _instance;
      }
      
      private var _shape:Shape;
      
      private var _time:Number;
      
      private var _running:Boolean = false;
      
      private function startTimer() : void
      {
         this._shape.addEventListener(Event.ENTER_FRAME,this.frameUpdate,false,0,true);
         this._time = getTimer();
         this._running = true;
      }
      
      private function stopTimer() : void
      {
         this._shape.removeEventListener(Event.ENTER_FRAME,this.frameUpdate);
         this._running = false;
      }
      
      private function frameUpdate(ev:Event) : void
      {
         var oldTime:int = this._time;
         this._time = getTimer();
         var frameTime:Number = (this._time - oldTime) * 0.001;
         dispatchEvent(new UpdateEvent(UpdateEvent.UPDATE,frameTime));
      }
      
      override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, weakReference:Boolean = false) : void
      {
         super.addEventListener(type,listener,useCapture,priority,weakReference);
         if((!this._running) && (hasEventListener(UpdateEvent.UPDATE)))
         {
            this.startTimer();
         }
      }
      
      override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
      {
         super.removeEventListener(type,listener,useCapture);
         if((this._running) && (!hasEventListener(UpdateEvent.UPDATE)))
         {
            this.stopTimer();
         }
      }
   }
}
