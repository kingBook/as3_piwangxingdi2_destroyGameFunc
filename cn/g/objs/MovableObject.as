package g.objs {
	import framework.events.FrameworkEvent;
	import framework.UpdateType;
	import g.objs.StandardObject;
	/**
	 * 可移动的对象
	 * 有一个刚体，一个视图, 每一帧都同步视图的位置
	 * @author kingBook
	 * 2015-04-16 17:42
	 */
	public class MovableObject extends StandardObject {
		
		public function MovableObject() {
			super();
		}
		
		override protected function addListeners():void {
			registerUpdateListener(UpdateType.UPDATE_2,update);
			super.addListeners();
		}
		
		/** info:{body,view,parent}*/
		override protected function initModelHandler(e:FrameworkEvent):void {
			_body = e.info.body;
			_body.SetUserData({thisObj:this});
			_view = e.info.view;
			if (e.info.parent) e.info.parent.addChild(_view);
			syncView();
		}
		
		private function update():void {
			syncView();
		}
		
	}

}