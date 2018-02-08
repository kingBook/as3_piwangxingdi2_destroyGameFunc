package g.objs{
	import flash.display.DisplayObject;
	import framework.events.FrameworkEvent;
	import framework.objs.GameObject;
	import framework.utils.FuncUtil;
	import framework.utils.TweenMax;
	
	/**
	 * 浮动向上消失
	 * @author kingBook
	 * 2015/11/5 10:46
	 */
	public class FloatingEffect extends GameObject{
		private var _view:DisplayObject;
		public function FloatingEffect(){
			super();
		}
		
		override protected function initModelHandler(e:FrameworkEvent):void{
			_view=e.info.view;
			TweenMax.to(_view, 0.5, { y:_view.y - 30, overwrite:0 } );
			TweenMax.to(_view, 1.5, { autoAlpha:0, delay:0.5, onComplete:destroy, overwrite:0 } );
		}
		
		private var _isDestroy:Boolean;
		override public function destroy():void{
			if(_isDestroy)return;
			_isDestroy=true;
			TweenMax.killTweensOf(_view);
			FuncUtil.removeChild(_view);
			_view=null;
			super.destroy();
		}
		
	};

}