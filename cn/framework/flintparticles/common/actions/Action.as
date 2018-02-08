package framework.flintparticles.common.actions
{
   import framework.flintparticles.common.behaviours.Behaviour;
   import framework.flintparticles.common.emitters.Emitter;
   import framework.flintparticles.common.particles.Particle;
   
   public interface Action extends Behaviour
   {
      
      function update(param1:Emitter, param2:Particle, param3:Number) : void;
   }
}
