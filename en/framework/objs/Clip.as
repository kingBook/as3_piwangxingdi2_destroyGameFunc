package framework.objs
{
   import flash.display.Sprite;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import framework.system.ObjectPool;
   import flash.display.Bitmap;
   import framework.Facade;
   import framework.events.FrameworkEvent;
   import flash.events.Event;
   import framework.UpdateType;
   
   public class Clip extends Sprite
   {
      
      public function Clip(infoList:Vector.<FrameInfo>, addToPool:Boolean = false, removeIsDestroy:Boolean = true, parent:DisplayObjectContainer = null, x:Number = 0, y:Number = 0, name:String = null)
      {
         this._facade = Facade.getInstance();
         super();
         this.x = x;
         this.y = y;
         this.name = name?name:this.name;
         this._addToPool = addToPool;
         this.removeIsDestroy = removeIsDestroy;
         alpha = 1;
         rotation = 0;
         visible = true;
         scaleX = scaleY = 1;
         this._bitmap = new Bitmap();
         addChild(this._bitmap);
         this._curIndex = 0;
         this._maxIndex = -1;
         this._isPlaying = true;
         this.setInfoList(infoList);
         addEventListener(Event.ADDED_TO_STAGE,this.addOrRemoveStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.addOrRemoveStage);
         this._facade.addEventListener(FrameworkEvent.PAUSE,this.pauseResumeHandler);
         this._facade.addEventListener(FrameworkEvent.RESUME,this.pauseResumeHandler);
         parent && parent.addChild(this);
      }
      
      public static function fromDisplayObject(disObj:DisplayObject, poolKey:String = null, removeIsDestroy:Boolean = true, parent:DisplayObjectContainer = null) : Clip
      {
         var infoList:Vector.<FrameInfo> = null;
         var pool:ObjectPool = ObjectPool.getInstance();
         if((poolKey) && (pool.has(poolKey)))
         {
            infoList = pool.get(poolKey) as Vector.<FrameInfo>;
            if(infoList == null)
            {
               throw new Error("对象池中存在: " + poolKey + " 但不是 Vector.<FrameInfo> 类型");
            }
         }
         else
         {
            infoList = Cacher.cacheDisObj(disObj,poolKey);
         }
         return new Clip(infoList,Boolean(poolKey),removeIsDestroy,parent,disObj.x,disObj.y,disObj.name);
      }
      
      public static function fromDefName(defName:String, addToPool:Boolean = false, removeIsDestroy:Boolean = true, parent:DisplayObjectContainer = null, x:Number = 0, y:Number = 0) : Clip
      {
         var infoList:Vector.<FrameInfo> = null;
         var key:String = defName + "_frameInfoList";
         var pool:ObjectPool = ObjectPool.getInstance();
         if((addToPool) && (pool.has(key)))
         {
            infoList = pool.get(key) as Vector.<FrameInfo>;
            if(infoList == null)
            {
               throw new Error("对象池中存在: " + key + " 但不是 Vector.<FrameInfo> 类型");
            }
         }
         else
         {
            infoList = Cacher.cacheDefName(defName,addToPool);
            if(addToPool)
            {
               pool.add(infoList,key);
            }
         }
         return new Clip(infoList,addToPool,removeIsDestroy,parent,x,y,null);
      }
      
      private var _curIndex:int;
      
      private var _maxIndex:int = -1;
      
      private var _bitmap:Bitmap;
      
      private var _infoList:Vector.<FrameInfo>;
      
      private var _isPlaying:Boolean;
      
      private var _addToPool:Boolean;
      
      private var _facade:Facade;
      
      public var controlled:Boolean;
      
      public var isDispatchComplete:Boolean;
      
      public var removeIsDestroy:Boolean;
      
      public var removeIsStop:Boolean = true;
      
      private function pauseResumeHandler(e:FrameworkEvent) : void
      {
         this.controlled || (this._facade.pause?this.stop():this.play());
      }
      
      private function addOrRemoveStage(e:Event) : void
      {
         if(e.type == Event.ADDED_TO_STAGE)
         {
            this._isPlaying = !this.controlled;
            if(this._maxIndex == 0)
            {
               this.gotoFrame(this._curIndex);
            }
            else
            {
               this._maxIndex > -1 && (this._isPlaying?this.updatePlayStatus():this.gotoFrame(this._curIndex));
            }
         }
         else
         {
            this.removeIsStop && this.stop();
            this.removeIsDestroy && this.destroy();
         }
      }
      
      public function play() : void
      {
         this._isPlaying = true;
         this.updatePlayStatus();
      }
      
      public function stop() : void
      {
         this._isPlaying = false;
         this.updatePlayStatus();
      }
      
      private function updatePlayStatus() : void
      {
         if((this._isPlaying) && (this._maxIndex > -1) && (stage))
         {
            this._facade.addUpdateListener(UpdateType.UPDATE_1,this.enterFrame);
         }
         else
         {
            this._facade.removeUpdateListener(UpdateType.UPDATE_1,this.enterFrame);
         }
      }
      
      public function nextFrame() : void
      {
         this.gotoFrame(this._curIndex);
         var funcName:String = "frame" + this._curIndex + "Func";
         if((this._funObj) && (this._funObj[funcName]))
         {
            this._funObj[funcName]();
         }
         this._curIndex == this._maxIndex && this.isDispatchComplete && dispatchEvent(new Event(Event.COMPLETE));
         ++this._curIndex > this._maxIndex && (this._curIndex = 0);
      }
      
      public function gotoAndPlay(frameIndex:int) : void
      {
         this.gotoFrame(frameIndex - 1);
         this.play();
      }
      
      public function gotoAndStop(frameIndex:int) : void
      {
         this.gotoFrame(frameIndex - 1);
         this.stop();
      }
      
      private function enterFrame() : void
      {
         this.nextFrame();
      }
      
      private function gotoFrame(frameIndex:int) : void
      {
         this._curIndex = frameIndex > this._maxIndex?this._maxIndex:frameIndex < 0?0:frameIndex;
         var f_info:FrameInfo = this._infoList[this._curIndex];
         this._bitmap.bitmapData = f_info.bitmapData;
         this._bitmap.x = f_info.x;
         this._bitmap.y = f_info.y;
         this._bitmap.alpha = f_info.alpha;
      }
      
      private var _funObj:*;
      
      public function addFrameScript(frameNo:uint, func:Function) : void
      {
         if(func == null)
         {
            return;
         }
         this._funObj = this._funObj || {};
         this._funObj["frame" + frameNo + "Func"] = func;
      }
      
      public function destroy() : void
      {
         var frameInfo:FrameInfo = null;
         if(!this._addToPool)
         {
            for each(frameInfo in this._infoList)
            {
               if((frameInfo) && (frameInfo.bitmapData))
               {
                  frameInfo.bitmapData.dispose();
               }
            }
         }
         this._facade.removeEventListener(FrameworkEvent.PAUSE,this.pauseResumeHandler);
         this._facade.removeEventListener(FrameworkEvent.RESUME,this.pauseResumeHandler);
         removeEventListener(Event.ADDED_TO_STAGE,this.addOrRemoveStage);
         removeEventListener(Event.REMOVED_FROM_STAGE,this.addOrRemoveStage);
         if(this._bitmap)
         {
            this._bitmap.parent && this._bitmap.parent.removeChild(this._bitmap);
            this._bitmap = null;
         }
         this._funObj = null;
         this._infoList = null;
         this._facade = null;
      }
      
      private function setInfoList(value:Vector.<FrameInfo>) : void
      {
         if(!value)
         {
            return;
         }
         this._infoList = value;
         this._maxIndex = this._infoList.length - 1;
         if(this._maxIndex > -1)
         {
            this.gotoFrame(0);
         }
      }
      
      public function get smoothing() : Boolean
      {
         return this._bitmap.smoothing;
      }
      
      public function set smoothing(value:Boolean) : void
      {
         this._bitmap.smoothing = value;
      }
      
      public function get isPlaying() : Boolean
      {
         return this._isPlaying;
      }
      
      public function get currentFrame() : int
      {
         return this._curIndex + 1;
      }
      
      public function get totalFrames() : int
      {
         return this._infoList?this._infoList.length:0;
      }
   }
}
import flash.geom.Point;
import flash.display.DisplayObject;
import flash.geom.Matrix;
import flash.geom.Rectangle;
import flash.display.BitmapData;
import framework.system.ObjectPool;
import flash.display.MovieClip;
import framework.utils.LibUtil;

