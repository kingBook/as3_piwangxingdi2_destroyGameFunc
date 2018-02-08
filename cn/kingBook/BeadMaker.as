package kingBook{
	import framework.events.FrameworkEvent;
	import framework.utils.TweenMax;
	import g.MyObj;
	
	/**
	 * 水滴制造者
	 * @author kingBook
	 * 2015/11/3 10:27
	 */
	public class BeadMaker extends MyObj{
		
		private var _x:Number;
		private var _y:Number;
		private var _dy:Number;
		
		public function BeadMaker(){
			super();
		}
		
		override protected function initModelHandler(e:FrameworkEvent):void{
			_x=e.info.x;
			_y=e.info.y;
			_dy=e.info.dy;
			make();
		}
		
		private function make():void{
			_isDelaying=false;
			ObjectFactory.instance.createBead(_x,_y,_dy,this);
		}
		
		private var _isDelaying:Boolean;
		public function addMakeDelayTime():void{
			if(_isDelaying)return;
			_isDelaying=true;
			TweenMax.delayedCall(1,make);
		}
		
		override public function destroy():void{
			TweenMax.killDelayedCallsTo(make);
			super.destroy();
		}
	};

}