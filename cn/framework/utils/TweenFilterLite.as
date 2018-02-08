package framework.utils
{
   import flash.filters.*;
   import flash.display.DisplayObject;
   
   public class TweenFilterLite extends TweenLite
   {
      
      public function TweenFilterLite($target:Object, $duration:Number, $vars:Object)
      {
         this._filters = [];
         super($target,$duration,$vars);
         if((TweenLite.version < 6.34) || (isNaN(TweenLite.version)))
         {
            trace("TweenFilterLite error! Please update your TweenLite class or try deleting your ASO files. TweenFilterLite requires a more recent version. Download updates at http://www.TweenLite.com.");
         }
         if($vars.type != undefined)
         {
            trace("TweenFilterLite error: " + $target + " is using deprecated syntax. Please update to the new syntax. See http://www.TweenFilterLite.com for details.");
         }
      }
      
      public static var version:Number = 7.22;
      
      public static var delayedCall:Function = TweenLite.delayedCall;
      
      public static var killTweensOf:Function = TweenLite.killTweensOf;
      
      public static var killDelayedCallsTo:Function = TweenLite.killTweensOf;
      
      public static var defaultEase:Function = TweenLite.defaultEase;
      
      private static var _idMatrix:Array = [1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0];
      
      private static var _lumR:Number = 0.212671;
      
      private static var _lumG:Number = 0.71516;
      
      private static var _lumB:Number = 0.072169;
      
      public static function to($mc:Object, $duration:Number, $vars:Object) : TweenFilterLite
      {
         return new TweenFilterLite($mc,$duration,$vars);
      }
      
      public static function from($mc:Object, $duration:Number, $vars:Object) : TweenFilterLite
      {
         $vars.runBackwards = true;
         return new TweenFilterLite($mc,$duration,$vars);
      }
      
      public static function colorize($m:Array, $color:Number, $amount:Number = 100) : Array
      {
         if(isNaN($color))
         {
            return $m;
         }
         if(isNaN($amount))
         {
            var $amount:Number = 1;
         }
         var r:Number = ($color >> 16 & 255) / 255;
         var g:Number = ($color >> 8 & 255) / 255;
         var b:Number = ($color & 255) / 255;
         var inv:Number = 1 - $amount;
         var temp:Array = [inv + $amount * r * _lumR,$amount * r * _lumG,$amount * r * _lumB,0,0,$amount * g * _lumR,inv + $amount * g * _lumG,$amount * g * _lumB,0,0,$amount * b * _lumR,$amount * b * _lumG,inv + $amount * b * _lumB,0,0,0,0,0,1,0];
         return applyMatrix(temp,$m);
      }
      
      public static function setThreshold($m:Array, $n:Number) : Array
      {
         if(isNaN($n))
         {
            return $m;
         }
         var temp:Array = [_lumR * 256,_lumG * 256,_lumB * 256,0,-256 * $n,_lumR * 256,_lumG * 256,_lumB * 256,0,-256 * $n,_lumR * 256,_lumG * 256,_lumB * 256,0,-256 * $n,0,0,0,1,0];
         return applyMatrix(temp,$m);
      }
      
      public static function setHue($m:Array, $n:Number) : Array
      {
         if(isNaN($n))
         {
            return $m;
         }
         var $n:Number = $n * Math.PI / 180;
         var c:Number = Math.cos($n);
         var s:Number = Math.sin($n);
         var temp:Array = [_lumR + c * (1 - _lumR) + s * -_lumR,_lumG + c * -_lumG + s * -_lumG,_lumB + c * -_lumB + s * (1 - _lumB),0,0,_lumR + c * -_lumR + s * 0.143,_lumG + c * (1 - _lumG) + s * 0.14,_lumB + c * -_lumB + s * -0.283,0,0,_lumR + c * -_lumR + s * -(1 - _lumR),_lumG + c * -_lumG + s * _lumG,_lumB + c * (1 - _lumB) + s * _lumB,0,0,0,0,0,1,0,0,0,0,0,1];
         return applyMatrix(temp,$m);
      }
      
      public static function setBrightness($m:Array, $n:Number) : Array
      {
         if(isNaN($n))
         {
            return $m;
         }
         var $n:Number = $n * 100 - 100;
         return applyMatrix([1,0,0,0,$n,0,1,0,0,$n,0,0,1,0,$n,0,0,0,1,0,0,0,0,0,1],$m);
      }
      
      public static function setSaturation($m:Array, $n:Number) : Array
      {
         if(isNaN($n))
         {
            return $m;
         }
         var inv:Number = 1 - $n;
         var r:Number = inv * _lumR;
         var g:Number = inv * _lumG;
         var b:Number = inv * _lumB;
         var temp:Array = [r + $n,g,b,0,0,r,g + $n,b,0,0,r,g,b + $n,0,0,0,0,0,1,0];
         return applyMatrix(temp,$m);
      }
      
      public static function setContrast($m:Array, $n:Number) : Array
      {
         if(isNaN($n))
         {
            return $m;
         }
         var $n:Number = $n + 0.01;
         var temp:Array = [$n,0,0,0,128 * (1 - $n),0,$n,0,0,128 * (1 - $n),0,0,$n,0,128 * (1 - $n),0,0,0,1,0];
         return applyMatrix(temp,$m);
      }
      
      public static function applyMatrix($m:Array, $m2:Array) : Array
      {
         var y:* = 0;
         var x:* = 0;
         if((!($m is Array)) || (!($m2 is Array)))
         {
            return $m2;
         }
         var temp:Array = [];
         var i:int = 0;
         var z:int = 0;
         y = 0;
         while(y < 4)
         {
            x = 0;
            while(x < 5)
            {
               if(x == 4)
               {
                  z = $m[i + 4];
               }
               else
               {
                  z = 0;
               }
               temp[i + x] = $m[i] * $m2[x] + $m[i + 1] * $m2[x + 5] + $m[i + 2] * $m2[x + 10] + $m[i + 3] * $m2[x + 15] + z;
               x++;
            }
            i = i + 5;
            y++;
         }
         return temp;
      }
      
      private var _matrix:Array;
      
      private var _endMatrix:Array;
      
      private var _cmf:ColorMatrixFilter;
      
      private var _clrsa:Array;
      
      private var _hf:Boolean = false;
      
      private var _filters:Array;
      
      override public function initTweenVals($hrp:Boolean = false, $reservedProps:String = "") : void
      {
         var i:* = 0;
         var fv:Object = null;
         var cmf:Object = null;
         var tp:Object = null;
         this._clrsa = [];
         this._filters = [];
         this._matrix = _idMatrix.slice();
         var $reservedProps:String = $reservedProps + " blurFilter glowFilter colorMatrixFilter dropShadowFilter bevelFilter ";
         if(this.target is DisplayObject)
         {
            if(this.vars.blurFilter != undefined)
            {
               fv = this.vars.blurFilter;
               this.addFilter("blur",fv,BlurFilter,["blurX","blurY","quality"],new BlurFilter(0,0,(fv.quality) || (2)));
            }
            if(this.vars.glowFilter != undefined)
            {
               fv = this.vars.glowFilter;
               this.addFilter("glow",fv,GlowFilter,["alpha","blurX","blurY","color","quality","strength","inner","knockout"],new GlowFilter(16777215,0,0,0,(fv.strength) || (1),(fv.quality) || (2),fv.inner,fv.knockout));
            }
            if(this.vars.colorMatrixFilter != undefined)
            {
               fv = this.vars.colorMatrixFilter;
               cmf = this.addFilter("colorMatrix",fv,ColorMatrixFilter,[],new ColorMatrixFilter(this._matrix));
               this._cmf = cmf.filter;
               this._matrix = ColorMatrixFilter(this._cmf).matrix;
               if((!(fv.matrix == undefined)) && (fv.matrix is Array))
               {
                  this._endMatrix = fv.matrix;
               }
               else
               {
                  if(fv.relative == true)
                  {
                     this._endMatrix = this._matrix.slice();
                  }
                  else
                  {
                     this._endMatrix = _idMatrix.slice();
                  }
                  this._endMatrix = setBrightness(this._endMatrix,fv.brightness);
                  this._endMatrix = setContrast(this._endMatrix,fv.contrast);
                  this._endMatrix = setHue(this._endMatrix,fv.hue);
                  this._endMatrix = setSaturation(this._endMatrix,fv.saturation);
                  this._endMatrix = setThreshold(this._endMatrix,fv.threshold);
                  if(!isNaN(fv.colorize))
                  {
                     this._endMatrix = colorize(this._endMatrix,fv.colorize,fv.amount);
                  }
                  else if(!isNaN(fv.color))
                  {
                     this._endMatrix = colorize(this._endMatrix,fv.color,fv.amount);
                  }
                  
               }
               i = 0;
               while(i < this._endMatrix.length)
               {
                  if((!(this._matrix[i] == this._endMatrix[i])) && (!(this._matrix[i] == undefined)))
                  {
                     this.tweens.push({
                        "o":this._matrix,
                        "p":i.toString(),
                        "s":this._matrix[i],
                        "c":this._endMatrix[i] - this._matrix[i]
                     });
                  }
                  i++;
               }
            }
            if(this.vars.dropShadowFilter != undefined)
            {
               fv = this.vars.dropShadowFilter;
               this.addFilter("dropShadow",fv,DropShadowFilter,["alpha","angle","blurX","blurY","color","distance","quality","strength","inner","knockout","hideObject"],new DropShadowFilter(0,45,0,0,0,0,1,(fv.quality) || (2),fv.inner,fv.knockout,fv.hideObject));
            }
            if(this.vars.bevelFilter != undefined)
            {
               fv = this.vars.bevelFilter;
               this.addFilter("bevel",fv,BevelFilter,["angle","blurX","blurY","distance","highlightAlpha","highlightColor","quality","shadowAlpha","shadowColor","strength"],new BevelFilter(0,0,16777215,0.5,0,0.5,2,2,0,(fv.quality) || (2)));
            }
            if(this.vars.runBackwards == true)
            {
               i = this._clrsa.length - 1;
               while(i > -1)
               {
                  tp = this._clrsa[i];
                  tp.sr = tp.sr + tp.cr;
                  tp.cr = tp.cr * -1;
                  tp.sg = tp.sg + tp.cg;
                  tp.cg = tp.cg * -1;
                  tp.sb = tp.sb + tp.cb;
                  tp.cb = tp.cb * -1;
                  tp.f[tp.p] = tp.sr << 16 | tp.sg << 8 | tp.sb;
                  i--;
               }
            }
            super.initTweenVals(true,$reservedProps);
         }
         else
         {
            super.initTweenVals($hrp,$reservedProps);
         }
      }
      
      private function addFilter($name:String, $fv:Object, $filterType:Class, $props:Array, $defaultFilter:BitmapFilter) : Object
      {
         var i:* = 0;
         var prop:String = null;
         var valChange:* = NaN;
         var begin:Object = null;
         var end:Object = null;
         var f:Object = {"type":$filterType};
         var fltrs:Array = this.target.filters;
         i = 0;
         while(i < fltrs.length)
         {
            if(fltrs[i] is $filterType)
            {
               f.filter = fltrs[i];
               break;
            }
            i++;
         }
         if(f.filter == undefined)
         {
            f.filter = $defaultFilter;
            fltrs.push(f.filter);
            this.target.filters = fltrs;
         }
         i = 0;
         while(i < $props.length)
         {
            prop = $props[i];
            if($fv[prop] != undefined)
            {
               if((prop == "color") || (prop == "highlightColor") || (prop == "shadowColor"))
               {
                  begin = this.HEXtoRGB(f.filter[prop]);
                  end = this.HEXtoRGB($fv[prop]);
                  this._clrsa.push({
                     "f":f.filter,
                     "p":prop,
                     "sr":begin.rb,
                     "cr":end.rb - begin.rb,
                     "sg":begin.gb,
                     "cg":end.gb - begin.gb,
                     "sb":begin.bb,
                     "cb":end.bb - begin.bb
                  });
               }
               else if((prop == "quality") || (prop == "inner") || (prop == "knockout") || (prop == "hideObject"))
               {
                  f.filter[prop] = $fv[prop];
               }
               else
               {
                  if(typeof $fv[prop] == "number")
                  {
                     valChange = $fv[prop] - f.filter[prop];
                  }
                  else
                  {
                     valChange = Number($fv[prop]);
                  }
                  this.tweens.push({
                     "o":f.filter,
                     "p":prop,
                     "s":f.filter[prop],
                     "c":valChange
                  });
               }
               
            }
            i++;
         }
         this._filters.push(f);
         this._hf = true;
         return f;
      }
      
      override public function render($t:uint) : void
      {
         var factor:* = NaN;
         var tp:Object = null;
         var i:* = 0;
         var r:* = NaN;
         var g:* = NaN;
         var b:* = NaN;
         var j:* = 0;
         var f:Array = null;
         var time:Number = ($t - this.startTime) / 1000;
         if(time >= this.duration)
         {
            time = this.duration;
            factor = 1;
         }
         else
         {
            factor = this.vars.ease(time,0,1,this.duration);
         }
         i = this.tweens.length - 1;
         while(i > -1)
         {
            tp = this.tweens[i];
            tp.o[tp.p] = tp.s + factor * tp.c;
            i--;
         }
         if(this._hf)
         {
            i = this._clrsa.length - 1;
            while(i > -1)
            {
               tp = this._clrsa[i];
               r = tp.sr + factor * tp.cr;
               g = tp.sg + factor * tp.cg;
               b = tp.sb + factor * tp.cb;
               tp.f[tp.p] = r << 16 | g << 8 | b;
               i--;
            }
            if(this._cmf != null)
            {
               ColorMatrixFilter(this._cmf).matrix = this._matrix;
            }
            f = this.target.filters;
            i = 0;
            while(i < this._filters.length)
            {
               j = f.length - 1;
               while(j > -1)
               {
                  if(f[j] is this._filters[i].type)
                  {
                     f.splice(j,1,this._filters[i].filter);
                     break;
                  }
                  j--;
               }
               i++;
            }
            this.target.filters = f;
         }
         if(_hst)
         {
            i = _subTweens.length - 1;
            while(i > -1)
            {
               _subTweens[i].proxy(_subTweens[i]);
               i--;
            }
         }
         if(this.vars.onUpdate != null)
         {
            this.vars.onUpdate.apply(this.vars.onUpdateScope,this.vars.onUpdateParams);
         }
         if(time == this.duration)
         {
            super.complete(true);
         }
      }
      
      public function HEXtoRGB($n:Number) : Object
      {
         return {
            "rb":$n >> 16,
            "gb":$n >> 8 & 255,
            "bb":$n & 255
         };
      }
   }
}
