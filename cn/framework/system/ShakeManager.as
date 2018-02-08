package framework.system
{
   import framework.Facade;
   import flash.display.DisplayObject;
   import flash.utils.Timer;
   import flash.events.TimerEvent;
   import framework.events.FrameworkEvent;
   import framework.utils.RandomKb;
   import framework.UpdateType;
   
   public class ShakeManager extends Object
   {
      
      public function ShakeManager(facade:Facade, shakeObj:DisplayObject)
      {
         super();
         this._facade = facade;
         this._shakeObj = shakeObj;
         this._initX = this._shakeObj.x;
         this._initY = this._shakeObj.y;
         this._facade.addEventListener(FrameworkEvent.PAUSE,this.pauseOrResumeHandler);
         this._facade.addEventListener(FrameworkEvent.RESUME,this.pauseOrResumeHandler);
         this._facade.addUpdateListener(UpdateType.UPDATE_2,this.update);
         this._facade.addEventListener(FrameworkEvent.DESTROY_ALL,this.destroyAll);
      }
      
      private var _facade:Facade;
      
      private var _shakeObj:DisplayObject;
      
      private var _doing:Boolean;
      
      private var _initX:Number = 0;
      
      private var _initY:Number = 0;
      
      private var _minDis:Number;
      
      private var _maxDis:Number;
      
      private var _frequency:Number;
      
      private var _count:int;
      
      private var _timer:Timer;
      
      public function shake(time:Number = 0.2, minDis:Number = 0, maxDis:Number = 10, frequency:Number = 100) : void
      {
         if(this._doing)
         {
            return;
         }
         this._doing = true;
         this._minDis = minDis;
         this._maxDis = maxDis;
         this._frequency = frequency;
         this._count = (time * this._frequency) || (1);
         this._timer = new Timer(int(1000 / this._frequency + 0.5),this._count);
         this.startTimer();
      }
      
      private function startTimer() : void
      {
         this._timer.addEventListener(TimerEvent.TIMER,this.shaking);
         this._timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.shakeComplete);
         this._timer.start();
      }
      
      private function stopTimer() : void
      {
         this._timer.removeEventListener(TimerEvent.TIMER,this.shaking);
         this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.shakeComplete);
         this._timer.stop();
      }
      
      private function pauseOrResumeHandler(e:FrameworkEvent) : void
      {
         if(!this._timer)
         {
            return;
         }
         if(e.type == FrameworkEvent.PAUSE)
         {
            this.stopTimer();
         }
         else
         {
            this.startTimer();
         }
      }
      
      private function shaking(e:TimerEvent) : void
      {
         var distance:Number = RandomKb.range(this._minDis,this._maxDis);
         var direction:Number = RandomKb.number(2 * Math.PI);
         var dx:Number = Math.cos(direction) * distance;
         var dy:Number = Math.sin(direction) * distance;
         this._shakeObj.x = this._initX + dx;
         this._shakeObj.y = this._initY + dy;
      }
      
      private function shakeComplete(e:TimerEvent) : void
      {
         this.stopTimer();
         this._shakeObj.x = this._initX;
         this._shakeObj.y = this._initY;
         this._doing = false;
         this._timer = null;
      }
      
      private function update() : void
      {
         var rate:* = NaN;
         if(this._doing)
         {
            rate = 0.2;
            this._shakeObj.x = this._shakeObj.x + (this._shakeObj.x - this._initX) * rate;
            this._shakeObj.y = this._shakeObj.y + (this._shakeObj.y - this._initY) * rate;
         }
      }
	  
	  public function destroy():void{
		  if(_facade){
			 _facade.removeEventListener(FrameworkEvent.PAUSE,this.pauseOrResumeHandler);
			 _facade.removeEventListener(FrameworkEvent.RESUME,this.pauseOrResumeHandler);
			 _facade.removeUpdateListener(UpdateType.UPDATE_2,this.update);
			 _facade.removeEventListener(FrameworkEvent.DESTROY_ALL,this.destroyAll);
		  }
		 if(this._timer)
         {
            this.stopTimer();
         }
         this._timer = null;
         this._doing = false;
      }
      private function destroyAll(e:FrameworkEvent) : void
      {
         destroy();
      }
   }
}
