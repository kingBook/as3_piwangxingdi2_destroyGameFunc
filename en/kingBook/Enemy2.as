package kingBook{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import framework.events.FrameworkEvent;
	import framework.UpdateType;
	import g.MyData;
	import g.objs.PathMobileObj;
	import g.objs.PatrolEnemy;
	import interfaces.IEnemy;
	
	/**
	 * 鸟
	 * @author kingBook
	 * 2015/11/2 17:32
	 */
	public class Enemy2 extends PathMobileObj implements IEnemy{
		
		public function Enemy2(){
			super();
		}
		
		override protected function addListeners():void{
			registerUpdateListener(UpdateType.UPDATE_2,update);
			super.addListeners();
		}
		
		override protected function initModelHandler(e:FrameworkEvent):void{
			super.initModelHandler(e);
			_body.SetType(b2Body.b2_dynamicBody);
			_body.SetCustomGravity(new b2Vec2());
			_body.SetSensor(true);
			_body.SetFixedRotation(true);
			if(e.info.axis=="x"){
				_points[0]=new b2Vec2(e.info.min/MyData.pixelToMeter, _body.GetPosition().y);
				_points[1]=new b2Vec2(e.info.max/MyData.pixelToMeter, _body.GetPosition().y);
			}else{
				_points[0]=new b2Vec2(_body.GetPosition().x, e.info.min/MyData.pixelToMeter);
				_points[1]=new b2Vec2(_body.GetPosition().x, e.info.max/MyData.pixelToMeter);
			}
		}
		
		private function update():void{
			var dirX:int=_body.GetLinearVelocity().x>=0?1:-1;
			_view.scaleX=Math.abs(_view.scaleX)*dirX;
		}
		
	};

}