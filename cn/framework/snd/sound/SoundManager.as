package framework.snd.sound
{
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   import flash.display.Sprite;
   import framework.snd.signals.Signal;
   import flash.media.SoundTransform;
   import flash.utils.getDefinitionByName;
   import flash.media.Sound;
   import flash.net.URLRequest;
   import flash.media.SoundLoaderContext;
   import flash.events.IOErrorEvent;
   import flash.events.Event;
   import flash.utils.getTimer;
   import flash.events.ProgressEvent;
   import framework.namespaces.frameworkInternal;
   use namespace frameworkInternal;
   
   public class SoundManager extends EventDispatcher
   {
      
      public function SoundManager()
      {
         super();
         this.init();
      }
      
      protected var instances:Vector.<SoundInstance>;
      
      protected var instancesBySound:Dictionary;
      
      protected var instancesByType:Object;
      
      protected var groupsByName:Object;
      
      public var groups:Vector.<SoundManager>;
      
      protected var activeTweens:Vector.<SoundTween>;
      
      protected var ticker:Sprite;
      
      protected var _tickEnabled:Boolean;
      
      protected var _mute:Boolean;
      
      protected var _volume:Number;
      
      protected var _pan:Number;
      
      protected var _masterVolume:Number;
      
      protected var _masterTween:SoundTween;
      
      private var _searching:Boolean;
      
      public var loadCompleted:Signal;
      
      public var loadFailed:Signal;
      
      public var parent:SoundManager;
	  
	  
	  frameworkInternal function onDestroy():void{
		  if(instances){
			  var i:int=instances.length;
			  while (--i>=0){
				  var si:SoundInstance=instances[i];
				  if(si){
					  si.stop();
					  si.destroy();
				  }
			  }
			  instances=null;
		  }
		  instancesBySound=null;
		  instancesByType=null;
		  groupsByName=null;
		  groups=null;
		  activeTweens=null;
		  ticker=null;
		  _masterTween=null;
		  loadCompleted=null;
		  loadFailed=null;
		  parent=null;
	  }
      
      public function play(type:String, volume:Number = 1, startTime:Number = 0, loops:int = 0, allowMultiple:Boolean = false, allowInterrupt:Boolean = true, enableSeamlessLoops:Boolean = false) : SoundInstance
      {
         var si:SoundInstance = this.getSound(type);
         if(this.instances.indexOf(si) == -1)
         {
         }
         if((!allowInterrupt) && (si.isPlaying))
         {
            si.volume = volume;
         }
         else
         {
            si.play(volume,startTime,loops,allowMultiple,enableSeamlessLoops);
         }
         return si;
      }
      
      public function isPlaying(type:String) : Boolean
      {
         var si:SoundInstance = this.getSound(type);
         if(si)
         {
            return si.isPlaying;
         }
         return false;
      }
      
      public function playLoop(type:String, volume:Number = 1, startTime:Number = 0, enableSeamlessLoops:Boolean = true) : SoundInstance
      {
         return this.play(type,volume,startTime,-1,false,true,enableSeamlessLoops);
      }
      
      public function playFx(type:String, volume:Number = 1, startTime:Number = 0, loops:int = 0) : SoundInstance
      {
         return this.play(type,volume,startTime,0,true);
      }
      
      public function stopAll() : void
      {
         var i:int = this.instances.length;
         while(i--)
         {
            this.instances[i].stop();
         }
      }
      
      public function resume(type:String) : SoundInstance
      {
         return this.getSound(type).resume();
      }
      
      public function resumeAll() : void
      {
         var i:int = this.instances.length;
         while(i--)
         {
            this.instances[i].resume();
         }
      }
      
      public function pause(type:String) : SoundInstance
      {
         return this.getSound(type).pause();
      }
      
      public function pauseAll() : void
      {
         var i:int = this.instances.length;
         while(i--)
         {
            this.instances[i].pause();
         }
      }
      
      public function fadeTo(type:String, endVolume:Number = 1, duration:Number = 1000, stopAtZero:Boolean = true) : SoundInstance
      {
         return this.getSound(type).fadeTo(endVolume,duration,stopAtZero);
      }
      
      public function fadeAllTo(endVolume:Number = 1, duration:Number = 1000, stopAtZero:Boolean = true) : void
      {
         var i:int = this.instances.length;
         while(i--)
         {
            this.instances[i].fadeTo(endVolume,duration,stopAtZero);
         }
      }
      
      public function fadeMasterTo(endVolume:Number = 1, duration:Number = 1000, stopAtZero:Boolean = true) : void
      {
         this.addMasterTween(this._masterVolume,endVolume,duration,stopAtZero);
      }
      
      public function fadeFrom(type:String, startVolume:Number = 0, endVolume:Number = 1, duration:Number = 1000, stopAtZero:Boolean = true) : SoundInstance
      {
         return this.getSound(type).fadeFrom(startVolume,endVolume,duration,stopAtZero);
      }
      
      public function fadeAllFrom(startVolume:Number = 0, endVolume:Number = 1, duration:Number = 1000, stopAtZero:Boolean = true) : void
      {
         var i:int = this.instances.length;
         while(i--)
         {
            this.instances[i].fadeFrom(startVolume,endVolume,duration,stopAtZero);
         }
      }
      
      public function fadeMasterFrom(startVolume:Number = 0, endVolume:Number = 1, duration:Number = 1000, stopAtZero:Boolean = true) : void
      {
         this.addMasterTween(startVolume,endVolume,duration,stopAtZero);
      }
      
      public function get mute() : Boolean
      {
         return this._mute;
      }
      
      public function set mute(value:Boolean) : void
      {
         this._mute = value;
         var i:int = this.instances.length;
         while(i--)
         {
            this.instances[i].mute = this._mute;
         }
         dispatchEvent(SoundAsEvent.getMuteEvent());
      }
      
      public function get volume() : Number
      {
         return this._volume;
      }
      
      public function set volume(value:Number) : void
      {
         this._volume = value;
         var i:int = this.instances.length;
         while(i--)
         {
            this.instances[i].volume = this._volume;
         }
      }
      
      public function get pan() : Number
      {
         return this._pan;
      }
      
      public function set pan(value:Number) : void
      {
         this._pan = value;
         var i:int = this.instances.length;
         while(i--)
         {
            this.instances[i].pan = this._pan;
         }
      }
      
      public function set soundTransform(value:SoundTransform) : void
      {
         var i:int = this.instances.length;
         while(i--)
         {
            this.instances[i].soundTransform = value;
         }
      }
      
      public function getSound(type:String, forceNew:Boolean = false) : SoundInstance
      {
         var si:SoundInstance = null;
         var $C:Class = null;
         var i:int = 0;
         if(this._searching)
         {
            return null;
         }
         this._searching = true;
         if(type != null)
         {
            si = this.instancesByType[type];
            if(!si)
            {
               if((!si) && (this.parent))
               {
                  si = this.parent.getSound(type);
               }
               if((!si) && (this.groups))
               {
                  i = this.groups.length;
                  while(i--)
                  {
                     si = this.groups[i].getSound(type);
                     if(si)
                     {
                        break;
                     }
                  }
               }
               if((si) && (this.instances.indexOf(si) == -1))
               {
                  this.addInstance(si);
               }
               $C = getDefinitionByName(type) as Class;
               if(!si)
               {
                  this.addSound(type,new $C());
                  si = this.instancesByType[type];
               }
            }
            if(!si)
            {
               throw new Error("[SoundAS] Sound with type \'" + type + "\' does not appear to be loaded.");
            }
            else if(forceNew)
            {
               si = si.clone();
            }
		 }
            this._searching = false;
            return si;
      }
      
      public function loadSound(url:String, type:String, buffer:int = 100) : void
      {
         var si:SoundInstance = this.instancesByType[type];
         if((si) && (si.url == url))
         {
            return;
         }
         si = new SoundInstance(this,null,type);
         si.url = url;
         si.sound = new Sound(new URLRequest(url),new SoundLoaderContext(buffer,false));
         si.sound.addEventListener(IOErrorEvent.IO_ERROR,this.onSoundLoadError,false,0,true);
         si.sound.addEventListener(Event.COMPLETE,this.onSoundLoadComplete,false,0,true);
         this.addInstance(si);
      }
      
      public function addSound(type:String, sound:Sound) : void
      {
         var si:SoundInstance = null;
         if(this.instancesByType[type])
         {
            si = this.instancesByType[type];
            si.sound = sound;
         }
         else
         {
            si = new SoundInstance(this,sound,type);
         }
         this.addInstance(si);
      }
      
      public function removeSound(type:String) : void
      {
         if(this.instancesByType[type] == null)
         {
            return;
         }
         var i:int = this.instances.length;
         while(i--)
         {
            if(this.instances[i].type == type)
            {
               this.instancesBySound[this.instances[i].sound] = null;
               this.instances[i].destroy();
               this.instances.splice(i,1);
            }
         }
         this.instancesByType[type] = null;
      }
      
      public function removeAll() : void
      {
         var i:int = this.instances.length;
         while(i--)
         {
            this.instances[i].destroy();
         }
         if(this.groups)
         {
            i = this.groups.length;
            while(i--)
            {
               this.groups[i].removeAll();
            }
            this.groups.length = 0;
         }
         this.init();
      }
      
      public function get masterVolume() : Number
      {
         return this._masterVolume;
      }
      
      public function set masterVolume(value:Number) : void
      {
         var sound:SoundInstance = null;
         this._masterVolume = value;
         var i:int = this.instances.length;
         while(i--)
         {
            sound = this.instances[i];
            sound.volume = sound.volume;
         }
      }
      
      public function group(name:String) : SoundManager
      {
         if(!this.groupsByName[name])
         {
            this.groupsByName[name] = new SoundManager();
            (this.groupsByName[name] as SoundManager).parent = this;
            if(!this.groups)
            {
               this.groups = new Vector.<SoundManager>(0);
            }
            this.groups.push(this.groupsByName[name]);
         }
         return this.groupsByName[name];
      }
      
      protected function init() : void
      {
         if(!this.loadCompleted)
         {
            this.loadCompleted = new Signal(SoundInstance);
         }
         if(!this.loadFailed)
         {
            this.loadFailed = new Signal(SoundInstance);
         }
         this._volume = 1;
         this._pan = 0;
         this._masterVolume = 1;
         this.instances = new Vector.<SoundInstance>(0);
         this.instancesBySound = new Dictionary(true);
         this.instancesByType = {};
         this.groupsByName = {};
         this.activeTweens = new Vector.<SoundTween>();
      }
      
      public function addMasterTween(startVolume:Number, endVolume:Number, duration:Number, stopAtZero:Boolean) : void
      {
         if(!this._masterTween)
         {
            this._masterTween = new SoundTween(this,null,0,0,true);
         }
         this._masterTween.init(startVolume,endVolume,duration);
         this._masterTween.stopAtZero = stopAtZero;
         this._masterTween.update(0);
         if(this.activeTweens.indexOf(this._masterTween) == -1)
         {
            this.activeTweens.push(this._masterTween);
         }
         this.tickEnabled = true;
      }
      
      public  function addTween(type:String, startVolume:Number, endVolume:Number, duration:Number, stopAtZero:Boolean) : SoundTween
      {
         var si:SoundInstance = this.getSound(type);
         if(startVolume >= 0)
         {
            si.volume = startVolume;
         }
         if(si.fade)
         {
            si.fade.kill();
         }
         var tween:SoundTween = new SoundTween(this,si,endVolume,duration);
         tween.stopAtZero = stopAtZero;
         tween.update(tween.startTime);
         this.activeTweens.push(tween);
         this.tickEnabled = true;
         return tween;
      }
      
      protected function onTick(event:Event) : void
      {
         var t:int = getTimer();
         var i:int = this.activeTweens.length;
         while(i--)
         {
            if(this.activeTweens[i].update(t))
            {
               this.activeTweens[i].end();
               this.activeTweens.splice(i,1);
            }
         }
         this.tickEnabled = this.activeTweens.length > 0;
      }
      
      protected function addInstance(si:SoundInstance) : void
      {
         si.mute = this._mute;
         si.manager = this;
         if(this.instances.indexOf(si) == -1)
         {
            this.instances.push(si);
         }
         this.instancesBySound[si.sound] = si;
         this.instancesByType[si.type] = si;
      }
      
      protected function onSoundLoadComplete(event:Event) : void
      {
         var sound:Sound = event.target as Sound;
         this.loadCompleted.dispatch(this.instancesBySound[sound]);
      }
      
      protected function onSoundLoadProgress(event:ProgressEvent) : void
      {
      }
      
      protected function onSoundLoadError(event:IOErrorEvent) : void
      {
         var sound:SoundInstance = this.instancesBySound[event.target as Sound];
         this.loadFailed.dispatch(sound);
         trace("[SoundAS] ERROR: Failed Loading Sound \'" + sound.type + "\' @ " + sound.url);
      }
      
      protected function get tickEnabled() : Boolean
      {
         return this._tickEnabled;
      }
      
      protected function set tickEnabled(value:Boolean) : void
      {
         if(value == this._tickEnabled)
         {
            return;
         }
         this._tickEnabled = value;
         if(this._tickEnabled)
         {
            if(!this.ticker)
            {
               this.ticker = new Sprite();
            }
            this.ticker.addEventListener(Event.ENTER_FRAME,this.onTick);
         }
         else
         {
            this.ticker.removeEventListener(Event.ENTER_FRAME,this.onTick);
         }
      }
   }
}
