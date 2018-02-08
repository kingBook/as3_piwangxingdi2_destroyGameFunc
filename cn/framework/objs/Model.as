package framework.objs
{
   public class Model extends Member
   {
      
      public function Model()
      {
         super();
      }
      
      override public function destroy() : void
      {
         super.destroy();
         _facade.removeModel(_id);
         _facade = null;
      }
   }
}
