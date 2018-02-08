package framework.flintparticles.common.emitters
{
   import flash.events.EventDispatcher;
   import framework.flintparticles.common.particles.ParticleFactory;
   import framework.flintparticles.common.initializers.Initializer;
   import framework.flintparticles.common.actions.Action;
   import framework.flintparticles.common.activities.Activity;
   import framework.flintparticles.common.counters.Counter;
   import framework.flintparticles.common.utils.FrameUpdater;
   import framework.flintparticles.common.events.UpdateEvent;
   import framework.flintparticles.common.particles.Particle;
   import framework.flintparticles.common.events.ParticleEvent;
   import framework.flintparticles.common.events.EmitterEvent;
   import framework.flintparticles.common.behaviours.Behaviour;
   import framework.flintparticles.common.counters.ZeroCounter;
   
   public class Emitter extends EventDispatcher
   {
      
      public function Emitter()
      {
         super();
         this._particles = [];
         this._actions = new Vector.<Action>();
         this._initializers = new Vector.<Initializer>();
         this._activities = new Vector.<Activity>();
         this._counter = new ZeroCounter();
      }
      
      protected var _particleFactory:ParticleFactory;
      
      protected var _initializers:Vector.<Initializer>;
      
      protected var _actions:Vector.<Action>;
      
      protected var _activities:Vector.<Activity>;
      
      protected var _particles:Array;
      
      protected var _counter:Counter;
      
      protected var _useInternalTick:Boolean = true;
      
      protected var _fixedFrameTime:Number = 0;
      
      protected var _running:Boolean = false;
      
      protected var _started:Boolean = false;
      
      protected var _updating:Boolean = false;
      
      protected var _maximumFrameTime:Number = 0.1;
      
      protected var _dispatchCounterComplete:Boolean = false;
      
      protected var _processLastFirst:Boolean = false;
      
      public function get maximumFrameTime() : Number
      {
         return this._maximumFrameTime;
      }
      
      public function set maximumFrameTime(value:Number) : void
      {
         this._maximumFrameTime = value;
      }
      
      public function get initializers() : Vector.<Initializer>
      {
         return this._initializers;
      }
      
      public function set initializers(value:Vector.<Initializer>) : void
      {
         var initializer:Initializer = null;
         for each(initializer in this._initializers)
         {
            initializer.removedFromEmitter(this);
         }
         this._initializers = value.slice();
         this._initializers.sort(this.prioritySort);
         for each(initializer in value)
         {
            initializer.addedToEmitter(this);
         }
      }
      
      public function addInitializer(initializer:Initializer) : void
      {
         var len:uint = this._initializers.length;
         var i:uint = 0;
         while(i < len)
         {
            if(this._initializers[i].priority < initializer.priority)
            {
               break;
            }
            i++;
         }
         this._initializers.splice(i,0,initializer);
         initializer.addedToEmitter(this);
      }
      
      public function removeInitializer(initializer:Initializer) : void
      {
         var index:int = this._initializers.indexOf(initializer);
         if(index != -1)
         {
            this._initializers.splice(index,1);
            initializer.removedFromEmitter(this);
         }
      }
      
      public function hasInitializer(initializer:Initializer) : Boolean
      {
         return !(this._initializers.indexOf(initializer) == -1);
      }
      
      public function hasInitializerOfType(initializerClass:Class) : Boolean
      {
         var len:uint = this._initializers.length;
         var i:uint = 0;
         while(i < len)
         {
            if(this._initializers[i] is initializerClass)
            {
               return true;
            }
            i++;
         }
         return false;
      }
      
      public function get actions() : Vector.<Action>
      {
         return this._actions;
      }
      
      public function set actions(value:Vector.<Action>) : void
      {
         var action:Action = null;
         for each(action in this._actions)
         {
            action.removedFromEmitter(this);
         }
         this._actions = value.slice();
         this._actions.sort(this.prioritySort);
         for each(action in value)
         {
            action.addedToEmitter(this);
         }
      }
      
      public function addAction(action:Action) : void
      {
         var len:uint = this._actions.length;
         var i:uint = 0;
         while(i < len)
         {
            if(this._actions[i].priority < action.priority)
            {
               break;
            }
            i++;
         }
         this._actions.splice(i,0,action);
         action.addedToEmitter(this);
      }
      
      public function removeAction(action:Action) : void
      {
         var index:int = this._actions.indexOf(action);
         if(index != -1)
         {
            this._actions.splice(index,1);
            action.removedFromEmitter(this);
         }
      }
      
      public function hasAction(action:Action) : Boolean
      {
         return !(this._actions.indexOf(action) == -1);
      }
      
      public function hasActionOfType(actionClass:Class) : Boolean
      {
         var len:uint = this._actions.length;
         var i:uint = 0;
         while(i < len)
         {
            if(this._actions[i] is actionClass)
            {
               return true;
            }
            i++;
         }
         return false;
      }
      
      public function get activities() : Vector.<Activity>
      {
         return this._activities;
      }
      
      public function set activities(value:Vector.<Activity>) : void
      {
         var activity:Activity = null;
         for each(activity in this._activities)
         {
            activity.removedFromEmitter(this);
         }
         this._activities = value.slice();
         this._activities.sort(this.prioritySort);
         for each(activity in this._activities)
         {
            activity.addedToEmitter(this);
         }
      }
      
      public function addActivity(activity:Activity) : void
      {
         var len:uint = this._activities.length;
         var i:uint = 0;
         while(i < len)
         {
            if(this._activities[i].priority < activity.priority)
            {
               break;
            }
            i++;
         }
         this._activities.splice(i,0,activity);
         activity.addedToEmitter(this);
      }
      
      public function removeActivity(activity:Activity) : void
      {
         var index:int = this._activities.indexOf(activity);
         if(index != -1)
         {
            this._activities.splice(index,1);
            activity.removedFromEmitter(this);
         }
      }
      
      public function hasActivity(activity:Activity) : Boolean
      {
         return !(this._activities.indexOf(activity) == -1);
      }
      
      public function hasActivityOfType(activityClass:Class) : Boolean
      {
         var len:uint = this._activities.length;
         var i:uint = 0;
         while(i < len)
         {
            if(this._activities[i] is activityClass)
            {
               return true;
            }
            i++;
         }
         return false;
      }
      
      public function get counter() : Counter
      {
         return this._counter;
      }
      
      public function set counter(value:Counter) : void
      {
         this._counter = value;
         if(this.running)
         {
            this._counter.startEmitter(this);
         }
      }
      
      public function dispatchCounterComplete() : void
      {
         this._dispatchCounterComplete = true;
      }
      
      public function get useInternalTick() : Boolean
      {
         return this._useInternalTick;
      }
      
      public function set useInternalTick(value:Boolean) : void
      {
         if(this._useInternalTick != value)
         {
            this._useInternalTick = value;
            if(this._started)
            {
               if(this._useInternalTick)
               {
                  FrameUpdater.instance.addEventListener(UpdateEvent.UPDATE,this.updateEventListener,false,0,true);
               }
               else
               {
                  FrameUpdater.instance.removeEventListener(UpdateEvent.UPDATE,this.updateEventListener);
               }
            }
         }
      }
      
      public function get fixedFrameTime() : Number
      {
         return this._fixedFrameTime;
      }
      
      public function set fixedFrameTime(value:Number) : void
      {
         this._fixedFrameTime = value;
      }
      
      public function get running() : Boolean
      {
         return this._running;
      }
      
      public function get particleFactory() : ParticleFactory
      {
         return this._particleFactory;
      }
      
      public function set particleFactory(value:ParticleFactory) : void
      {
         this._particleFactory = value;
      }
      
      public function get particles() : Vector.<Particle>
      {
         return Vector.<Particle>(this._particles);
      }
      
      public function set particles(value:Vector.<Particle>) : void
      {
         this.killAllParticles();
         this.addParticles(value,false);
      }
      
      public function get particlesArray() : Array
      {
         return this._particles;
      }
      
      protected function createParticle() : Particle
      {
         var particle:Particle = this._particleFactory.createParticle();
         var len:int = this._initializers.length;
         this.initParticle(particle);
         var i:int = 0;
         while(i < len)
         {
            Initializer(this._initializers[i]).initialize(this,particle);
            i++;
         }
         this._particles.push(particle);
         if(hasEventListener(ParticleEvent.PARTICLE_CREATED))
         {
            dispatchEvent(new ParticleEvent(ParticleEvent.PARTICLE_CREATED,particle));
         }
         return particle;
      }
      
      protected function initParticle(particle:Particle) : void
      {
      }
      
      public function addParticle(particle:Particle, applyInitializers:Boolean = false) : void
      {
         var len:* = 0;
         var i:* = 0;
         if(applyInitializers)
         {
            len = this._initializers.length;
            i = 0;
            while(i < len)
            {
               this._initializers[i].initialize(this,particle);
               i++;
            }
         }
         this._particles.push(particle);
         if(hasEventListener(ParticleEvent.PARTICLE_ADDED))
         {
            dispatchEvent(new ParticleEvent(ParticleEvent.PARTICLE_ADDED,particle));
         }
      }
      
      public function addParticles(particles:Vector.<Particle>, applyInitializers:Boolean = false) : void
      {
         var i:* = 0;
         var len2:* = 0;
         var j:* = 0;
         var len:int = particles.length;
         if(applyInitializers)
         {
            len2 = this._initializers.length;
            j = 0;
            while(j < len2)
            {
               i = 0;
               while(i < len)
               {
                  this._initializers[j].initialize(this,particles[i]);
                  i++;
               }
               j++;
            }
         }
         if(hasEventListener(ParticleEvent.PARTICLE_ADDED))
         {
            i = 0;
            while(i < len)
            {
               this._particles.push(particles[i]);
               dispatchEvent(new ParticleEvent(ParticleEvent.PARTICLE_ADDED,particles[i]));
               i++;
            }
         }
         else
         {
            i = 0;
            while(i < len)
            {
               this._particles.push(particles[i]);
               i++;
            }
         }
      }
      
      public function removeParticle(particle:Particle) : Boolean
      {
         var index:int = this._particles.indexOf(particle);
         if(index != -1)
         {
            if(this._updating)
            {
               addEventListener(EmitterEvent.EMITTER_UPDATED,function(e:EmitterEvent):void
               {
                  removeEventListener(EmitterEvent.EMITTER_UPDATED,arguments.callee);
                  removeParticle(particle);
               });
            }
            else
            {
               this._particles.splice(index,1);
               dispatchEvent(new ParticleEvent(ParticleEvent.PARTICLE_REMOVED,particle));
            }
            return true;
         }
         return false;
      }
      
      public function removeParticles(particles:Vector.<Particle>) : void
      {
         var i:int = 0;
         var len:int = 0;
         var index:int = 0;
         if(this._updating)
         {
            addEventListener(EmitterEvent.EMITTER_UPDATED,function(e:EmitterEvent):void
            {
               removeEventListener(EmitterEvent.EMITTER_UPDATED,arguments.callee);
               removeParticles(particles);
            });
         }
         else
         {
            i = 0;
            len = particles.length;
            while(i < len)
            {
               index = this._particles.indexOf(particles[i]);
               if(index != -1)
               {
                  this._particles.splice(index,1);
                  dispatchEvent(new ParticleEvent(ParticleEvent.PARTICLE_REMOVED,particles[i]));
               }
               i++;
            }
         }
      }
      
      public function killAllParticles() : void
      {
         var i:* = 0;
         var len:int = this._particles.length;
         if(hasEventListener(ParticleEvent.PARTICLE_DEAD))
         {
            i = 0;
            while(i < len)
            {
               dispatchEvent(new ParticleEvent(ParticleEvent.PARTICLE_DEAD,this._particles[i]));
               this._particleFactory.disposeParticle(this._particles[i]);
               i++;
            }
         }
         else
         {
            i = 0;
            while(i < len)
            {
               this._particleFactory.disposeParticle(this._particles[i]);
               i++;
            }
         }
         this._particles.length = 0;
      }
      
      public function start() : void
      {
         if(this._useInternalTick)
         {
            FrameUpdater.instance.addEventListener(UpdateEvent.UPDATE,this.updateEventListener,false,0,true);
         }
         this._started = true;
         this._running = true;
         var len:int = this._activities.length;
         var i:int = 0;
         while(i < len)
         {
            Activity(this._activities[i]).initialize(this);
            i++;
         }
         len = this._counter.startEmitter(this);
         i = 0;
         while(i < len)
         {
            this.createParticle();
            i++;
         }
      }
      
      private function updateEventListener(ev:UpdateEvent) : void
      {
         if(this._fixedFrameTime)
         {
            this.update(this._fixedFrameTime);
         }
         else
         {
            this.update(ev.time);
         }
      }
      
      public function update(time:Number) : void
      {
         var i:* = 0;
         var particle:Particle = null;
         var action:Action = null;
         var len2:* = 0;
         var j:* = 0;
         if(!this._running)
         {
            return;
         }
         if(time > this._maximumFrameTime)
         {
            var time:Number = this._maximumFrameTime;
         }
         this._updating = true;
         var len:int = this._counter.updateEmitter(this,time);
         i = 0;
         while(i < len)
         {
            this.createParticle();
            i++;
         }
         this.sortParticles();
         len = this._activities.length;
         i = 0;
         while(i < len)
         {
            Activity(this._activities[i]).update(this,time);
            i++;
         }
         if(this._particles.length > 0)
         {
            len = this._actions.length;
            len2 = this._particles.length;
            if(this._processLastFirst)
            {
               j = 0;
               while(j < len)
               {
                  action = this._actions[j];
                  i = len2 - 1;
                  while(i >= 0)
                  {
                     particle = this._particles[i];
                     action.update(this,particle,time);
                     i--;
                  }
                  j++;
               }
            }
            else
            {
               j = 0;
               while(j < len)
               {
                  action = this._actions[j];
                  i = 0;
                  while(i < len2)
                  {
                     particle = this._particles[i];
                     action.update(this,particle,time);
                     i++;
                  }
                  j++;
               }
            }
            this._processLastFirst = !this._processLastFirst;
            if(hasEventListener(ParticleEvent.PARTICLE_DEAD))
            {
               i = len2;
               while(i--)
               {
                  particle = this._particles[i];
                  if(particle.isDead)
                  {
                     this._particles.splice(i,1);
                     dispatchEvent(new ParticleEvent(ParticleEvent.PARTICLE_DEAD,particle));
                     if(particle.isDead)
                     {
                        this._particleFactory.disposeParticle(particle);
                     }
                  }
               }
            }
            else
            {
               i = len2;
               while(i--)
               {
                  particle = this._particles[i];
                  if(particle.isDead)
                  {
                     this._particles.splice(i,1);
                     this._particleFactory.disposeParticle(particle);
                  }
               }
            }
         }
         else if(hasEventListener(EmitterEvent.EMITTER_EMPTY))
         {
            dispatchEvent(new EmitterEvent(EmitterEvent.EMITTER_EMPTY));
         }
         
         this._updating = false;
         if(hasEventListener(EmitterEvent.EMITTER_UPDATED))
         {
            dispatchEvent(new EmitterEvent(EmitterEvent.EMITTER_UPDATED));
         }
         if(this._dispatchCounterComplete)
         {
            this._dispatchCounterComplete = false;
            if(hasEventListener(EmitterEvent.COUNTER_COMPLETE))
            {
               dispatchEvent(new EmitterEvent(EmitterEvent.COUNTER_COMPLETE));
            }
         }
      }
      
      protected function sortParticles() : void
      {
      }
      
      public function pause() : void
      {
         this._running = false;
      }
      
      public function resume() : void
      {
         this._running = true;
      }
      
      public function stop() : void
      {
         if(this._useInternalTick)
         {
            FrameUpdater.instance.removeEventListener(UpdateEvent.UPDATE,this.updateEventListener);
         }
         this._started = false;
         this._running = false;
         this.killAllParticles();
      }
      
      public function runAhead(time:Number, frameRate:Number = 10) : void
      {
         var maxTime:Number = this._maximumFrameTime;
         var step:Number = 1 / frameRate;
         this._maximumFrameTime = step;
         while(time > 0)
         {
            var time:Number = time - step;
            this.update(step);
         }
         this._maximumFrameTime = maxTime;
      }
      
      private function prioritySort(b1:Behaviour, b2:Behaviour) : Number
      {
         return b1.priority - b2.priority;
      }
   }
}
