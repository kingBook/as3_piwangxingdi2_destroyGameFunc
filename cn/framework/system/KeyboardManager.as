package framework.system
{
   import flash.display.Stage;
   import framework.Facade;
   import flash.events.Event;
   import flash.utils.getTimer;
   import framework.UpdateType;
   
   public class KeyboardManager extends Object
   {
      
      public function KeyboardManager(facade:Facade)
      {
         super();
         this._facade = facade;
         this._stage = this._facade.global.stage;
         this._keys = new SystemKeyboard();
         this._keys.bind(this._stage);
         this._stage.focus = this._stage;
         this._stage.addEventListener(Event.DEACTIVATE,this.deActivateHandler);
         this._facade.addUpdateListener(UpdateType.KEYBOARD_UPDATE,this.update);
      }
      
      private var _stage:Stage;
      
      private var _keys:SystemKeyboard;
      
      private var _lastTime:int;
      
      private var _release:Boolean;
      
      private var _facade:Facade;
      
      private function deActivateHandler(e:Event) : void
      {
         this._keys.reset();
      }
      
      private function update() : void
      {
         this._keys.update();
      }
      
      public function p(key:String) : Boolean
      {
         return this._keys.pressed(key);
      }
      
      public function jP(key:String) : Boolean
      {
         return this._keys.justPressed(key);
      }
      
      public function jR(key:String) : Boolean
      {
         return this._keys.justReleased(key);
      }
      
      public function double(key:String) : Boolean
      {
         var doubleKey:* = false;
         if(this.jR(key))
         {
            this._release = true;
         }
         else if(this.jP(key))
         {
            if((this._lastTime - (this._lastTime = getTimer()) + 300 > 0) && (this._release))
            {
               doubleKey = true;
            }
            this._release = false;
         }
         
         return doubleKey;
      }
      
      public function destroy() : void
      {
         this._stage.removeEventListener(Event.DEACTIVATE,this.deActivateHandler);
         this._facade.removeUpdateListener(UpdateType.KEYBOARD_UPDATE,this.update);
         if(this._keys)
         {
            this._keys.unbind(this._stage);
            this._keys.destroy();
            this._keys = null;
         }
         this._stage = null;
         this._facade = null;
      }
   }
}
