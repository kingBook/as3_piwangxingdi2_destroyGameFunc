package framework.flintparticles.common.counters
{
   import framework.flintparticles.common.emitters.Emitter;
   
   public interface Counter
   {
      
      function startEmitter(param1:Emitter) : uint;
      
      function updateEmitter(param1:Emitter, param2:Number) : uint;
      
      function stop() : void;
      
      function resume() : void;
      
      function get complete() : Boolean;
      
      function get running() : Boolean;
   }
}
