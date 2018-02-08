package framework
{
   import flash.events.EventDispatcher;
   import framework.utils.TweenMax;
   import framework.events.FrameworkEvent;
   import framework.system.Global;
   import flash.events.Event;
   import framework.objs.Model;
   import framework.objs.View;
   import flash.display.DisplayObject;
   import framework.objs.Controller;
   import framework.namespaces.frameworkInternal;
   import framework.objs.GameObject;
   import flash.utils.getQualifiedClassName;
   use namespace frameworkInternal;
   public class Facade extends EventDispatcher
   {
      
      public function Facade()
      {
         super();
         if(_instance != null)
         {
            throw new Error("该类只能实例化一次!!!");
         }
         else
         {
            _instance = this;
            this.init();
            return;
         }
      }
      
      protected static var _instance:Facade;
      
      public static function getInstance() : Facade
      {
         if(_instance == null)
         {
            _instance = new Facade();
         }
         return _instance;
      }
      
      private var _modelList:Array;
      
      private var _viewList:Array;
      
      private var _controllerList:Array;
      
      private var _keyUpdateList:Array;
      
      private var _uiUpdateList:Array;
      
      private var _update1List:Array;
      
      private var _update2List:Array;
      
      private var _update3List:Array;
      
      private var _gameObjList:Array;
      
      private var _gameObjectListProxy:GameObjectListProxy;
      
      private function init() : void
      {
         this._modelList = [];
         this._viewList = [];
         this._controllerList = [];
         this._gameObjList = [];
         this._keyUpdateList = [];
         this._uiUpdateList = [];
         this._update1List = [];
         this._update2List = [];
         this._update3List = [];
         this._gameObjectListProxy = new GameObjectListProxy();
      }
      
      private var _pause:Boolean;
      
      public function set pause(value:Boolean) : void
      {
         if(value == this._pause)
         {
            return;
         }
         this._pause = value;
         if(this._pause)
         {
            TweenMax.pauseAll(true,true);
         }
         else
         {
            TweenMax.resumeAll(true,true);
         }
         var event:FrameworkEvent = this._pause?FrameworkEvent.getPauseEvent():FrameworkEvent.getResumeEvent();
         dispatchEvent(event);
      }
      
      public function get pause() : Boolean
      {
         return this._pause;
      }
      
      protected var _global:Global;
      
      public function get global() : Global
      {
         return this._global;
      }
      
      public function startup(params:* = null) : void
      {
      }
      
      protected function destroyAll() : void
      {
         this._pause = false;
         TweenMax.killAll();
         dispatchEvent(FrameworkEvent.getDestroyAllEvent());
      }
      
      protected function update(e:Event = null) : void
      {
         this.foreachList(this._keyUpdateList);
         this.foreachList(this._uiUpdateList);
         if(this._pause)
         {
            return;
         }
         this.foreachList(this._update1List);
         this.foreachList(this._update2List);
         this.foreachList(this._update3List);
      }
      
      public function addUpdateListener(type:String, listener:Function) : void
      {
         if(listener.length > 0)
         {
            throw new Error("addUpdateListener 侦听函数参数个数必须为0");
         }
         else
         {
            switch(type)
            {
               case UpdateType.KEYBOARD_UPDATE:
                  this.addToList(listener,this._keyUpdateList);
                  break;
               case UpdateType.UI_UPDATE:
                  this.addToList(listener,this._uiUpdateList);
                  break;
               case UpdateType.UPDATE_1:
                  this.addToList(listener,this._update1List);
                  break;
               case UpdateType.UPDATE_2:
                  this.addToList(listener,this._update2List);
                  break;
               case UpdateType.UPDATE_3:
                  this.addToList(listener,this._update3List);
                  break;
            }
            return;
         }
      }
      
      public function removeUpdateListener(type:String, listener:Function) : void
      {
         switch(type)
         {
            case UpdateType.KEYBOARD_UPDATE:
               this.removeFromList(listener,this._keyUpdateList);
               break;
            case UpdateType.UI_UPDATE:
               this.removeFromList(listener,this._uiUpdateList);
               break;
            case UpdateType.UPDATE_1:
               this.removeFromList(listener,this._update1List);
               break;
            case UpdateType.UPDATE_2:
               this.removeFromList(listener,this._update2List);
               break;
            case UpdateType.UPDATE_3:
               this.removeFromList(listener,this._update3List);
               break;
         }
      }
      
      public function createMvc(model:Model = null, view:View = null, viewComponent:DisplayObject = null, controller:Controller = null, initModelInfo:* = null) : void
      {
         var id:* = 0;
         if(model != null)
         {
            id = this._modelList.indexOf(null);
            id = id > -1?id:this._modelList.length;
            this._modelList[id] = model;
            model.setFacade(this);
            model.setId(id);
         }
         if(view != null)
         {
            id = this._viewList.indexOf(null);
            id = id > -1?id:this._viewList.length;
            this._viewList[id] = view;
            view.setFacade(this);
            view.setId(id);
            view.setController(controller);
            view.setModel(model);
            if(viewComponent != null)
            {
               view.setViewComponent(viewComponent);
            }
         }
         if(controller != null)
         {
            id = this._controllerList.indexOf(null);
            id = id > -1?id:this._controllerList.length;
            this._controllerList[id] = controller;
            controller.setFacade(this);
            controller.setId(id);
            controller.setModel(model);
         }
         if(model != null)
         {
            model.init();
         }
         if(view != null)
         {
            view.init();
         }
         if(controller != null)
         {
            controller.init();
         }
         if(view != null)
         {
            view.addDestroyAllListener();
         }
         else if(controller != null)
         {
            controller.addDestroyAllListener();
         }
         else if(model != null)
         {
            model.addDestroyAllListener();
         }
         
         
         if(controller != null)
         {
            controller.dispatchEvent(FrameworkEvent.getInitModelEvent(initModelInfo));
         }
      }
      
      public function createGameObj(obj:GameObject, initModelInfo:* = null) : GameObject
      {
         var id:int = this._gameObjList.indexOf(null);
         id = id > -1?id:this._gameObjList.length;
         this._gameObjList[id] = obj;
         obj.setFacade(this);
         obj.setId(id);
         obj.init();
         obj.addToGameObjectList(this._gameObjectListProxy);
         obj.addDestroyAllListener();
         obj.dispatchEvent(FrameworkEvent.getInitModelEvent(initModelInfo));
         return obj;
      }
      
      public function getGameObjList(gameObjClass:Class) : Vector.<GameObject>
      {
         var qualifiedClassName:String = getQualifiedClassName(gameObjClass);
         return this._gameObjectListProxy.getGameObjectList(qualifiedClassName);
      }
      
      public function getGameObjListToArray(gameObjClass:Class) : Array
      {
         var qualifiedClassName:String = getQualifiedClassName(gameObjClass);
         return this._gameObjectListProxy.getGameObjectListToArray(qualifiedClassName);
      }
      
      public function getModel(id:int) : Model
      {
         return this._modelList[id];
      }
      
      public function getView(id:int) : View
      {
         return this._viewList[id];
      }
      
      public function getController(id:int) : Controller
      {
         return this._controllerList[id];
      }
      
      public function getGameObj(id:int) : GameObject
      {
         return this._gameObjList[id];
      }
      
      public function removeModel(id:int) : void
      {
         this._modelList[id] = null;
      }
      
      public function removeView(id:int) : void
      {
         this._viewList[id] = null;
      }
      
      public function removeController(id:int) : void
      {
         this._controllerList[id] = null;
      }
      
      public function removeGameObj(id:int) : void
      {
         this._gameObjList[id] = null;
      }
      
      public function existUpdateList(func:Function) : String
      {
         if(this._keyUpdateList.indexOf(func) > -1)
         {
            return "存在 _keyUpdateList 中";
         }
         if(this._uiUpdateList.indexOf(func) > -1)
         {
            return "存在 _uiUpdateList 中";
         }
         if(this._update1List.indexOf(func) > -1)
         {
            return "存在 _update1List 中";
         }
         if(this._update2List.indexOf(func) > -1)
         {
            return "存在 _update2List 中";
         }
         if(this._update3List.indexOf(func) > -1)
         {
            return "存在 _update3List 中";
         }
         return null;
      }
      
      private function foreachList(list:Array) : void
      {
         var i:int = list.length;
         while(--i >= 0)
         {
            if(list[i])
            {
               list[i]();
            }
            else
            {
               list.splice(i,1);
            }
         }
      }
      
      private function addToList(func:Function, list:Array) : void
      {
         if(func == null)
         {
            return;
         }
         if(list.indexOf(func) < 0)
         {
            list.push(func);
         }
      }
      
      private function removeFromList(func:Function, list:Array) : void
      {
         var id:int = list.indexOf(func);
         if(id > -1)
         {
            list[id] = null;
         }
      }
	  
	  frameworkInternal function onDestroy():void{
		  if(_global){
			  _global.onDestroy();
			  _global=null;
		  }
		  if(_viewList){
			  i=_viewList.length;
			   while (--i>=0){
				   var view:View=_viewList[i] as View;
				   if(view)view.destroy();
			   }
			   _viewList=null;
		  }
		  if(_controllerList){
			  var i:int=_controllerList.length;
			   while (--i>=0){
				   var ctl:Controller=_controllerList[i] as Controller;
				   if(ctl)ctl.destroy();
			   }
			  _controllerList=null;
		  }
		  if(_modelList){
			  i=_modelList.length;
			  while (--i>=0){
				  var model:Model=_modelList[i] as Model;
				  if(model)  model.destroy();
			  }
			_modelList=null;
		  }
		  _keyUpdateList=null;
		  _uiUpdateList=null;
		  _update1List=null;
		  _update2List=null;
		  _update3List=null;
		  _gameObjList=null;
		  _gameObjectListProxy=null;
	  }
   }
}
