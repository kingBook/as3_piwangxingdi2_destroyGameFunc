package framework.snd.signals
{
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   import flash.errors.IllegalOperationError;
   
   public class Signal extends Object implements ISignalOwner, IDispatcher
   {
      
      public function Signal(... valueClasses)
      {
         super();
         this.listeners = [];
         this.onceListeners = new Dictionary();
         if((valueClasses.length == 1) && (valueClasses[0] is Array))
         {
            valueClasses = valueClasses[0];
         }
         this.valueClasses = valueClasses;
      }
      
      protected var _valueClasses:Array;
      
      protected var listeners:Array;
      
      protected var onceListeners:Dictionary;
      
      protected var listenersNeedCloning:Boolean = false;
      
      public function get valueClasses() : Array
      {
         return this._valueClasses;
      }
      
      public function set valueClasses(value:Array) : void
      {
         this._valueClasses = value?value.slice():[];
         var i:int = this._valueClasses.length;
         while(i--)
         {
            if(!(this._valueClasses[i] is Class))
            {
               throw new ArgumentError("Invalid valueClasses argument: item at index " + i + " should be a Class but was:<" + this._valueClasses[i] + ">." + getQualifiedClassName(this._valueClasses[i]));
            }
            else
            {
               continue;
            }
         }
      }
      
      public function get numListeners() : uint
      {
         return this.listeners.length;
      }
      
      public function add(listener:Function) : Function
      {
         this.registerListener(listener);
         return listener;
      }
      
      public function addOnce(listener:Function) : Function
      {
         this.registerListener(listener,true);
         return listener;
      }
      
      public function remove(listener:Function) : Function
      {
         var index:int = this.listeners.indexOf(listener);
         if(index == -1)
         {
            return listener;
         }
         if(this.listenersNeedCloning)
         {
            this.listeners = this.listeners.slice();
            this.listenersNeedCloning = false;
         }
         this.listeners.splice(index,1);
         delete this.onceListeners[listener];
         true;
         return listener;
      }
      
      public function removeAll() : void
      {
         var i:uint = this.listeners.length;
         while(i--)
         {
            this.remove(this.listeners[i] as Function);
         }
      }
      
      public function dispatch(... valueObjects) : void
      {
         var valueObject:Object = null;
         var valueClass:Class = null;
         var listener:Function = null;
         var numValueClasses:int = this._valueClasses.length;
         if(valueObjects.length < numValueClasses)
         {
            throw new ArgumentError("Incorrect number of arguments. Expected at least " + numValueClasses + " but received " + valueObjects.length + ".");
         }
         else
         {
            var i:int = 0;
            while(i < numValueClasses)
            {
               if(((valueObject = valueObjects[i]) === null) || (valueObject is (valueClass = this._valueClasses[i])))
               {
                  i++;
                  continue;
               }
               throw new ArgumentError("Value object <" + valueObject + "> is not an instance of <" + valueClass + ">.");
            }
            if(!this.listeners.length)
            {
               return;
            }
            this.listenersNeedCloning = true;
            switch(valueObjects.length)
            {
               case 0:
                  for each(listener in this.listeners)
                  {
                     if(this.onceListeners[listener])
                     {
                        this.remove(listener);
                     }
                     listener();
                  }
                  break;
               case 1:
                  for each(listener in this.listeners)
                  {
                     if(this.onceListeners[listener])
                     {
                        this.remove(listener);
                     }
                     listener(valueObjects[0]);
                  }
                  break;
            }
            this.listenersNeedCloning = false;
            return;
         }
      }
      
      protected function registerListener(listener:Function, once:Boolean = false) : void
      {
         var argumentString:String = null;
         if(listener.length < this._valueClasses.length)
         {
            argumentString = listener.length == 1?"argument":"arguments";
            throw new ArgumentError("Listener has " + listener.length + " " + argumentString + " but it needs at least " + this._valueClasses.length + " to match the given value classes.");
         }
         else
         {
            if(!this.listeners.length)
            {
               this.listeners[0] = listener;
               if(once)
               {
                  this.onceListeners[listener] = true;
               }
               return;
            }
            if(this.listeners.indexOf(listener) >= 0)
            {
               if((this.onceListeners[listener]) && (!once))
               {
                  throw new IllegalOperationError("You cannot addOnce() then add() the same listener without removing the relationship first.");
               }
               else if((!this.onceListeners[listener]) && (once))
               {
                  throw new IllegalOperationError("You cannot add() then addOnce() the same listener without removing the relationship first.");
               }
               else
               {
                  return;
               }
               
            }
            else
            {
               if(this.listenersNeedCloning)
               {
                  this.listeners = this.listeners.slice();
                  this.listenersNeedCloning = false;
               }
               this.listeners[this.listeners.length] = listener;
               if(once)
               {
                  this.onceListeners[listener] = true;
               }
               return;
            }
         }
      }
   }
}
