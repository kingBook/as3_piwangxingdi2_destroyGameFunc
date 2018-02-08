package framework.snd.sound
{
   import framework.snd.signals.Signal;
   import flash.utils.getTimer;
   
   public class SoundTween extends Object
   {
      
	  private var _soundMan:SoundManager;
      public function SoundTween(soundMan:SoundManager,si:SoundInstance, endVolume:Number, duration:Number, isMasterFade:Boolean = false)
      {
         super();
         if(si)
         {
            this.sound = si;
            this.startVolume = this.sound.volume;
         }
         this.ended = new Signal(SoundInstance);
         this.isMasterFade = isMasterFade;
		 _soundMan=soundMan;
         this.init(this.startVolume,endVolume,duration);
      }
      
      protected static function easeOutQuad(position:Number, startValue:Number, change:Number, duration:Number) : Number
      {
         return -change * (position = position / duration) * (position - 2) + startValue;
      }
      
      protected static function easeInOutQuad(position:Number, startValue:Number, change:Number, duration:Number) : Number
      {
         if((position = position / (duration / 2)) < 1)
         {
            return change / 2 * position * position + startValue;
         }
         return -change / 2 * (--position * (position - 2) - 1) + startValue;
      }
      
      public var startTime:int;
      
      public var startVolume:Number;
      
      public var endVolume:Number;
      
      public var duration:Number;
      
      protected var isMasterFade:Boolean;
      
      protected var _sound:SoundInstance;
      
      protected var _isComplete:Boolean;
      
      public var ended:Signal;
      
      public var stopAtZero:Boolean;
      
      public function update(t:int) : Boolean
      {
         if(this._isComplete)
         {
            return this._isComplete;
         }
         if(this.isMasterFade)
         {
            if(t - this.startTime < this.duration)
            {
               _soundMan.masterVolume = easeOutQuad(t - this.startTime,this.startVolume,this.endVolume - this.startVolume,this.duration);
            }
            else
            {
               _soundMan.masterVolume = this.endVolume;
            }
            this._isComplete = _soundMan.masterVolume == this.endVolume;
         }
         else
         {
            if(t - this.startTime < this.duration)
            {
               this.sound.volume = easeOutQuad(t - this.startTime,this.startVolume,this.endVolume - this.startVolume,this.duration);
            }
            else
            {
               this.sound.volume = this.endVolume;
            }
            this._isComplete = this.sound.volume == this.endVolume;
         }
         return this._isComplete;
      }
      
      public function init(startVolume:Number, endVolume:Number, duration:Number) : void
      {
         this.startTime = getTimer();
         this.startVolume = startVolume;
         this.endVolume = endVolume;
         this.duration = duration;
         this._isComplete = false;
      }
      
      public function end(applyEndVolume:Boolean = false) : void
      {
         this._isComplete = true;
         if(!this.isMasterFade)
         {
            if(applyEndVolume)
            {
               this.sound.volume = this.endVolume;
            }
            if((this.stopAtZero) && (this.sound.volume == 0))
            {
               this.sound.stop();
            }
         }
         this.ended.dispatch(this.sound);
         this.ended.removeAll();
      }
      
      public function kill() : void
      {
         this._isComplete = true;
         this.ended.removeAll();
      }
      
      public function get isComplete() : Boolean
      {
         return this._isComplete;
      }
      
      public function get sound() : SoundInstance
      {
         return this._sound;
      }
      
      public function set sound(value:SoundInstance) : void
      {
         this._sound = value;
         if(!this.sound)
         {
            trace("SOUND IS NULLLLL");
         }
      }
   }
}
