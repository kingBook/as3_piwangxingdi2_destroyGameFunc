package framework.utils
{
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   
   public final class ButtonEffect extends Object
   {
      
      public function ButtonEffect(target:DisplayObject, vars:Object)
      {
         super();
         if(target == null)
         {
            return;
         }
         this._target = target;
         this._noteScaleX = this._target.scaleX;
         this._noteScaleY = this._target.scaleY;
         this._vars = vars;
         this.addOrRemoveEventListener();
         _bfArr.push({
            "target":this._target,
            "bf":this
         });
      }
      
      private static var _bfArr:Array = [];
      
      public static function to(target:DisplayObject, vars:Object) : ButtonEffect
      {
         return new ButtonEffect(target,vars);
      }
      
      public static function killOf(disObj:DisplayObject) : void
      {
         var obj:Object = null;
         var target:DisplayObject = null;
         var bf:ButtonEffect = null;
         var i:int = _bfArr.length;
         while(--i >= 0)
         {
            obj = _bfArr[i];
            target = obj.target;
            bf = ButtonEffect(obj.bf);
            if(target == disObj)
            {
               bf.destroy();
               break;
            }
         }
      }
      
      public static function killAll() : void
      {
         var obj:Object = null;
         var bf:ButtonEffect = null;
         var i:int = _bfArr.length;
         while(--i >= 0)
         {
            obj = _bfArr[i];
            bf = ButtonEffect(obj.bf);
            bf.destroy();
            _bfArr.splice(i,1);
         }
      }
      
      private var _tweenMax:TweenMax;
      
      private var _target:DisplayObject;
      
      private var _vars:Object;
      
      private var _noteScaleX:Number;
      
      private var _noteScaleY:Number;
      
      private function addOrRemoveEventListener(remove:Boolean = false) : void
      {
         var methodName:String = remove?"removeEventListener":"addEventListener";
         this._target[methodName](MouseEvent.ROLL_OVER,this.rollOverHandler);
         this._target[methodName](MouseEvent.ROLL_OUT,this.rollOutHandler);
      }
      
      private function rollOverHandler(e:MouseEvent) : void
      {
         var f:* = NaN;
         var isSwapChildId:* = false;
         if(e.target != this._target)
         {
            return;
         }
         if(this._vars["glow"])
         {
            this.addOrRemoveFilter(true);
         }
         if(this._vars["scale"])
         {
            f = Number(this._vars.scale.f)?Number(this._vars.scale.f):0.2;
            this._target.scaleX = this._noteScaleX + f;
            this._target.scaleY = this._noteScaleY + f;
            isSwapChildId = !(this._vars["isSwapChildId"] == undefined)?this._vars["isSwapChildId"]:true;
            if((this._target.parent) && (isSwapChildId))
            {
               this._target.parent.setChildIndex(this._target,this._target.parent.numChildren - 1);
            }
         }
      }
      
      private function rollOutHandler(e:MouseEvent) : void
      {
         if(e.target != this._target)
         {
            return;
         }
         if(this._vars["glow"])
         {
            this.addOrRemoveFilter(false);
         }
         if(this._vars["scale"])
         {
            this._target.scaleX = this._noteScaleX;
            this._target.scaleY = this._noteScaleY;
         }
      }
      
      private function addOrRemoveFilter(add:Boolean) : void
      {
         var color:uint = uint(this._vars.glow.color)?uint(this._vars.glow.color):65535;
         if(add)
         {
            this._tweenMax = TweenMax.to(this._target,0,{"glowFilter":{
               "alpha":1,
               "blurX":10,
               "blurY":10,
               "color":color,
               "strength":1
            }});
         }
         else
         {
            this._tweenMax = TweenMax.to(this._target,0,{"glowFilter":{
               "alpha":0,
               "blurX":0,
               "blurY":0,
               "color":color,
               "strength":0
            }});
         }
      }
      
      private function destroy() : void
      {
         this._target.scaleX = this._noteScaleX;
         this._target.scaleY = this._noteScaleY;
         this._target && this.addOrRemoveEventListener(true);
         TweenMax.killTweensOf(this._tweenMax);
         this._tweenMax = null;
         this._vars = null;
         this._target = null;
      }
   }
}