class Cacher extends Object
{
   
   function Cacher()
   {
      super();
   }
   
   private static const _pt:Point = new Point(0,0);
   
   private static function cacheSingle(source:DisplayObject, poolKey:String = null, transparent:Boolean = true, fillColor:uint = 0, scale:Number = 1) : FrameInfo
   {
      var frameInfo:FrameInfo = null;
      var matrix:Matrix = null;
      var w:uint = 0;
      var h:uint = 0;
      var x:* = 0;
      var y:* = 0;
      var rect:Rectangle = null;
      var bitData:BitmapData = null;
      var realRect:Rectangle = null;
      var realBitData:BitmapData = null;
      var pool:ObjectPool = ObjectPool.getInstance();
      if((poolKey) && (pool.has(poolKey)))
      {
         frameInfo = pool.get(poolKey) as FrameInfo;
         if(frameInfo == null)
         {
            throw new Error("对象池中存在: " + poolKey + " 但不是 FrameInfo 类型");
         }
      }
      else
      {
         matrix = source.transform.matrix.clone();
         if(source.parent)
         {
            rect = source.getBounds(source.parent);
            matrix.a = matrix.a * scale;
            matrix.d = matrix.d * scale;
            matrix.tx = int((matrix.tx - rect.x) * scale + 0.5);
            matrix.ty = int((matrix.ty - rect.y) * scale + 0.5);
         }
         else
         {
            rect = source.getBounds(null);
            matrix.a = scale;
            matrix.d = scale;
            matrix.tx = -int(rect.x * scale + 0.5);
            matrix.ty = -int(rect.y * scale + 0.5);
         }
         w = uint(rect.width * scale + 0.9);
         h = uint(rect.height * scale + 0.9);
         x = -matrix.tx;
         y = -matrix.ty;
         bitData = new BitmapData(w < 1?1:w,h < 1?1:h,transparent,fillColor);
         bitData.draw(source,matrix,null,null,null,true);
         realRect = bitData.getColorBoundsRect(4.27819008E9,0,false);
         if((!realRect.isEmpty()) && ((!(bitData.width == realRect.width)) || (!(bitData.height == realRect.height))))
         {
            realBitData = new BitmapData(realRect.width,realRect.height,transparent,fillColor);
            realBitData.copyPixels(bitData,realRect,_pt);
            bitData.dispose();
            bitData = realBitData;
            x = x + realRect.x;
            y = y + realRect.y;
         }
         frameInfo = new FrameInfo(bitData,x,y,source.alpha);
         if(poolKey)
         {
            pool.add(frameInfo,poolKey);
         }
      }
      return frameInfo;
   }
   
