package g {
	import flash.events.Event;
	import framework.events.FrameworkEvent;
	
	/**
	 * ...
	 * @author kingBook
	 * 2014-10-09 15:20
	 */
	public class MyEvent extends FrameworkEvent {
		
		public static const TO_TITLE:String = "toTitle";
		public static const TO_SELECT_LEVEL:String = "toSelectLevel";
		public static const TO_HELP:String = "toHelp";
		public static const GO_TO_LEVEL:String = "gotoLevel";
		public static const NEXT_LEVEL:String = "nextLevel";
		public static const RESET_LEVEL:String = "resetLevel";
		public static const WIN:String = "win";
		public static const FAILURE:String = "failure";
		
		public static const CREATE_MAP_COMPLETE:String = "createMapComplete";
		public static const UPDATE_MAP_BODIES:String = "updateMapBodies";
		public static const UPDATE_BITMAP_DATA:String = "updateBitmapData";
		public static const RESET_BITMAP_POSITION:String = "resetBitmapPosition";
		public static const CREATE_ITEMS:String = "createItems";
		
		public function MyEvent(type:String, info:*=null, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, info, bubbles, cancelable);
		}
		override public function clone():Event {
			return new MyEvent(type,info,bubbles,cancelable);
		}
		override public function toString():String { 
			return formatToString("MyEvent", "type", "info", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}

}