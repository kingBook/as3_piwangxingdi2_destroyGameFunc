package framework.system
{
   import flash.display.BitmapData;
   import flash.utils.Dictionary;
   import framework.namespaces.frameworkInternal;
   use namespace frameworkInternal;
   
   public class ObjectPool extends Object
   {
      
      public function ObjectPool(single:Single)
      {
         super();
         if(!single)
         {
            throw new Error("只能通过ObjectPool.getInstance()方法返回实例");
         }
         else
         {
            this._dict = new Dictionary(true);
            return;
         }
      }
      
      private static var _instance:ObjectPool;
      
      public static function getInstance() : ObjectPool
      {
         return _instance = _instance || new ObjectPool(new Single());
      }
      
      private var _dict:Dictionary;
      
      public function add(obj:Object, key:* = null) : void
      {
         if(key)
         {
            if(!this.has(key))
            {
               this._dict[key] = obj;
            }
            else
            {
               this.error(key);
            }
         }
         else if(!this.has(obj))
         {
            this._dict[obj] = obj;
         }
         else
         {
            this.error(obj);
         }
         
      }
      
      private function error(key:*) : void
      {
         throw new Error(key + "已经存在对象池中!");
      }
      
      public function remove(key:*) : void
      {
         if(this.has(key))
         {
            delete this._dict[key];
            true;
         }
      }
	  
	  frameworkInternal function onDestroy():void{
		  if(_dict){
			  for each(var obj:* in _dict){
				  if(obj is BitmapData){
						var bmd:BitmapData=obj as BitmapData;
						if(bmd)bmd.dispose();
				  }
			  }
			  _dict=null;
		  }
		  _instance=null;
		  _dict=null;
	  }
      
      public function get(key:*) : *
      {
         if(this.has(key))
         {
            return this._dict[key];
         }
         return null;
      }
      
      public function has(key:*) : Boolean
      {
         return this._dict[key];
      }
      
      public function clear() : void
      {
         var k:* = undefined;
         for(k in this._dict)
         {
            delete this._dict[k];
            true;
         }
      }
   }
}
class Single extends Object
{
   
   function Single()
   {
      super();
   }
}
