package framework.objs
{
   import framework.namespaces.frameworkInternal;
   import flash.display.DisplayObject;
   import framework.events.FrameworkEvent;
   use namespace frameworkInternal;
   public class View extends Member
   {
      
      public function View()
      {
         super();
      }
      
      protected var _model:Model;
      
      frameworkInternal function setModel(model:Model) : void
      {
         this._model = model;
      }
      
      protected var _controller:Controller;
      
      frameworkInternal function setController(controller:Controller) : void
      {
         this._controller = controller;
      }
      
      protected var _viewComponent:DisplayObject;
      
      frameworkInternal function setViewComponent(viewComponent:DisplayObject) : void
      {
         this._viewComponent = viewComponent;
      }
      
      override frameworkInternal function init() : void
      {
         this.addListeners();
      }
      
      override protected function addListeners() : void
      {
         if(this._controller != null)
         {
            registerEventListener(this._controller,FrameworkEvent.INITIALIZE_MODEL_COMPLETE,this.mInitModelComplete);
            registerEventListener(this._controller,FrameworkEvent.DESTROY_VIEW,this.mDestroyView);
         }
      }
      
      private function mDestroyView(e:FrameworkEvent) : void
      {
         this.destroy();
      }
      
      private function mInitModelComplete(e:FrameworkEvent) : void
      {
         if(this._controller != null)
         {
            this._controller.removeEventListener(FrameworkEvent.INITIALIZE_MODEL_COMPLETE,this.mInitModelComplete);
         }
         this.initModelComplete();
      }
      
      protected function initModelComplete() : void
      {
      }
      
      protected function show() : void
      {
      }
      
      override public function destroy() : void
      {
         super.destroy();
         if(this._controller != null)
         {
            this._controller.destroy();
         }
         _facade.removeView(_id);
         if(this._viewComponent != null)
         {
            if(this._viewComponent.parent != null)
            {
               this._viewComponent.parent.removeChild(this._viewComponent);
            }
            this._viewComponent = null;
         }
         this._controller = null;
         this._model = null;
         _facade = null;
      }
   }
}
