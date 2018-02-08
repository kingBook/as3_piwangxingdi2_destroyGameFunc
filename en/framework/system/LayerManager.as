package framework.system
{
   import flash.display.Sprite;
   import flash.display.DisplayObject;
   import framework.namespaces.frameworkInternal;
   import framework.utils.FuncUtil;
   use namespace frameworkInternal;
   
   public class LayerManager extends Object
   {
      
      public function LayerManager(main:Sprite)
      {
         super();
         this.init(main);
      }
      
      private var _mainLayer:Sprite;
      
      private var _shakeLayer:Sprite;
      
      private var _uiLayer:Sprite;
      
      private var _bgLayer:Sprite;
      
      private var _gameLayer:Sprite;
      
      private var _weatherLayer:Sprite;
      
      private var _items0Layer:Sprite;
      
      private var _items1Layer:Sprite;
      
      private var _items2Layer:Sprite;
      
      private var _items3Layer:Sprite;
      
      private var _items4Layer:Sprite;
      
      private var _effLayer:Sprite;
      
      private var _allLayerList:Array;
      
      private function init(main:Sprite) : void
      {
         if(main == null)
         {
            throw new Error("参数main不能为null");
         }
         else
         {
            this._mainLayer = new Sprite();
            if(main.numChildren > 1)
            {
               trace("警告：主文档容器main存在子对象已执行覆盖~~!","this:" + this);
            }
            main.addChild(this._mainLayer);
            this._shakeLayer = new Sprite();
            this._uiLayer = new Sprite();
            this._shakeLayer.name = "_shakeLayer";
            this._uiLayer.name = "_uiLayer";
            this.initMainLayer();
            this._bgLayer = new Sprite();
            this._gameLayer = new Sprite();
            this._weatherLayer = new Sprite();
            this._bgLayer.name = "_bgLayer";
            this._gameLayer.name = "_gameLayer";
            this._weatherLayer.name = "_weatherLayer";
            this.initShakeLayer();
            this._items0Layer = new Sprite();
            this._items1Layer = new Sprite();
            this._items2Layer = new Sprite();
            this._items3Layer = new Sprite();
            this._items4Layer = new Sprite();
            this._effLayer = new Sprite();
            this._items0Layer.name = "_items0Layer";
            this._items1Layer.name = "_items1Layer";
            this._items2Layer.name = "_items2Layer";
            this._items3Layer.name = "_items3Layer";
            this._items4Layer.name = "_items4Layer";
            this.initGameLayer();
            this._allLayerList = [this._shakeLayer,this._uiLayer,this._bgLayer,this._gameLayer,this._weatherLayer,this._items0Layer,this._items1Layer,this._items2Layer,this._items3Layer,this._items4Layer,this._effLayer];
            return;
         }
      }
      
      public function reset() : void
      {
         this._shakeLayer.x = this._shakeLayer.y = 0;
         this._gameLayer.x = this._gameLayer.y = 0;
         this.clearContainer(this._effLayer);
         this.clearContainer(this._items4Layer);
         this.clearContainer(this._items3Layer);
         this.clearContainer(this._items2Layer);
         this.clearContainer(this._items1Layer);
         this.clearContainer(this._items0Layer);
         this.clearContainer(this._weatherLayer);
         this.clearContainer(this._gameLayer);
         this.clearContainer(this._bgLayer);
         this.clearContainer(this._uiLayer);
         this.clearContainer(this._shakeLayer);
      }
      
      private function initMainLayer() : void
      {
         this._mainLayer.addChild(this._shakeLayer);
         this._mainLayer.addChild(this._uiLayer);
      }
      
      private function initShakeLayer() : void
      {
         this._shakeLayer.addChild(this._bgLayer);
         this._shakeLayer.addChild(this._gameLayer);
         this._shakeLayer.addChild(this._weatherLayer);
      }
      
      private function initGameLayer() : void
      {
         this._gameLayer.addChild(this._items0Layer);
         this._gameLayer.addChild(this._items1Layer);
         this._gameLayer.addChild(this._items2Layer);
         this._gameLayer.addChild(this._items3Layer);
         this._gameLayer.addChild(this._items4Layer);
         this._gameLayer.addChild(this._effLayer);
      }
      
      private function clearContainer(c:Sprite) : void
      {
         var child:DisplayObject = null;
         var i:int = c.numChildren;
         while(--i >= 0)
         {
            child = c.getChildAt(i);
            if(!((child is Sprite) && (this._allLayerList.indexOf(child) > -1)))
            {
               c.removeChild(child);
            }
         }
      }
	  
	  frameworkInternal function onDestroy():void{
		  FuncUtil.removeChild(_mainLayer);
		  FuncUtil.removeChild(_shakeLayer);
		  FuncUtil.removeChild(_uiLayer);
		  FuncUtil.removeChild(_bgLayer);
		  FuncUtil.removeChild(_gameLayer);
		  FuncUtil.removeChild(_weatherLayer);
		  FuncUtil.removeChild(_items0Layer);
		  FuncUtil.removeChild(_items1Layer);
		  FuncUtil.removeChild(_items2Layer);
		  FuncUtil.removeChild(_items3Layer);
		  FuncUtil.removeChild(_items4Layer);
		  FuncUtil.removeChild(_effLayer);
		  _mainLayer=null;
		  _shakeLayer=null;
		  _uiLayer=null;
		  _bgLayer=null;
		  _gameLayer=null;
		  _weatherLayer=null;
		  _items0Layer=null;
		  _items1Layer=null;
		  _items2Layer=null;
		  _items3Layer=null;
		  _items4Layer=null;
		  _effLayer=null;
		  _allLayerList=null;
	  }
      
      public function get uiLayer() : Sprite
      {
         return this._uiLayer;
      }
      
      public function get bgLayer() : Sprite
      {
         return this._bgLayer;
      }
      
      public function get weatherLayer() : Sprite
      {
         return this._weatherLayer;
      }
      
      public function get gameLayer() : Sprite
      {
         return this._gameLayer;
      }
      
      public function get items0Layer() : Sprite
      {
         return this._items0Layer;
      }
      
      public function get items1Layer() : Sprite
      {
         return this._items1Layer;
      }
      
      public function get items2Layer() : Sprite
      {
         return this._items2Layer;
      }
      
      public function get items3Layer() : Sprite
      {
         return this._items3Layer;
      }
      
      public function get items4Layer() : Sprite
      {
         return this._items4Layer;
      }
      
      public function get effLayer() : Sprite
      {
         return this._effLayer;
      }
      
      public function get shakeLayer() : Sprite
      {
         return this._shakeLayer;
      }
   }
}
