package kingBook{
	import Box2D.Collision.b2Manifold;
	import Box2D.Collision.b2WorldManifold;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2ContactImpulse;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.Contacts.b2ContactEdge;
	import framework.events.FrameworkEvent;
	import framework.UpdateType;
	import g.fixtures.Switcher;
	import g.objs.MovableObject;
	
	/**
	 * 石头
	 * @author kingBook
	 * 2015/11/3 15:35
	 */
	public class Stone extends MovableObject{
		private var _hitEdgeX:int;
		private var _worldManifold:b2WorldManifold=new b2WorldManifold();
		
		public function Stone(){
			super();
		}
		
		override protected function addListeners():void{
			registerUpdateListener(UpdateType.UPDATE_2,update);
			super.addListeners();
		}
		
		override protected function initModelHandler(e:FrameworkEvent):void{
			super.initModelHandler(e);
			_body.SetUserData({thisObj:this, type:"stone"});
			_body.SetPostSolveCallback(postSolve);
			Switcher.AddActiveObj(this);
		}
		
		private function update():void{
			checkHitEdgeX();
			limitVx();
			friction();
			/*if(Math.abs(_body.GetLinearVelocity().x)>1.5){
				playOrStopSound(false);
			}*/
		}
		
		private function limitVx():void{
			var v:b2Vec2=_body.GetLinearVelocity();
			var max:Number=2;
			if(Math.abs(v.x)>=max){
				var sign:int=v.x>0?1:-1;
				v.x=sign*max;
				_body.SetLinearVelocity(v);
			}
		}
		
		protected function checkHitEdgeX():void{
			var hitEdgeX:int=0;
			var ce:b2ContactEdge=_body.GetContactList();
			var contact:b2Contact,b1:b2Body,b2:b2Body,ob:b2Body;
			var nx:Number;
			for(ce; ce; ce=ce.next){
				contact = ce.contact;
				if(!contact.IsTouching())continue;
				if(contact.IsSensor()||!contact.IsEnabled())continue;
				b1=contact.GetFixtureA().GetBody();
				b2=contact.GetFixtureB().GetBody();
				ob=b1==_body?b2:b1;
				if(ob.GetType()==b2Body.b2_dynamicBody)continue;
				contact.GetWorldManifold(_worldManifold);
				nx=_worldManifold.m_normal.x; if(contact.GetFixtureA().GetBody()!=_body)nx=-nx;
				if(Math.abs(nx)>0.8){
					hitEdgeX=nx>0?1:-1;
					break;
				}
			}
			_hitEdgeX=hitEdgeX;
		}
		
		
		private function friction():void{
			var v:b2Vec2=_body.GetLinearVelocity();
			v.x*=0.8;
			_body.SetLinearVelocity(v);
			_body.SetAwake(true);
		}
		
		private function postSolve(contact:b2Contact,impulse:b2ContactImpulse):void{
			if(!contact.IsTouching())return;
			var b1:b2Body=contact.GetFixtureA().GetBody();
			var b2:b2Body=contact.GetFixtureB().GetBody();
			var len:Number=impulse.normalImpulses[0];if(b1!=_body)len=-len;
			if(len<-50){
				_facade.global.shakeMan.shake(0.15,0,5);
				_facade.global.soundMan.play("箱子落地");
			}
		}
		
		override public function destroy():void{
			Switcher.RemoveActiveObj(this);
			super.destroy();
		}
		
		public function get hitEdgeX():int{ return _hitEdgeX; }
	};

}