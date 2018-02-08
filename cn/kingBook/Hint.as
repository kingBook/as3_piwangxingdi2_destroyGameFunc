package kingBook{
	import Box2D.Dynamics.b2Body;
	import framework.events.FrameworkEvent;
	import g.objs.StandardObject;
	
	/**
	 * 第一关的提示
	 * @author kingBook
	 * 2015/11/6 10:31
	 */
	public class Hint extends StandardObject{
		private var _name:String;
		public function Hint(){
			super();
		}
		
		override protected function initModelHandler(e:FrameworkEvent):void{
			super.initModelHandler(e);
			_name=e.info.name;
			_body.SetType(b2Body.b2_staticBody);
			_body.SetSensor(true);
			_body.SetUserData({thisObj:this});
		}
		
		public function get name():String{ return _name; }
	};

}