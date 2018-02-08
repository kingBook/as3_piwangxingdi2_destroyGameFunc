package framework.objs
{
   import framework.namespaces.frameworkInternal;
   import framework.events.FrameworkEvent;
   use namespace frameworkInternal;
   public class Controller extends Member
   {
      
      public function Controller()
      {
         super();
      }
      
      protected var _model:Model;
      
      frameworkInternal function setModel(model:Model) : void
      {
         this._model = model;
      }
      
      override frameworkInternal function init() : void
      {
         this.addListeners();
      }
      
      override protected function addListeners() : void
      {
         registerEventListener(this,FrameworkEvent.INITIALIZE_MODEL,this.mInitModel);
      }
      
      private function mInitModel(e:FrameworkEvent) : void
      {
         removeEventListener(FrameworkEvent.INITIALIZE_MODEL,this.mInitModel);
         this.initModelHandler(e);
         dispatchEvent(FrameworkEvent.getInitModelCompleteEvent());
         this.initStatusHandler();
      }
      
      protected function initModelHandler(e:FrameworkEvent) : void
      {
      }
      
      protected function initStatusHandler() : void
      {
      }
      
      override public function destroy() : void
      {
         super.destroy();
         if(this._model != null)
         {
            this._model.destroy();
         }
         _facade.removeController(_id);
         this._model = null;
         _facade = null;
      }
   }
}
