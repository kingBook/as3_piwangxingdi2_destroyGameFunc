package framework.flintparticles.common.behaviours
{
   import framework.flintparticles.common.emitters.Emitter;
   
   public interface Behaviour
   {
      
      function get priority() : int;
      
      function set priority(param1:int) : void;
      
      function addedToEmitter(param1:Emitter) : void;
      
      function removedFromEmitter(param1:Emitter) : void;
   }
}
