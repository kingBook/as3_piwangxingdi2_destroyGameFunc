package framework.utils
{
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.FrameLabel;
   import flash.utils.ByteArray;
   import flash.display.BitmapData;
   import flash.utils.getQualifiedClassName;
   import flash.utils.getDefinitionByName;
   
   public class FuncUtil extends Object
   {
      
      public function FuncUtil()
      {
         super();
      }
      
      private static var _standardMat:Matrix = new Matrix(1,0,0,1,0,0);
      
      private static var _stageRect:Rectangle;
      
      public static function removeChild(obj:DisplayObject) : void
      {
         obj && obj.parent && obj.parent.removeChild(obj);
      }
      
      public static function getTransformWidth(obj:DisplayObject) : Number
      {
         var recordMat:Matrix = obj.transform.matrix;
         obj.transform.matrix = _standardMat;
         var w:Number = obj.width;
         obj.transform.matrix = recordMat;
         w = w * obj.scaleX;
         return Math.abs(w);
      }
      
      public static function getTransformHeight(obj:DisplayObject) : Number
      {
         var recordMat:Matrix = obj.transform.matrix;
         obj.transform.matrix = _standardMat;
         var h:Number = obj.height;
         obj.transform.matrix = recordMat;
         h = h * obj.scaleY;
         return Math.abs(h);
      }
      
      public static function getDisObjStandardWH(disObj:DisplayObject) : Point
      {
         var mat:Matrix = disObj.transform.matrix;
         disObj.transform.matrix = _standardMat;
         var w:Number = disObj.width;
         var h:Number = disObj.height;
         disObj.transform.matrix = mat;
         return new Point(w,h);
      }
      
      public static function addToList(obj:*, list:*) : void
      {
         if(!obj)
         {
            return;
         }
         if(!list)
         {
            throw new Error("list不能为 null");
         }
         else
         {
            if(list.indexOf(obj) < 0)
            {
               list.push(obj);
            }
            return;
         }
      }
      
      public static function removeFromList(obj:*, list:*) : void
      {
         if(!obj)
         {
            return;
         }
         if(!list)
         {
            return;
         }
         var index:int = list.indexOf(obj);
         if(index > -1)
         {
            list.splice(index,1);
         }
      }
      
      public static function randomArr(arr:Array) : Array
      {
         if(!arr)
         {
            throw new Error("参数arr不能为null~~!");
         }
         else
         {
            var sourceArr:Array = arr.slice();
            var tmpArr:Array = [];
            var i:int = sourceArr.length;
            while(--i >= 0)
            {
               tmpArr = tmpArr.concat(sourceArr.splice(Math.random() * sourceArr.length >> 0,1));
            }
            return tmpArr;
         }
      }
      
      public static function stopMovie(o:DisplayObjectContainer) : void
      {
         if(!o)
         {
            return;
         }
         if(o is MovieClip)
         {
            (o as MovieClip).stop();
         }
         var i:int = o.numChildren;
         while(--i >= 0)
         {
            stopMovie(o.getChildAt(i) as DisplayObjectContainer);
         }
      }
      
      public static function restMovie(o:DisplayObjectContainer) : void
      {
         if(!o)
         {
            return;
         }
         if(o is MovieClip)
         {
            (o as MovieClip).play();
         }
         var i:uint = o.numChildren;
         while(--i >= 0)
         {
            restMovie(o.getChildAt(i) as DisplayObjectContainer);
         }
      }
      
      public static function removeChildList(list:*) : void
      {
         var o:DisplayObject = null;
         if(!list)
         {
            return;
         }
         for each(o in list)
         {
            removeChild(o);
         }
      }
      
      public static function getLabelToFrame(mc:MovieClip, labelName:String) : int
      {
         var curLabel:FrameLabel = null;
         var labels:Array = mc.currentLabels;
         var len:int = labels.length;
         var i:int = 0;
         while(i < len)
         {
            curLabel = labels[i];
            if(curLabel.name == labelName)
            {
               return curLabel.frame;
            }
            i++;
         }
         throw new Error("在mc中没有找到贴标签： ",labelName);
      }
      
      public static function deepClone(obj:Object) : Object
      {
         var byArr:ByteArray = new ByteArray();
         byArr.writeObject(obj);
         byArr.position = 0;
         return byArr.readObject();
      }
      
      public static function globalXY(disObj:DisplayObject, pt:Point = null) : Point
      {
         var cpt:Point = null;
         if(!disObj)
         {
            throw new Error("FuncUtil->globalXY() 参数disObj不能为null");
         }
         else if(!disObj.parent)
         {
            throw new Error("FuncUtil->globalXY()传进的对象不在显示列表!");
         }
         else
         {
            if(pt)
            {
               cpt = pt;
            }
            else
            {
               cpt = new Point(disObj.x,disObj.y);
            }
            var gpt:Point = disObj.localToGlobal(cpt);
            return gpt;
         }
         
      }
      
      private static var _pt:Point = new Point(0,0);
      
      public static function localXY(disObj:DisplayObject, targetCoordinateSpace:DisplayObject) : Point
      {
         if(!disObj)
         {
            throw new Error("FuncUtil->localXY() 参数disObj不能为null");
         }
         else if(!targetCoordinateSpace)
         {
            throw new Error("FuncUtil->localXY() 参数container不能为null");
         }
         else
         {
            var gpt:Point = globalXY(disObj,_pt);
            var lpt:Point = targetCoordinateSpace.globalToLocal(gpt);
            return lpt;
         }
         
      }
      
      public static function localXY_2(gpt:Point, targetCoordinateSpace:DisplayObject) : Point
      {
         var lpt:Point = targetCoordinateSpace.globalToLocal(gpt);
         return lpt;
      }
      
      public static function rotate(obj:DisplayObject, angle:Number) : void
      {
         if(!obj)
         {
            trace("warning: 参数obj为null!");
            return;
         }
         var x:Number = obj.x;
         var y:Number = obj.y;
         var mat:Matrix = obj.transform.matrix;
         mat.tx = 0;
         mat.ty = 0;
         mat.rotate(angle * Math.PI / 180);
         mat.translate(x,y);
         obj.transform.matrix = mat;
      }
      
      public static function objInStage(disObj:DisplayObject, stageW:Number = 640, stageH:Number = 480) : Boolean
      {
         if(!disObj)
         {
            return false;
         }
         if(!disObj.stage)
         {
            return false;
         }
         var rect1:Rectangle = disObj.getBounds(disObj.stage);
         _stageRect = _stageRect || new Rectangle();
         _stageRect.width = stageW;
         _stageRect.height = stageH;
         if(rect1.intersects(_stageRect))
         {
            return true;
         }
         return false;
      }
      
      public static function stageContainsObj(disObj:DisplayObject, stageW:Number = 640, stageH:Number = 480) : Boolean
      {
         if(!disObj)
         {
            return false;
         }
         if(!disObj.stage)
         {
            return false;
         }
         var rect1:Rectangle = disObj.getBounds(disObj.stage);
         _stageRect = _stageRect || new Rectangle();
         _stageRect.width = stageW;
         _stageRect.height = stageH;
         if(_stageRect.containsRect(rect1))
         {
            return true;
         }
         return false;
      }
      
      public static function stageContainsRect(rect2:Rectangle, stageW:Number = 640, stageH:Number = 480) : Boolean
      {
         _stageRect = _stageRect || new Rectangle();
         _stageRect.width = stageW;
         _stageRect.height = stageH;
         return _stageRect.containsRect(rect2);
      }
      
      public static function stageContainsPt(pt:Point, stageW:Number = 640, stageH:Number = 480) : Boolean
      {
         _stageRect = _stageRect || new Rectangle();
         _stageRect.width = stageW;
         _stageRect.height = stageH;
         return _stageRect.containsPoint(pt);
      }
      
      public static function getPlayMovieMsec(totalFrames:uint, fps:uint = 30) : Number
      {
         return 1000 / fps * totalFrames;
      }
      
      public static function getPlayMovieSecond(totalFrames:uint, fps:uint = 30) : Number
      {
         return 1 / fps * totalFrames;
      }
      
      public static function disposeBmdList(list:*) : void
      {
         if((!list) || (!list.length))
         {
            return;
         }
         if((!(list is Array)) && (!(list is Vector.<BitmapData>)))
         {
            return;
         }
         var i:uint = list.length;
         while(--i >= 0)
         {
            list[i] && list[i].dispose();
         }
      }
      
      public static function addChildListToContainer(list:*, c:DisplayObjectContainer) : void
      {
         var o:DisplayObject = null;
         if((!list) || (!c))
         {
            return;
         }
         for each(o in list)
         {
            c.addChild(o);
         }
      }
      
      public static function foreach(arr:Array, ... params) : void
      {
         var i:int = arr.length;
         while(--i >= 0)
         {
            if(arr[i] == null)
            {
               arr.splice(i,1);
            }
            else
            {
               arr[i].apply(null,params);
            }
         }
      }
      
      public static function duplicateDefObj(defObj:*) : *
      {
         var name:String = getQualifiedClassName(defObj);
         var _Class:Class = getDefinitionByName(name) as Class;
         var duplicateO:* = new _Class();
         if((duplicateO.transform) && (defObj.transform))
         {
            duplicateO.transform = defObj.transform;
         }
         return duplicateO;
      }
   }
}
