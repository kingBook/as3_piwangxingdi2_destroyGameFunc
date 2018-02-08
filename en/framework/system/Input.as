package framework.system
{
   public class Input extends Object
   {
      
      public function Input()
      {
         super();
         this._lookup = new Object();
         this._map = new Array(this._total);
      }
      
      public var _lookup:Object;
      
      public var _map:Array;
      
      public const _total:uint = 256;
      
      public function update() : void
      {
         var o:Object = null;
         var i:uint = 0;
         while(i < this._total)
         {
            o = this._map[i++];
            if(o != null)
            {
               if((o.last == -1) && (o.current == -1))
               {
                  o.current = 0;
               }
               else if((o.last == 2) && (o.current == 2))
               {
                  o.current = 1;
               }
               
               o.last = o.current;
            }
         }
      }
      
      public function reset() : void
      {
         var o:Object = null;
         var i:uint = 0;
         while(i < this._total)
         {
            o = this._map[i++];
            if(o != null)
            {
               this[o.name] = false;
               o.current = 0;
               o.last = 0;
            }
         }
      }
      
      public function pressed(Key:String) : Boolean
      {
         return this[Key];
      }
      
      public function justPressed(Key:String) : Boolean
      {
         return this._map[this._lookup[Key]].current == 2;
      }
      
      public function justReleased(Key:String) : Boolean
      {
         return this._map[this._lookup[Key]].current == -1;
      }
      
      public function record() : Array
      {
         var o:Object = null;
         var data:Array = null;
         var i:uint = 0;
         while(i < this._total)
         {
            o = this._map[i++];
            if(!((o == null) || (o.current == 0)))
            {
               if(data == null)
               {
                  data = new Array();
               }
               data.push({
                  "code":i - 1,
                  "value":o.current
               });
            }
         }
         return data;
      }
      
      public function playback(Record:Array) : void
      {
         var o:Object = null;
         var o2:Object = null;
         var i:uint = 0;
         var l:uint = Record.length;
         while(i < l)
         {
            o = Record[i++];
            o2 = this._map[o.code];
            o2.current = o.value;
            if(o.value > 0)
            {
               this[o2.name] = true;
            }
         }
      }
      
      public function getKeyCode(KeyName:String) : int
      {
         return this._lookup[KeyName];
      }
      
      public function any() : Boolean
      {
         var o:Object = null;
         var i:uint = 0;
         while(i < this._total)
         {
            o = this._map[i++];
            if((!(o == null)) && (o.current > 0))
            {
               return true;
            }
         }
         return false;
      }
      
      protected function addKey(KeyName:String, KeyCode:uint) : void
      {
         this._lookup[KeyName] = KeyCode;
         this._map[KeyCode] = {
            "name":KeyName,
            "current":0,
            "last":0
         };
      }
      
      public function destroy() : void
      {
         this._lookup = null;
         this._map = null;
      }
   }
}
