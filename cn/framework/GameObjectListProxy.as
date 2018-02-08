package framework
{
   import framework.objs.GameObject;
   
   public class GameObjectListProxy extends Object
   {
      
      public function GameObjectListProxy()
      {
         super();
         this._gameObjectlist = {};
      }
      
      private var _gameObjectlist:*;
      
      public function addGameObject(key:String, gameObject:GameObject) : void
      {
         this._gameObjectlist[key] = this._gameObjectlist[key] || new Vector.<GameObject>();
         this._gameObjectlist[key].push(gameObject);
      }
      
      public function removeGameObject(key:String, gameObject:GameObject) : void
      {
         var list:Vector.<GameObject> = this._gameObjectlist[key];
         list.splice(list.indexOf(gameObject),1);
         if(list.length == 0)
         {
            delete this._gameObjectlist[key];
            true;
         }
      }
      
      public function getGameObjectList(key:String) : Vector.<GameObject>
      {
         return this._gameObjectlist[key];
      }
      
      public function getGameObjectListToArray(key:String) : Array
      {
         var list:Vector.<GameObject> = this.getGameObjectList(key);
         var len:int = list.length;
         var arr:Array = [];
         var i:int = 0;
         while(i < len)
         {
            arr[i] = list[i];
            i++;
         }
         return arr;
      }
   }
}
