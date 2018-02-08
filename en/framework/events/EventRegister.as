package framework.events
{
   import flash.events.EventDispatcher;
   import framework.Facade;
   import framework.namespaces.frameworkInternal;
   
   public class EventRegister extends EventDispatcher
   {
      
      public function EventRegister()
      {
         this._eventListeners = [];
         this._updateListeners = [];
         super();
      }
      
      private var _eventListeners:Array;
      
      private var _updateListeners:Array;
      
      protected var _facade:Facade;
      
      frameworkInternal function setFacade(value:Facade) : void
      {
         this._facade = value;
      }
      
      protected final function registerEventListener(target:EventDispatcher, eventType:String, listener:Function) : void
      {
         var reg:RegisterA = new RegisterA(target,eventType,listener);
         this._eventListeners.push(reg);
      }
      
      protected final function logoutEventListener(target:EventDispatcher, eventType:String, listener:Function) : void
      {
         var reg:RegisterA = null;
         var i:int = this._eventListeners.length;
         while(--i >= 0)
         {
            reg = this._eventListeners[i];
            if(reg.target == target)
            {
               reg.destroy();
               this._eventListeners.splice(i,1);
               break;
            }
         }
      }
      
      protected final function registerUpdateListener(type:String, listener:Function) : void
      {
         if(listener.length > 0)
         {
            throw new Error("registerUpdateListener 侦听函数参数个数必须为0");
         }
         else
         {
            var reg:RegisterB = new RegisterB(this._facade,type,listener);
            this._updateListeners.push(reg);
            return;
         }
      }
      
      protected final function logoutUpdateListener(type:String, listener:Function) : void
      {
         var reg:RegisterB = null;
         var i:int = this._updateListeners.length;
         while(--i >= 0)
         {
            reg = this._updateListeners[i];
            if(reg.type == type)
            {
               reg.destroy();
               this._updateListeners.splice(i,1);
               break;
            }
         }
      }
      
      protected final function LogoutAllListener() : void
      {
         var regA:RegisterA = null;
         var regB:RegisterB = null;
         var i:int = this._eventListeners.length;
         while(--i >= 0)
         {
            regA = this._eventListeners[i];
            regA.destroy();
         }
         this._eventListeners.length = 0;
         i = this._updateListeners.length;
         while(--i >= 0)
         {
            regB = this._updateListeners[i];
            regB.destroy();
         }
         this._updateListeners.length = 0;
      }
      
      public function destroy() : void
      {
         this.LogoutAllListener();
         this._eventListeners = null;
         this._updateListeners = null;
      }
   }
}
import flash.events.EventDispatcher;

class RegisterA extends Object
{
   
   function RegisterA(target:EventDispatcher, type:String, listener:Function)
   {
      super();
      this.target = target;
      this.type = type;
      this.listener = listener;
      this.target.addEventListener(type,listener);
   }
   
   public var target:EventDispatcher;
   
   public var type:String;
   
   public var listener:Function;
   
   public function destroy() : void
   {
      this.target.removeEventListener(this.type,this.listener);
      this.target = null;
      this.type = null;
      this.listener = null;
   }
}
import framework.Facade;

class RegisterB extends Object
{
   
   function RegisterB(facade:Facade, type:String, listener:Function)
   {
      super();
      this.facade = facade;
      this.type = type;
      this.listener = listener;
      this.facade.addUpdateListener(type,listener);
   }
   
   public var facade:Facade;
   
   public var type:String;
   
   public var listener:Function;
   
   public function destroy() : void
   {
      this.facade.removeUpdateListener(this.type,this.listener);
      this.facade = null;
      this.type = null;
      this.listener = null;
   }
}
