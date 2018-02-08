package framework.system
{
   public class ScorllMode extends Object
   {
      
      public function ScorllMode(name:String)
      {
         super();
         this._name = name;
      }
      
      private static var _targetCenterX:ScorllMode;
      
      private static var _targetCenterY:ScorllMode;
      
      private static var _targetCenter:ScorllMode;
      
      private static var _coustomVelocity:ScorllMode;
      
      public static function get TARGET_CENTER_X() : ScorllMode
      {
         return _targetCenterX = _targetCenterX || new ScorllMode("targetCenterX");
      }
      
      public static function get TARGET_CENTER_Y() : ScorllMode
      {
         return _targetCenterY = _targetCenterY || new ScorllMode("targetCenterY");
      }
      
      public static function get TARGET_CENTER() : ScorllMode
      {
         return _targetCenter = _targetCenter || new ScorllMode("targetCenter");
      }
      
      public static function get COUSTOM_VELOCITY() : ScorllMode
      {
         return _coustomVelocity = _coustomVelocity || new ScorllMode("customVelocity");
      }
      
      private var _name:String;
      
      public function toString() : String
      {
         return this._name;
      }
   }
}
