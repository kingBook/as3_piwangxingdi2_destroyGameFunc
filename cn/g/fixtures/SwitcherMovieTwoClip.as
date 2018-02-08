package g.fixtures {
	import Box2D.Common.Math.b2Vec2;
	import flash.display.Sprite;
	import framework.events.FrameworkEvent;
	import framework.objs.Clip;
	import framework.utils.FuncUtil;
	import g.MyData;
	/**
	 * ...
	 * @author kingBook
	 * 2015/10/19 9:22
	 */
	public class SwitcherMovieTwoClip extends SwitcherMovie {
		private var _clipAMask:Sprite;
		private var _clipA:Clip;//主体
		private var _clipB:Clip;//底座
		
		public function SwitcherMovieTwoClip() { super(); }
		
		override protected function initModelHandler(e:FrameworkEvent):void {
			super.initModelHandler(e);
			_clipA=e.info.clipA;
			_clipB=e.info.clipB;
			_clipAMask=e.info.clipAMask;
			
			_clipB.x=_botPos.x*MyData.pixelToMeter;
			_clipB.y=_botPos.y*MyData.pixelToMeter;
			_clipA.mask=_clipAMask;
			syncClipA();
		}
		
		private function syncClipA():void{
			var pos:b2Vec2=_body.GetPosition();
			_clipA.x=pos.x*MyData.pixelToMeter;
			_clipA.y=pos.y*MyData.pixelToMeter;
		}
		
		override protected function updateProgress():void {
			syncClipA();
		}
		
		override public function destroy():void {
			FuncUtil.removeChild(_clipA);
			FuncUtil.removeChild(_clipB);
			FuncUtil.removeChild(_clipAMask);
			_clipAMask=null;
			_clipA=null;
			_clipB=null;
			super.destroy();
		}
		
	}

}