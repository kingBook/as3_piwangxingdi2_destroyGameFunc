package framework.system
{
   import framework.Facade;
   import Box2D.Dynamics.b2DebugDraw;
   import flash.display.Sprite;
   import Box2D.Dynamics.b2World;
   import framework.events.FrameworkEvent;
   import framework.namespaces.frameworkInternal;
   use namespace frameworkInternal;
   
   public class Box2dDebug extends Object
   {
      
      public function Box2dDebug(facade:Facade, viewMan:LayerManager, global:Global, pixelToMeter:Number)
      {
         super();
         this._facade = facade;
         this._viewMan = viewMan;
         this._global = global;
         this._parent = new Sprite();
         this._parent.name = "napeDebugSprite";
         this._viewMan.gameLayer.addChild(this._parent);
         this._debugDraw = new b2DebugDraw();
         this._debugDraw.SetSprite(this._parent);
         this._debugDraw.SetDrawScale(pixelToMeter);
         this._debugDraw.SetFillAlpha(0);
         this._debugDraw.SetLineThickness(0.5);
         this._debugDraw.SetFlags(b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit | b2DebugDraw.e_centerOfMassBit);
         this._global.addEventListener(FrameworkEvent.CHANGE_CURRENT_WORLD,this.changeCurrentWorldHandler);
      }
      
      private var _facade:Facade;
      
      private var _debugDraw:b2DebugDraw;
      
      private var _parent:Sprite;
      
      private var _viewMan:LayerManager;
      
      private var _world:b2World;
      
      private var _global:Global;
      
      private function changeCurrentWorldHandler(e:FrameworkEvent) : void
      {
         this.setWorld(this._global.curWorld);
      }
      
      public function reset() : void
      {
         this._viewMan.gameLayer.addChild(this._parent);
      }
      
      private function setWorld(world:b2World) : void
      {
         this._world = world;
         this._world.SetDebugDraw(this._debugDraw);
      }
      
      public function get debugDraw() : b2DebugDraw
      {
         return this._debugDraw;
      }
	  
	  frameworkInternal function onDestroy():void{
		  if(_global){
			_global.removeEventListener(FrameworkEvent.CHANGE_CURRENT_WORLD,this.changeCurrentWorldHandler);
			_global=null;
		  }
		  _world=null;
		  _viewMan=null;
		  _parent=null;
		  _debugDraw=null;
		  _facade=null;
	  }
   }
}
