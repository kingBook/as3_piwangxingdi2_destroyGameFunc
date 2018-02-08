package g.fixtures {
	import Box2D.Common.Math.b2Vec2;
	import framework.events.FrameworkEvent;
	import framework.objs.Clip;
	import framework.utils.FuncUtil;
	/**
	 * ...
	 * @author kingBook
	 * 2015/10/19 9:23
	 */
	public class SwitcherMovieOneClip extends SwitcherMovie{
		private var _clip:Clip;
		
		public function SwitcherMovieOneClip() { super(); }
		
		override protected function initModelHandler(e:FrameworkEvent):void {
			super.initModelHandler(e);
			_clip=e.info.clip;
			_clip.controlled=true;
			_clip.gotoAndStop(_isOpen?_clip.totalFrames:1);
		}
		
		override protected function updateProgress():void {
			var d:Number=b2Vec2.Distance(_body.GetPosition(),_isOpen?_maxPos:_minPos);
			var rate:Number=d/_long; if(_isOpen)rate=1-rate;
			var frame:Number=int(_clip.totalFrames*rate);
			if(frame<1)frame=1; else if(frame>_clip.totalFrames)frame=_clip.totalFrames;
			_clip.gotoAndStop(frame);
		}
		
		override public function destroy():void {
			FuncUtil.removeChild(_clip);
			_clip=null;
			super.destroy();
		}
		
	}

}