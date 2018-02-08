package framework.objs
{
   import framework.events.EventRegister;
   import framework.namespaces.frameworkInternal;
   import framework.events.FrameworkEvent;
   use namespace frameworkInternal;
   public class Member extends EventRegister
   {
      
      public function Member()
      {
         super();
      }
      
      protected var _id:int = -1;
      
      public function setId(value:int) : void
      {
         this._id = value;
      }
      
      frameworkInternal function init() : void
      {
      }
      
      frameworkInternal function addDestroyAllListener() : void
      {
         _facade.addEventListener(FrameworkEvent.DESTROY_ALL,this.mDestroy);
      }
      
      private function mDestroy(e:FrameworkEvent) : void
      {
         this.destroy();
      }
      
      protected function addListeners() : void
      {
      }
      
      override public function destroy() : void
      {
         super.destroy();
         _facade.removeEventListener(FrameworkEvent.DESTROY_ALL,this.mDestroy);
      }
   }
}
