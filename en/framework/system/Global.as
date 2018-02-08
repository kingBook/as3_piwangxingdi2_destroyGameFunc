package framework.system
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2World;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.EventDispatcher;
   import framework.Facade;
   import framework.events.FrameworkEvent;
   import framework.namespaces.frameworkInternal;
   import framework.snd.sound.SoundManager;
   use namespace frameworkInternal;
   
   public class Global extends EventDispatcher
   {
      
      public function Global(main:Sprite, facade:Facade, gameWidth:Number, gameHeight:Number, box2dDebugVisible:Boolean = false, pixelToMeter:Number = 30)
      {
         super();
         this._main = main;
         this._stage = main.stage;
         this._facade = facade;
         this._gameWidth = gameWidth;
         this._gameHeight = gameHeight;
         this._pixelToMeter = pixelToMeter;
         this._layerMan = new LayerManager(this._main);
         this._objectPool = ObjectPool.getInstance();
         if(box2dDebugVisible)
         {
            this._box2dDebug = new Box2dDebug(this._facade,this._layerMan,this,pixelToMeter);
         }
      }
      
      protected var _facade:Facade;
      
      protected var _stage:Stage;
      
      protected var _layerMan:LayerManager;
      
      protected var _main:Sprite;
      
      protected var _objectPool:ObjectPool;
      
      protected var _curWorld:b2World;
      
      protected var _localMan:LocalManager;
      
      protected var _box2dManList:Vector.<Box2dManager>;
      
      protected var _scorllMan:ScorllManager;
      
      protected var _shakeMan:ShakeManager;
      
      protected var _box2dDebug:Box2dDebug;
      
      protected var _gameWidth:Number;
      
      protected var _gameHeight:Number;
      
      protected var _pixelToMeter:Number;
	  
	  protected var _soundMan:SoundManager;
      
      public function setCurWorld(value:b2World) : void
      {
         if(value == this._curWorld)
         {
            return;
         }
         this._curWorld = value;
         dispatchEvent(new FrameworkEvent(FrameworkEvent.CHANGE_CURRENT_WORLD));
      }
      
      public function getBox2dMan(id:int) : Box2dManager
      {
         if((!this._box2dManList) || (this._box2dManList.length <= id))
         {
            return null;
         }
         return this._box2dManList[id];
      }
      
      public function createBox2dMan(id:int, worldDisObj:DisplayObject, gravity:b2Vec2, useMouseJoint:Boolean = false, deltaTime:Number = 30, pixelToMeter:Number = 30) : Box2dManager
      {
         if(this._box2dManList == null)
         {
            this._box2dManList = new Vector.<Box2dManager>();
         }
         this._box2dManList[id] = new Box2dManager(worldDisObj,this._facade,useMouseJoint,gravity,deltaTime,pixelToMeter);
         return this._box2dManList[id];
      }
      
      protected function reset() : void
      {
         var i:* = 0;
         var box2dMan:Box2dManager = null;
         this._layerMan.reset();
         if(this._box2dDebug)
         {
            this._box2dDebug.reset();
         }
         if(this._scorllMan)
         {
            this._scorllMan.reset();
         }
         if(this._box2dManList.length > 0)
         {
            i = this._box2dManList.length;
            while(--i >= 0)
            {
               box2dMan = this._box2dManList[i];
               if(box2dMan)
               {
                  box2dMan.reset();
               }
            }
         }
      }
	  
	  frameworkInternal function onDestroy():void{
		  if(_layerMan){
			  _layerMan.onDestroy();
			  _layerMan=null;
		  }
		  if(_objectPool){
			  _objectPool.onDestroy();
			  _objectPool=null;
		  }
		  if(_box2dManList){
			  var i:int=_box2dManList.length;
			  while (--i>=0){
				  var box2dMan:Box2dManager=_box2dManList[i] as Box2dManager;
				  if(box2dMan){
					  box2dMan.destroy();
				  }
			  }
			  _box2dManList=null;
		  }
		  if(_shakeMan){
			  _shakeMan.destroy();
			  _shakeMan=null;
		  }
		  if(_box2dDebug){
			  _box2dDebug.onDestroy();
			  _box2dDebug=null;
		  }
		  if(_soundMan){
			  _soundMan.stopAll();
			  _soundMan=null;
		  }
		  
		  _scorllMan=null;
		  _localMan=null;
		  _curWorld=null;
		  _main=null;
		  _stage=null;
		  _facade=null;
	  }
      
      public function get curWorld() : b2World
      {
         return this._curWorld;
      }
      
      public function get stage() : Stage
      {
         return this._stage;
      }
      
      public function get layerMan() : LayerManager
      {
         return this._layerMan;
      }
      
      public function get main() : Sprite
      {
         return this._main;
      }
      
      public function get objectPool() : ObjectPool
      {
         return this._objectPool;
      }
      
      public function get localManager() : LocalManager
      {
         return this._localMan = this._localMan || new LocalManager();
      }
      
      public function get soundMan() : SoundManager
      {
         return _soundMan||=new SoundManager();
      }
      
      public function get scorllMan() : ScorllManager
      {
         return this._scorllMan = this._scorllMan || new ScorllManager(this._layerMan.gameLayer,this._gameWidth,this._gameHeight,this._pixelToMeter,this._facade);
      }
      
      public function get shakeMan() : ShakeManager
      {
         return this._shakeMan = this._shakeMan || new ShakeManager(this._facade,this._layerMan.shakeLayer);
      }
      
      public function get box2dDebug() : Box2dDebug
      {
         return this._box2dDebug;
      }
      
      public function get gameWidth() : Number
      {
         return this._gameWidth;
      }
      
      public function get gameHeight() : Number
      {
         return this._gameHeight;
      }
      
      public function get pixelToMeter() : Number
      {
         return this._pixelToMeter;
      }
   }
}
