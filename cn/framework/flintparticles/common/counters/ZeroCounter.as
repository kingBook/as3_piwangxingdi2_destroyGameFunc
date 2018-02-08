package framework.flintparticles.common.counters
{
   import framework.flintparticles.common.emitters.Emitter;
   
   public class ZeroCounter extends Object implements Counter
   {
      
      public function ZeroCounter()
      {
         super();
      }
      
      public function startEmitter(emitter:Emitter) : uint
      {
         return 0;
      }
      
      public function updateEmitter(emitter:Emitter, time:Number) : uint
      {
         return 0;
      }
      
      public function stop() : void
      {
      }
      
      public function resume() : void
      {
      }
      
      public function get complete() : Boolean
      {
         return true;
      }
      
      public function get running() : Boolean
      {
         return false;
      }
   }
}
