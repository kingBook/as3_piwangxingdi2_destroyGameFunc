package g {
	import framework.utils.TweenMax;
	import framework.events.FrameworkEvent;
	import framework.objs.GameObject;
	
	/**
	 * 延时发出一个EXECUTE事件
	 * @author ...
	 * 2014-10-26 21:08
	 */
	public class Delayer extends GameObject {
		public static const EXECUTE:String = "execute";
		private var _executeEvent:MyEvent = new MyEvent(EXECUTE);
		private var _delay:Number;
		public function Delayer() {
			super();
		}
		
		/**info{delay:1}*/
		override protected function initModelHandler(e:FrameworkEvent):void {
			_delay = e.info.delay||1;
			addDelay();
		}
		
		private function addDelay():void {
			TweenMax.delayedCall(_delay, delayed);
		}
		
		private function delayed():void {
			dispatchEvent(_executeEvent);
			addDelay();
		}
		
		private var _isDestroy:Boolean = false;
		override public function destroy():void {
			if (_isDestroy) return;
			_isDestroy = true;
			TweenMax.killDelayedCallsTo(delayed);
			_executeEvent = null;
			super.destroy();
		}
		
	}

}