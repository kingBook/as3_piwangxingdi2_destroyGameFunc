package framework.flintparticles.common.activities
{
   import framework.flintparticles.common.behaviours.Behaviour;
   import framework.flintparticles.common.emitters.Emitter;
   
   public interface Activity extends Behaviour
   {
      
      function initialize(param1:Emitter) : void;
      
      function update(param1:Emitter, param2:Number) : void;
   }
}
