package framework.system
{
   import flash.net.SharedObject;
   
   public class LocalManager extends Object
   {
      
      public function LocalManager()
      {
         super();
         this._so = SharedObject.getLocal(this._FILE_NAME);
      }
      
      private const _FILE_NAME:String = "kingBookGameLocalFile";
      
      private var _so:SharedObject;
      
      public function clear() : void
      {
         this._so.clear();
      }
      
      public function save(key:String, data:*) : void
      {
         this._so.data[key] = data;
         this._so.flush();
      }
      
      public function get(key:String) : *
      {
         return this._so.data[key];
      }
   }
}
