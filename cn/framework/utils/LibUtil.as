package framework.utils
{
   import flash.system.ApplicationDomain;
   import framework.system.ObjectPool;
   import flash.display.MovieClip;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   public class LibUtil extends Object
   {
      
      public function LibUtil()
      {
         super();
      }
      
      public static function getClass(defName:String) : Class
      {
         var c:Class = null;
         var curDomain:ApplicationDomain = ApplicationDomain.currentDomain;
         if(curDomain.hasDefinition(defName))
         {
            c = curDomain.getDefinition(defName) as Class;
         }
         else
         {
            trace("警告：无法获取类：" + defName,"请确认类名正确，检查类所在的fla是否发布swf,swf是否正确嵌入");
         }
         return c;
      }
      
      public static function getDefObj(defName:String, addToPool:Boolean = false) : *
      {
         var obj:* = undefined;
         var pool:ObjectPool = ObjectPool.getInstance();
         if(addToPool)
         {
            if(pool.has(defName))
            {
               obj = pool.get(defName);
            }
            else
            {
               obj = getNewClass(defName);
               pool.add(obj,defName);
            }
         }
         else
         {
            obj = getNewClass(defName);
         }
         return obj;
      }
      
      private static function getNewClass(defName:String) : *
      {
         var __O:Class = getClass(defName);
         var obj:* = __O?new __O():null;
         return obj;
      }
      
      public static function getDefMovie(defName:String, addToPool:Boolean = false) : MovieClip
      {
         return getDefObj(defName,addToPool) as MovieClip;
      }
      
      public static function getDefDisObj(defName:String, addToPool:Boolean = false) : DisplayObject
      {
         return getDefObj(defName,addToPool) as DisplayObject;
      }
      
      public static function getDefSprite(defName:String, addToPool:Boolean = false) : Sprite
      {
         return getDefObj(defName,addToPool) as Sprite;
      }
   }
}
