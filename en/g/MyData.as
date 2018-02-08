package g {
	import Box2D.Common.Math.b2Vec2;
	/**
	 * ...
	 * @author kingBook
	 * 2014-10-09 14:54
	 */
	public class MyData{
		public static var isPower:Boolean=false;
		public static var gravity:b2Vec2 = new b2Vec2(0,40);
		public static var deltaTime:Number=30;
		public static var pixelToMeter:Number = 30;
		public static var stageW:Number = 1000;
		public static var stageH:Number = 600;
		public static var frameRate:uint = 32;
		public static var maxLevel:int = 14;
		public static var box2dDebugVisible:Boolean = false;
		public static var useMouseJoint:Boolean = true;
		public static var fpsVisible:Boolean = false;
		public static var unlock:Boolean = true;
		public static var clearLocalData:Boolean = false;
		public static var closeSound:Boolean = false;
		public static var cancelStageMask:Boolean = false;
		public static var cancelFitScreen:Boolean = false;
		public static var linkHomePageFunc:Function = null;
		public static var isRunTimeGame:Boolean = false;
		public static var version:String = "cn";//cn | en
		public function MyData() {
			super();
		}
	}

}