   public static function cacheDisObj(source:DisplayObject, poolKey:String = null, transparent:Boolean = true, fillColor:uint = 0, scale:Number = 1) : Vector.<FrameInfo>
   {
      var v_bitInfo:Vector.<FrameInfo> = null;
      var i:* = 0;
      var c:* = 0;
      var frameNoKey:String = null;
      var mc:MovieClip = source as MovieClip;
      if(!mc)
      {
         v_bitInfo = new Vector.<FrameInfo>(1,true);
         v_bitInfo[0] = cacheSingle(source,poolKey,transparent,fillColor,scale);
      }
      else
      {
         i = 0;
         c = mc.totalFrames;
         mc.gotoAndStop(1);
         v_bitInfo = new Vector.<FrameInfo>(c,true);
         while(i < c)
         {
            frameNoKey = poolKey?poolKey + "_frameNo_" + i:null;
            v_bitInfo[i] = cacheSingle(mc,frameNoKey,transparent,fillColor,scale);
            mc.nextFrame();
            i++;
         }
      }
      return v_bitInfo;
   }
   
   public static function cacheDefName(defName:String, addToPool:Boolean = false, transparent:Boolean = true, fillColor:uint = 0, scale:Number = 1) : Vector.<FrameInfo>
   {
      var infoList:Vector.<FrameInfo> = null;
      var disObj:DisplayObject = LibUtil.getDefDisObj(defName);
      if(disObj)
      {
         infoList = cacheDisObj(disObj);
      }
      return infoList;
   }
}
import flash.display.BitmapData;

class FrameInfo extends Object
{
   
   function FrameInfo(bitmapData:BitmapData, x:Number = 0, y:Number = 0, alpha:Number = 0)
   {
      super();
      this.bitmapData = bitmapData;
      this.x = x;
      this.y = y;
      this.alpha = alpha;
   }
   
   public var x:Number;
   
   public var y:Number;
   
   public var alpha:Number;
   
   public var bitmapData:BitmapData;
}
