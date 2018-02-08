package framework.flintparticles.common.events
{
   import flash.events.Event;
   import framework.flintparticles.common.particles.Particle;
   
   public class ParticleEvent extends Event
   {
      
      public function ParticleEvent(type:String, particle:Particle = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.particle = particle;
      }
      
      public static var PARTICLE_CREATED:String = "particleCreated";
      
      public static var PARTICLE_DEAD:String = "particleDead";
      
      public static var PARTICLE_ADDED:String = "particleAdded";
      
      public static var PARTICLE_REMOVED:String = "particleRemoved";
      
      public static var PARTICLES_COLLISION:String = "particlesCollision";
      
      public static var ZONE_COLLISION:String = "zoneCollision";
      
      public static var BOUNDING_BOX_COLLISION:String = "boundingBoxCollision";
      
      public var particle:Particle;
      
      public var otherObject:*;
      
      override public function clone() : Event
      {
         var e:ParticleEvent = new ParticleEvent(type,this.particle,bubbles,cancelable);
         e.otherObject = this.otherObject;
         return e;
      }
   }
}
