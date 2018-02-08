package framework.objs
{
   import framework.GameObjectListProxy;
   import framework.namespaces.frameworkInternal;
   import flash.utils.getQualifiedClassName;
   import flash.utils.getQualifiedSuperclassName;
   import flash.utils.getDefinitionByName;
   import framework.events.FrameworkEvent;
   use namespace frameworkInternal;
   
   public class GameObject extends Member
   {
      
      public function GameObject()
      {
         super();
      }
      
      private var _gameObjectListProxy:GameObjectListProxy;
      
      override frameworkInternal function init() : void
      {
         this.addListeners();
      }
      
      frameworkInternal function addToGameObjectList(gameObjectListProxy:GameObjectListProxy) : void
      {
         var parentClassName:String = null;
         this._gameObjectListProxy = gameObjectListProxy;
         gameObjectListProxy.addGameObject(getQualifiedClassName(this),this);
         var o:* = this;
         var rootClassName:String = getQualifiedClassName(prototype.constructor);
         while(true)
         {
            parentClassName = getQualifiedSuperclassName(o);
            gameObjectListProxy.addGameObject(parentClassName,this);
            if(parentClassName == rootClassName)
            {
               break;
            }
            o = getDefinitionByName(parentClassName);
         }
      }
      
      private function removeFromGameObjectList(gameObjectListProxy:GameObjectListProxy) : void
      {
         var parentClassName:String = null;
         gameObjectListProxy.removeGameObject(getQualifiedClassName(this),this);
         var o:* = this;
         var rootClassName:String = getQualifiedClassName(prototype.constructor);
         while(true)
         {
            parentClassName = getQualifiedSuperclassName(o);
            gameObjectListProxy.removeGameObject(parentClassName,this);
            if(parentClassName == rootClassName)
            {
               break;
            }
            o = getDefinitionByName(parentClassName);
         }
      }
      
      override protected function addListeners() : void
      {
         registerEventListener(this,FrameworkEvent.INITIALIZE_MODEL,this.mInitModel);
      }
      
      private function mInitModel(e:FrameworkEvent) : void
      {
         removeEventListener(FrameworkEvent.INITIALIZE_MODEL,this.mInitModel);
         this.initModelHandler(e);
      }
      
      protected function initModelHandler(e:FrameworkEvent) : void
      {
      }
      
      override public function destroy() : void
      {
         super.destroy();
         if(this._gameObjectListProxy)
         {
            this.removeFromGameObjectList(this._gameObjectListProxy);
            this._gameObjectListProxy = null;
         }
         _facade.removeGameObj(_id);
         _facade = null;
      }
   }
}
