package g.objs {
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import framework.events.FrameworkEvent;
	import framework.utils.FuncUtil;
	import g.MyData;
	import g.MyObj;
	/**
	 * 有一个刚体，一个视图
	 * @author kingBook
	 * 2014-10-15 9:51
	 */
	public class StandardObject extends MyObj {
		protected var _body:b2Body;
		protected var _view:DisplayObject;
		
		public function StandardObject() {
			super();
		}
		
		override protected function initModelHandler(e:FrameworkEvent):void {
			_body = e.info.body;
			_body.SetUserData({thisObj:this});
			
			_view = e.info.view;
			var parent:DisplayObjectContainer = e.info.parent;
			parent && parent.addChild(_view);
			syncView();
		}
		
		//子类调同步
		protected function syncView():void {
			if (_view) {
				var pos:b2Vec2 = _body.GetPosition(); 
				_view.x = pos.x*MyData.pixelToMeter;
				_view.y = pos.y*MyData.pixelToMeter;
				_view.rotation = (_body.GetAngle() * 57.3) % 360;
			}
		}
		
		override public function destroy():void {
			if (_view)_view.filters = null;
			FuncUtil.removeChild(_view);
			_facade.global.curWorld.DestroyBody(_body);
			_view = null;
			_body = null;
			super.destroy();
		}
	}

}