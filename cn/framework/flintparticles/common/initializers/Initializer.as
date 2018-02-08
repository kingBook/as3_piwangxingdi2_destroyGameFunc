package framework.flintparticles.common.initializers
{
   import framework.flintparticles.common.behaviours.Behaviour;
   import framework.flintparticles.common.emitters.Emitter;
   import framework.flintparticles.common.particles.Particle;
   
   public interface Initializer extends Behaviour
   {
      
      function initialize(param1:Emitter, param2:Particle) : void;
   }
}
