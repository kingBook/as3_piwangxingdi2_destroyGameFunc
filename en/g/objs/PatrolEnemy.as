package g.objs{
	import Box2D.Collision.b2Manifold;
	import Box2D.Collision.b2WorldManifold;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.Contacts.b2ContactEdge;
	import framework.events.FrameworkEvent;
	import framework.UpdateType;
	import framework.utils.RandomKb;
	import g.MyData;
	import g.MyObj;
	/**
	 * 左右巡逻的敌人
	 * @author kingBook
	 * 2015/11/2 14:24
	 */
	public class PatrolEnemy extends MovableObject{
		
		protected var _min:Number;
		protected var _max:Number;
		protected var _dirX:int;
		protected var _speedX:Number=3;
		protected var _hitEdgeX:int;
		
		public function PatrolEnemy(){
			super();
		}
		
		override protected function addListeners():void{
			registerUpdateListener(UpdateType.UPDATE_2,update);
			super.addListeners();
		}
		
		override protected function initModelHandler(e:FrameworkEvent):void{
			super.initModelHandler(e);
			_min=e.info.min/MyData.pixelToMeter||0;
			_max=e.info.max/MyData.pixelToMeter||1e6;
			_body.SetPreSolveCallback(preSolve);
			_body.SetUserData({ thisObj:this });
			
			_dirX=e.info.dirX||RandomKb.wave;
			_speedX=e.info.speedX||3;
			
		}
		
		private function preSolve(contact:b2Contact,oldManifold:b2Manifold):void{
			if(!contact.IsTouching())return;
			var b1:b2Body=contact.GetFixtureA().GetBody();
			var b2:b2Body=contact.GetFixtureB().GetBody();
			var ob:b2Body=b1==_body?b2:b1;
			var oUserData:*=ob.GetUserData();
			var othis:*=oUserData?oUserData.thisObj:null;
			var type:String=oUserData?oUserData.type:null;
			foreachPreContact(contact,othis,type);
		}
		
		protected function foreachPreContact(contact:b2Contact, othis:*, type:String):void{
			if(type=="ground"||type=="edgeGround"||type=="switcherMovie"){
				
			}else{
				contact.SetEnabled(false);
			}
		}
		
		private function update():void{
			ai();
		}
		
		private function ai():void{
			if(_view)_view.scaleX=Math.abs(_view.scaleX)*_dirX;
			checkHitEdgeX();
			checkChangeDirX();
			walk(_dirX);
		}
		
		private function checkChangeDirX():void{
			var pos:b2Vec2=_body.GetPosition();
			var result:Boolean=false;
			result||=_dirX>0&&pos.x>=_max;
			result||=_dirX<0&&pos.x<=_min;
			result||=_dirX==_hitEdgeX;
			if(result)_dirX=-_dirX;
		}
		
		private function walk(dirX:int):void{
			_body.ApplyImpulse(new b2Vec2(1000*dirX),_body.GetWorldCenter());
			
			var v:b2Vec2=_body.GetLinearVelocity();
			if(Math.abs(v.x)>_speedX){
				v.x=_speedX*dirX;
				_body.SetLinearVelocity(v);
			}
		}
		
		private var _worldManifold:b2WorldManifold=new b2WorldManifold();
		private function checkHitEdgeX():void{
			var hitEdgeX:int=0;
			var ce:b2ContactEdge=_body.GetContactList();
			var contact:b2Contact;
			var nx:Number;
			for(ce; ce; ce=ce.next){
				contact = ce.contact;
				if(!contact.IsTouching())continue;
				if(contact.IsSensor()||!contact.IsEnabled())continue;
				contact.GetWorldManifold(_worldManifold);
				nx=_worldManifold.m_normal.x; if(contact.GetFixtureA().GetBody()!=_body)nx=-nx;
				if(Math.abs(nx)>0.8){
					hitEdgeX=nx>0?1:-1
					break;
				}
			}
			_hitEdgeX=hitEdgeX;
		}
		
		
	};

}