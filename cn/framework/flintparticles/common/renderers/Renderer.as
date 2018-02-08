package framework.flintparticles.common.renderers
{
   import framework.flintparticles.common.emitters.Emitter;
   
   public interface Renderer
   {
      
      function addEmitter(param1:Emitter) : void;
      
      function removeEmitter(param1:Emitter) : void;
   }
}
