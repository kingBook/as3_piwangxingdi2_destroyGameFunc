package framework.flintparticles.common.renderers
{
   import flash.display.Sprite;
   import framework.flintparticles.common.emitters.Emitter;
   import framework.flintparticles.common.particles.Particle;
   import framework.flintparticles.common.events.EmitterEvent;
   import framework.flintparticles.common.events.ParticleEvent;
   import flash.events.Event;
   
   public class SpriteRendererBase extends Sprite implements Renderer
   {
      
      public function SpriteRendererBase()
      {
         super();
         this._emitters = new Vector.<Emitter>();
         this._particles = [];
         mouseEnabled = false;
         mouseChildren = false;
         addEventListener(Event.ADDED_TO_STAGE,this.addedToStage,false,0,true);
      }
      
      protected var _emitters:Vector.<Emitter>;
      
      protected var _particles:Array;
      
      public function addEmitter(emitter:Emitter) : void
      {
         var p:Particle = null;
         this._emitters.push(emitter);
         if(stage)
         {
            stage.invalidate();
         }
         emitter.addEventListener(EmitterEvent.EMITTER_UPDATED,this.emitterUpdated,false,0,true);
         emitter.addEventListener(ParticleEvent.PARTICLE_CREATED,this.particleAdded,false,0,true);
         emitter.addEventListener(ParticleEvent.PARTICLE_ADDED,this.particleAdded,false,0,true);
         emitter.addEventListener(ParticleEvent.PARTICLE_DEAD,this.particleRemoved,false,0,true);
         emitter.addEventListener(ParticleEvent.PARTICLE_REMOVED,this.particleRemoved,false,0,true);
         for each(p in emitter.particlesArray)
         {
            this.addParticle(p);
         }
         if(this._emitters.length == 1)
         {
            addEventListener(Event.RENDER,this.updateParticles,false,0,true);
         }
      }
      
      public function removeEmitter(emitter:Emitter) : void
      {
         var p:Particle = null;
         var i:int = 0;
         while(i < this._emitters.length)
         {
            if(this._emitters[i] == emitter)
            {
               this._emitters.splice(i,1);
               emitter.removeEventListener(EmitterEvent.EMITTER_UPDATED,this.emitterUpdated);
               emitter.removeEventListener(ParticleEvent.PARTICLE_CREATED,this.particleAdded);
               emitter.removeEventListener(ParticleEvent.PARTICLE_ADDED,this.particleAdded);
               emitter.removeEventListener(ParticleEvent.PARTICLE_DEAD,this.particleRemoved);
               emitter.removeEventListener(ParticleEvent.PARTICLE_REMOVED,this.particleRemoved);
               for each(p in emitter.particlesArray)
               {
                  this.removeParticle(p);
               }
               if(this._emitters.length == 0)
               {
                  removeEventListener(Event.RENDER,this.updateParticles);
                  this.renderParticles([]);
               }
               else if(stage)
               {
                  stage.invalidate();
               }
               
               return;
            }
            i++;
         }
      }
      
      private function addedToStage(ev:Event) : void
      {
         if(stage)
         {
            stage.invalidate();
         }
      }
      
      private function particleAdded(ev:ParticleEvent) : void
      {
         this.addParticle(ev.particle);
         if(stage)
         {
            stage.invalidate();
         }
      }
      
      private function particleRemoved(ev:ParticleEvent) : void
      {
         this.removeParticle(ev.particle);
         if(stage)
         {
            stage.invalidate();
         }
      }
      
      protected function emitterUpdated(ev:EmitterEvent) : void
      {
         if(stage)
         {
            stage.invalidate();
         }
      }
      
      protected function updateParticles(ev:Event) : void
      {
         this.renderParticles(this._particles);
      }
      
      protected function addParticle(particle:Particle) : void
      {
         this._particles.push(particle);
      }
      
      protected function removeParticle(particle:Particle) : void
      {
         var index:int = this._particles.indexOf(particle);
         if(index != -1)
         {
            this._particles.splice(index,1);
         }
      }
      
      protected function renderParticles(particles:Array) : void
      {
      }
      
      public function get emitters() : Vector.<Emitter>
      {
         return this._emitters;
      }
      
      public function set emitters(value:Vector.<Emitter>) : void
      {
         var e:Emitter = null;
         for each(e in this._emitters)
         {
            this.removeEmitter(e);
         }
         for each(e in value)
         {
            this.addEmitter(e);
         }
      }
   }
}
