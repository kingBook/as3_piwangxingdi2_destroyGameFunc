package framework.utils
{
   import flash.utils.*;
   
   public class TweenMax extends TweenFilterLite
   {
      
      public function TweenMax($target:Object, $duration:Number, $vars:Object)
      {
         super($target,$duration,$vars);
         this._pauseTime = -1;
         if((TweenFilterLite.version < 7.22) || (isNaN(TweenFilterLite.version)))
         {
            trace("TweenMax error! Please update your TweenFilterLite class or try deleting your ASO files. TweenMax requires a more recent version. Download updates at http://www.TweenMax.com.");
         }
      }
      
      public static var version:Number = 1.32;
      
      protected static const _RAD2DEG:Number = 180 / Math.PI;
      
      public static var killTweensOf:Function = TweenLite.killTweensOf;
      
      public static var killDelayedCallsTo:Function = TweenLite.killDelayedCallsTo;
      
      public static var removeTween:Function = TweenLite.removeTween;
      
      public static var defaultEase:Function = TweenLite.defaultEase;
      
      public static function to($target:Object, $duration:Number, $vars:Object) : TweenMax
      {
         return new TweenMax($target,$duration,$vars);
      }
      
      public static function from($target:Object, $duration:Number, $vars:Object) : TweenMax
      {
         $vars.runBackwards = true;
         return new TweenMax($target,$duration,$vars);
      }
      
      public static function allTo($targets:Array, $duration:Number, $vars:Object) : Array
      {
         var i:* = 0;
         var v:Object = null;
         var p:String = null;
         var dl:* = NaN;
         var lastVars:Object = null;
         if($targets.length == 0)
         {
            return [];
         }
         var a:Array = [];
         var dli:Number = ($vars.delayIncrement) || (0);
         delete $vars.delayIncrement;
         true;
         if($vars.onCompleteAll == undefined)
         {
            lastVars = $vars;
         }
         else
         {
            lastVars = {};
            for(p in $vars)
            {
               lastVars[p] = $vars[p];
            }
            lastVars.onCompleteParams = [[$vars.onComplete,$vars.onCompleteAll],[$vars.onCompleteParams,$vars.onCompleteAllParams]];
            lastVars.onComplete = TweenMax.callbackProxy;
            delete $vars.onCompleteAll;
            true;
         }
         delete $vars.onCompleteAllParams;
         true;
         if(dli == 0)
         {
            i = 0;
            while(i < $targets.length - 1)
            {
               v = {};
               for(p in $vars)
               {
                  v[p] = $vars[p];
               }
               a.push(new TweenMax($targets[i],$duration,v));
               i++;
            }
         }
         else
         {
            dl = ($vars.delay) || (0);
            i = 0;
            while(i < $targets.length - 1)
            {
               v = {};
               for(p in $vars)
               {
                  v[p] = $vars[p];
               }
               v.delay = dl + i * dli;
               a.push(new TweenMax($targets[i],$duration,v));
               i++;
            }
            lastVars.delay = dl + ($targets.length - 1) * dli;
         }
         a.push(new TweenMax($targets[$targets.length - 1],$duration,lastVars));
         return a;
      }
      
      public static function allFrom($targets:Array, $duration:Number, $vars:Object) : Array
      {
         $vars.runBackwards = true;
         return allTo($targets,$duration,$vars);
      }
      
      public static function callbackProxy($functions:Array, $params:Array = null) : void
      {
         var i:uint = 0;
         while(i < $functions.length)
         {
            if($functions[i] != undefined)
            {
               $functions[i].apply(null,$params[i]);
            }
            i++;
         }
      }
      
      public static function sequence($target:Object, $tweens:Array) : Array
      {
         var i:uint = 0;
         while(i < $tweens.length)
         {
            $tweens[i].target = $target;
            i++;
         }
         return multiSequence($tweens);
      }
      
      public static function multiSequence($tweens:Array) : Array
      {
         var tw:Object = null;
         var tgt:Object = null;
         var dl:* = NaN;
         var t:* = NaN;
         var i:uint = 0;
         var o:Object = null;
         var p:String = null;
         var dict:Dictionary = new Dictionary();
         var a:Array = [];
         var totalDelay:Number = 0;
         i = 0;
         while(i < $tweens.length)
         {
            tw = $tweens[i];
            t = (tw.time) || (0);
            o = {};
            for(p in tw)
            {
               o[p] = tw[p];
            }
            delete o.time;
            true;
            dl = (o.delay) || (0);
            o.delay = totalDelay + dl;
            tgt = o.target;
            delete o.target;
            true;
            if(dict[tgt] == undefined)
            {
               if(o.overwrite == undefined)
               {
                  o.overwrite = true;
               }
               dict[tgt] = o;
            }
            else
            {
               o.overwrite = false;
            }
            a.push(new TweenMax(tgt,t,o));
            totalDelay = totalDelay + (t + dl);
            i++;
         }
         return a;
      }
      
      public static function delayedCall($delay:Number, $onComplete:Function, $onCompleteParams:Array = null, $onCompleteScope:* = null) : TweenMax
      {
         return new TweenMax($onComplete,0,{
            "delay":$delay,
            "onComplete":$onComplete,
            "onCompleteParams":$onCompleteParams,
            "onCompleteScope":$onCompleteScope,
            "overwrite":false
         });
      }
      
      public static function parseBeziers($props:Object, $through:Boolean = false) : Object
      {
         var i:* = 0;
         var a:Array = null;
         var b:Object = null;
         var p:String = null;
         var all:Object = {};
         if($through)
         {
            for(p in $props)
            {
               a = $props[p];
               all[p] = b = [];
               if(a.length > 2)
               {
                  b.push({
                     "s":a[0],
                     "cp":a[1] - (a[2] - a[0]) / 4,
                     "e":a[1]
                  });
                  i = 1;
                  while(i < a.length - 1)
                  {
                     b.push({
                        "s":a[i],
                        "cp":a[i] + (a[i] - b[i - 1].cp),
                        "e":a[i + 1]
                     });
                     i++;
                  }
               }
               else
               {
                  b.push({
                     "s":a[0],
                     "cp":(a[0] + a[1]) / 2,
                     "e":a[1]
                  });
               }
            }
         }
         else
         {
            for(p in $props)
            {
               a = $props[p];
               all[p] = b = [];
               if(a.length > 3)
               {
                  b.push({
                     "s":a[0],
                     "cp":a[1],
                     "e":(a[1] + a[2]) / 2
                  });
                  i = 2;
                  while(i < a.length - 2)
                  {
                     b.push({
                        "s":b[i - 2].e,
                        "cp":a[i],
                        "e":(a[i] + a[i + 1]) / 2
                     });
                     i++;
                  }
                  b.push({
                     "s":b[b.length - 1].e,
                     "cp":a[a.length - 2],
                     "e":a[a.length - 1]
                  });
               }
               else if(a.length == 3)
               {
                  b.push({
                     "s":a[0],
                     "cp":a[1],
                     "e":a[2]
                  });
               }
               else if(a.length == 2)
               {
                  b.push({
                     "s":a[0],
                     "cp":(a[0] + a[1]) / 2,
                     "e":a[1]
                  });
               }
               
               
            }
         }
         return all;
      }
      
      public static function getTweensOf($target:Object) : Array
      {
         var p:Object = null;
         var t:Dictionary = _all[$target];
         var a:Array = [];
         if(t != null)
         {
            for(p in t)
            {
               if(t[p].tweens != undefined)
               {
                  a.push(t[p]);
               }
            }
         }
         return a;
      }
      
      public static function isTweening($target:Object) : Boolean
      {
         var a:Array = getTweensOf($target);
         var i:int = a.length - 1;
         while(i > -1)
         {
            if(a[i].active)
            {
               return true;
            }
            i--;
         }
         return false;
      }
      
      public static function getAllTweens() : Array
      {
         var p:Object = null;
         var tw:Object = null;
         var a:Dictionary = _all;
         var all:Array = [];
         for(p in a)
         {
            for(tw in a[p])
            {
               if(a[p][tw] != undefined)
               {
                  all.push(a[p][tw]);
               }
            }
         }
         return all;
      }
      
      public static function killAllTweens($complete:Boolean = false) : void
      {
         killAll($complete,true,false);
      }
      
      public static function killAllDelayedCalls($complete:Boolean = false) : void
      {
         killAll($complete,false,true);
      }
      
      public static function killAll($complete:Boolean = false, $tweens:Boolean = true, $delayedCalls:Boolean = true) : void
      {
         var a:Array = getAllTweens();
         var i:int = a.length - 1;
         while(i > -1)
         {
            if((a[i].target is Function == $delayedCalls) || (!(a[i].target is Function == $tweens)))
            {
               if($complete)
               {
                  a[i].complete();
               }
               else
               {
                  TweenLite.removeTween(a[i]);
               }
            }
            i--;
         }
      }
      
      public static function pauseAll($tweens:Boolean = true, $delayedCalls:Boolean = false) : void
      {
         changePause(true,$tweens,$delayedCalls);
      }
      
      public static function resumeAll($tweens:Boolean = true, $delayedCalls:Boolean = false) : void
      {
         changePause(false,$tweens,$delayedCalls);
      }
      
      public static function changePause($pause:Boolean, $tweens:Boolean = true, $delayedCalls:Boolean = false) : void
      {
         var a:Array = getAllTweens();
         var i:int = a.length - 1;
         while(i > -1)
         {
            if((a[i].target is Function == $delayedCalls) || (!(a[i].target is Function == $tweens)))
            {
               a[i].paused = $pause;
            }
            i--;
         }
      }
      
      public static function hexColorsProxy($o:Object) : void
      {
         $o.info.target[$o.info.prop] = $o.target.r << 16 | $o.target.g << 8 | $o.target.b;
      }
      
      public static function bezierProxy($o:Object) : void
      {
         var i:* = 0;
         var p:String = null;
         var b:Object = null;
         var t:* = NaN;
         var segments:uint = 0;
         var factor:Number = $o.target.t;
         var props:Object = $o.info.props;
         var tg:Object = $o.info.target;
         for(p in props)
         {
            segments = props[p].length;
            if(factor < 0)
            {
               i = 0;
            }
            else if(factor >= 1)
            {
               i = segments - 1;
            }
            else
            {
               i = int(segments * factor);
            }
            
            t = (factor - i * 1 / segments) * segments;
            b = props[p][i];
            tg[p] = b.s + t * (2 * (1 - t) * (b.cp - b.s) + t * (b.e - b.s));
         }
      }
      
      public static function bezierProxy2($o:Object) : void
      {
         var a:* = NaN;
         var dx:* = NaN;
         var dy:* = NaN;
         var cotb:Array = null;
         var toAdd:* = NaN;
         bezierProxy($o);
         var future:Object = {};
         var tg:Object = $o.info.target;
         $o.info.target = future;
         $o.target.t = $o.target.t + 0.01;
         bezierProxy($o);
         var otb:Array = $o.info.orientToBezier;
         var i:uint = 0;
         while(i < otb.length)
         {
            cotb = otb[i];
            toAdd = (cotb[3]) || (0);
            dx = future[cotb[0]] - tg[cotb[0]];
            dy = future[cotb[1]] - tg[cotb[1]];
            tg[cotb[2]] = Math.atan2(dy,dx) * _RAD2DEG + toAdd;
            i++;
         }
         $o.info.target = tg;
         $o.target.t = $o.target.t - 0.01;
      }
      
      protected var _pauseTime:int;
      
      override public function initTweenVals($hrp:Boolean = false, $reservedProps:String = "") : void
      {
         var p:String = null;
         var i:* = 0;
         var curProp:Object = null;
         var props:Object = null;
         var b:Array = null;
         var $reservedProps:String = $reservedProps + " hexColors bezier bezierThrough orientToBezier quaternions onCompleteAll onCompleteAllParams ";
         var bProxy:Function = bezierProxy;
         if(this.vars.orientToBezier == true)
         {
            this.vars.orientToBezier = [["x","y","rotation",0]];
            bProxy = bezierProxy2;
         }
         else if(this.vars.orientToBezier is Array)
         {
            bProxy = bezierProxy2;
         }
         
         if((!(this.vars.bezier == undefined)) && (this.vars.bezier is Array))
         {
            props = {};
            b = this.vars.bezier;
            i = 0;
            while(i < b.length)
            {
               for(p in b[i])
               {
                  if(props[p] == undefined)
                  {
                     props[p] = [this.target[p]];
                  }
                  if(typeof b[i][p] == "number")
                  {
                     props[p].push(b[i][p]);
                  }
                  else
                  {
                     props[p].push(this.target[p] + Number(b[i][p]));
                  }
               }
               i++;
            }
            for(p in props)
            {
               if(typeof this.vars[p] == "number")
               {
                  props[p].push(this.vars[p]);
               }
               else
               {
                  props[p].push(this.target[p] + Number(this.vars[p]));
               }
               delete this.vars[p];
               true;
            }
            addSubTween(bProxy,{"t":0},{"t":1},{
               "props":parseBeziers(props,false),
               "target":this.target,
               "orientToBezier":this.vars.orientToBezier
            });
         }
         if((!(this.vars.bezierThrough == undefined)) && (this.vars.bezierThrough is Array))
         {
            props = {};
            b = this.vars.bezierThrough;
            i = 0;
            while(i < b.length)
            {
               for(p in b[i])
               {
                  if(props[p] == undefined)
                  {
                     props[p] = [this.target[p]];
                  }
                  if(typeof b[i][p] == "number")
                  {
                     props[p].push(b[i][p]);
                  }
                  else
                  {
                     props[p].push(this.target[p] + Number(b[i][p]));
                  }
               }
               i++;
            }
            for(p in props)
            {
               if(typeof this.vars[p] == "number")
               {
                  props[p].push(this.vars[p]);
               }
               else
               {
                  props[p].push(this.target[p] + Number(this.vars[p]));
               }
               delete this.vars[p];
               true;
            }
            addSubTween(bProxy,{"t":0},{"t":1},{
               "props":parseBeziers(props,true),
               "target":this.target,
               "orientToBezier":this.vars.orientToBezier
            });
         }
         if((!(this.vars.hexColors == undefined)) && (typeof this.vars.hexColors == "object"))
         {
            for(p in this.vars.hexColors)
            {
               addSubTween(hexColorsProxy,{
                  "r":this.target[p] >> 16,
                  "g":this.target[p] >> 8 & 255,
                  "b":this.target[p] & 255
               },{
                  "r":this.vars.hexColors[p] >> 16,
                  "g":this.vars.hexColors[p] >> 8 & 255,
                  "b":this.vars.hexColors[p] & 255
               },{
                  "prop":p,
                  "target":this.target
               });
            }
         }
         super.initTweenVals(true,$reservedProps);
      }
      
      public function pause() : void
      {
         if(this._pauseTime == -1)
         {
            this._pauseTime = _curTime;
            _active = false;
         }
      }
      
      public function resume() : void
      {
         var gap:* = NaN;
         if(this._pauseTime != -1)
         {
            gap = _curTime - this._pauseTime;
            this.initTime = this.initTime + gap;
            if(!isNaN(this.startTime))
            {
               this.startTime = this.startTime + gap;
            }
            this._pauseTime = -1;
            if((_curTime - this.initTime) / 1000 > this.delay)
            {
               _active = true;
            }
         }
      }
      
      override public function get active() : Boolean
      {
         if(_active)
         {
            return true;
         }
         if(this._pauseTime != -1)
         {
            return false;
         }
         if((_curTime - this.initTime) / 1000 > this.delay)
         {
            _active = true;
            this.startTime = this.initTime + this.delay * 1000;
            if(!_initted)
            {
               this.initTweenVals();
            }
            else if(this.vars.visible != undefined)
            {
               this.target.visible = true;
            }
            
            if(this.vars.onStart != null)
            {
               this.vars.onStart.apply(null,this.vars.onStartParams);
            }
            if(this.duration == 0.001)
            {
               this.startTime = this.startTime - 1;
            }
            return true;
         }
         return false;
      }
      
      public function get paused() : Boolean
      {
         if(this._pauseTime != -1)
         {
            return true;
         }
         return false;
      }
      
      public function set paused($b:Boolean) : void
      {
         if($b)
         {
            this.pause();
         }
         else
         {
            this.resume();
         }
      }
      
      public function get progress() : Number
      {
         var n:Number = ((_curTime - this.startTime) / 1000 / this.duration) || (0);
         if(n > 1)
         {
            return 1;
         }
         return n;
      }
      
      public function set progress($n:Number) : void
      {
         var t:Number = _curTime - this.duration * $n * 1000;
         this.initTime = t - this.delay * 1000;
         var s:Boolean = this.active;
         this.startTime = t;
         render(_curTime);
      }
   }
}
