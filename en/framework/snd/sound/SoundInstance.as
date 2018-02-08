package framework.snd.sound
{
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import framework.snd.signals.Signal;
   import flash.media.SoundTransform;
   import flash.events.Event;
   
   public class SoundInstance extends Object
   {
      
      public function SoundInstance(soundMan:SoundManager,sound:Sound = null, type:String = null)
      {
         super();
         this.sound = sound;
         this.type = type;
         this.manager = soundMan;
         this.pauseTime = 0;
         this._volume = 1;
         this._pan = 0;
         this._soundTransform = new SoundTransform();
         this.soundCompleted = new Signal(SoundInstance);
         this.oldChannels = new Vector.<SoundChannel>(0);
      }
      
      public var manager:SoundManager;
      
      public var type:String;
      
      public var url:String;
      
      public var sound:Sound;
      
      public var channel:SoundChannel;
      
      public var soundCompleted:Signal;
      
      public var loops:int;
      
      public var allowMultiple:Boolean;
      
      public var oldChannels:Vector.<SoundChannel>;
      
      protected var _loopsRemaining:int;
      
      protected var _muted:Boolean;
      
      protected var _volume:Number;
      
      protected var _pan:Number;
      
      protected var _enableSeamlessLoops:Boolean;
      
      protected var pauseTime:Number;
      
      protected var _isPlaying:Boolean;
      
      protected var _soundTransform:SoundTransform;
      
      public var currentTween:SoundTween;
      
      public function get enableSeamlessLoops() : Boolean
      {
         return this._enableSeamlessLoops;
      }
      
      public function play(volume:Number = 1, startTime:Number = 0, loops:int = 0, allowMultiple:Boolean = true, enableSeamlessLoops:Boolean = false) : SoundInstance
      {
         this.loops = loops;
         this._enableSeamlessLoops = enableSeamlessLoops;
         var loops:int = loops < 0?int.MAX_VALUE:loops;
         this._loopsRemaining = 0;
         if(enableSeamlessLoops == false)
         {
            this._loopsRemaining = loops;
            loops = 0;
         }
         this.allowMultiple = allowMultiple;
         if(allowMultiple)
         {
            if(this.channel)
            {
               this.oldChannels.push(this.channel);
            }
            this.channel = this.sound.play(startTime,loops);
         }
         else
         {
            if(this.channel)
            {
               this.stopChannel(this.channel);
            }
            this.channel = this.sound.play(startTime,loops);
         }
         if(this.channel)
         {
            this.channel.addEventListener(Event.SOUND_COMPLETE,this.onSoundComplete);
            this._isPlaying = true;
         }
         this.pauseTime = 0;
         this.volume = volume;
         this.mute = this.mute;
         return this;
      }
      
      public function get fade() : SoundTween
      {
         return this.currentTween;
      }
      
      public function pause() : SoundInstance
      {
         if(!this.channel)
         {
            return this;
         }
         this._isPlaying = false;
         this.pauseTime = this.channel.position;
         this.stopChannel(this.channel);
         this.stopOldChannels();
         return this;
      }
      
      public function resume(forceStart:Boolean = false) : SoundInstance
      {
         if((this.isPaused) || (forceStart))
         {
            this.play(this._volume,this.pauseTime,this.loops,this.allowMultiple);
         }
         return this;
      }
      
      public function stop() : SoundInstance
      {
         this.pauseTime = 0;
         this.stopChannel(this.channel);
         this.channel = null;
         this.stopOldChannels();
         this._isPlaying = false;
         return this;
      }
      
      public function get mute() : Boolean
      {
         return this._muted;
      }
      
      public function set mute(value:Boolean) : void
      {
         this._muted = value;
         if(this.channel)
         {
            this.channel.soundTransform = this._muted?new SoundTransform(0):this.soundTransform;
            this.updateOldChannels();
         }
      }
      
      public function fadeTo(endVolume:Number, duration:Number = 1000, stopAtZero:Boolean = true) : SoundInstance
      {
         this.currentTween = this.manager.addTween(this.type,-1,endVolume,duration,stopAtZero);
         return this;
      }
      
      public function fadeFrom(startVolume:Number, endVolume:Number, duration:Number = 1000, stopAtZero:Boolean = true) : SoundInstance
      {
         this.currentTween = this.manager.addTween(this.type,startVolume,endVolume,duration,stopAtZero);
         return this;
      }
      
      public function get isPlaying() : Boolean
      {
         return this._isPlaying;
      }
      
      public function get mixedVolume() : Number
      {
         return this._volume * this.manager.masterVolume;
      }
      
      public function get isPaused() : Boolean
      {
         return (this.channel && this.sound) && (this.pauseTime > 0) && (this.pauseTime < this.sound.length);
      }
      
      public function get position() : Number
      {
         return this.channel?this.channel.position:0;
      }
      
      public function set position(value:Number) : void
      {
         if(this.channel)
         {
            this.stopChannel(this.channel);
         }
         this.channel = this.sound.play(value,this.loops);
         this.channel.addEventListener(Event.SOUND_COMPLETE,this.onSoundComplete);
      }
      
      public function get volume() : Number
      {
         return this._volume;
      }
      
      public function set volume(value:Number) : void
      {
         if(value < 0)
         {
            var value:Number = 0;
         }
         else if((value > 1) || (isNaN(this.volume)))
         {
            value = 1;
         }
         
         this._volume = value;
         this.soundTransform.volume = this.mixedVolume;
         if((!this._muted) && (this.channel))
         {
            this.channel.soundTransform = this.soundTransform;
            this.updateOldChannels();
         }
      }
      
      public function get pan() : Number
      {
         return this._pan;
      }
      
      public function set pan(value:Number) : void
      {
         if(value < -1)
         {
            var value:Number = -1;
         }
         else if((value > 1) || (isNaN(this.volume)))
         {
            value = 1;
         }
         
         this._pan = this.soundTransform.pan = value;
         if((!this._muted) && (this.channel))
         {
            this.channel.soundTransform = this.soundTransform;
            this.updateOldChannels();
         }
      }
      
      public function get masterVolume() : Number
      {
         return this.manager.masterVolume;
      }
      
      public function set masterVolume(value:Number) : void
      {
         this.manager.masterVolume = value;
      }
      
      public function clone() : SoundInstance
      {
         var si:SoundInstance = new SoundInstance(this.manager,this.sound,this.type);
         return si;
      }
      
      public function destroy() : void
      {
         this.soundCompleted.removeAll();
         try
         {
            this.sound.close();
         }
         catch(e:Error)
         {
         }
         this.sound = null;
         this._soundTransform = null;
         this.stopChannel(this.channel);
         this.channel = null;
         this.fade.end(false);
      }
      
      protected function onSoundComplete(event:Event) : void
      {
         var channel:SoundChannel = event.target as SoundChannel;
         channel.removeEventListener(Event.SOUND_COMPLETE,this.onSoundComplete);
         if(channel == this.channel)
         {
            this.channel = null;
            this.pauseTime = 0;
            if(this._enableSeamlessLoops == false)
            {
               if(this.loops == -1)
               {
                  this.play(this._volume,0,-1,this.allowMultiple);
               }
               else if(this._loopsRemaining--)
               {
                  this.play(this._volume,0,this._loopsRemaining,this.allowMultiple);
               }
               else
               {
                  this._isPlaying = false;
                  this.soundCompleted.dispatch(this);
               }
               
            }
            else
            {
               this.soundCompleted.dispatch(this);
            }
         }
         var i:int = this.oldChannels.length;
         while(i--)
         {
            if(channel.position == this.sound.length)
            {
               this.stopChannel(channel);
               this.oldChannels.splice(i,1);
            }
         }
      }
      
      public function get loopsRemaining() : int
      {
         return this._loopsRemaining;
      }
      
      protected function stopChannel(channel:SoundChannel) : void
      {
         if(!channel)
         {
            return;
         }
         channel.removeEventListener(Event.SOUND_COMPLETE,this.onSoundComplete);
         try
         {
            channel.stop();
         }
         catch(e:Error)
         {
         }
      }
      
      protected function stopOldChannels() : void
      {
         if(!this.oldChannels.length)
         {
            return;
         }
         var i:int = this.oldChannels.length;
         while(i--)
         {
            this.stopChannel(this.oldChannels[i]);
         }
         this.oldChannels.length = 0;
      }
      
      protected function updateOldChannels() : void
      {
         if(!this.channel)
         {
            return;
         }
         var i:int = this.oldChannels.length;
         while(i--)
         {
            this.oldChannels[i].soundTransform = this.channel.soundTransform;
         }
      }
      
      public function get soundTransform() : SoundTransform
      {
         if(!this._soundTransform)
         {
            this._soundTransform = new SoundTransform(this.mixedVolume,this._pan);
         }
         return this._soundTransform;
      }
      
      public function set soundTransform(value:SoundTransform) : void
      {
         if(value.volume > 0)
         {
            this._muted = false;
         }
         else if(value.volume == 0)
         {
            this._muted = true;
         }
         
         this.channel.soundTransform = value;
         this.updateOldChannels();
      }
   }
}
