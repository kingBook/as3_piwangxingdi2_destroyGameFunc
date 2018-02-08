package kingBook{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.Contacts.b2ContactEdge;
	import framework.events.FrameworkEvent;
	import framework.objs.Clip;
	import framework.UpdateType;
	import framework.utils.Box2dUtil;
	import g.Animator;
	import g.MyData;
	import g.MyObj;
	
	/**
	 * 水滴
	 * @author kingBook
	 * 2015/11/3 9:13
	 */
	public class Bead extends MyObj{
		private var _body:b2Body;
		private var _dy:Number;
		private var _speed:Number=2.5;
		private var _y0:Number;
		private var _isBroken:Boolean;
		private var _scale:Number=1;
		private var _radius:Number=15/MyData.pixelToMeter;
		
		private var _maker:BeadMaker;
		private var _animator:Animator;
		
		public function Bead(){
			super();
		}
		
		override protected function addListeners():void{
			registerUpdateListener(UpdateType.UPDATE_2,update);
			super.addListeners();
		}
		
		override protected function initModelHandler(e:FrameworkEvent):void{
			_dy=e.info.dy/MyData.pixelToMeter;
			_maker=e.info.maker;
			
			_body=Box2dUtil.createCircle(_radius,e.info.x,e.info.y,_facade.global.curWorld,MyData.pixelToMeter);
			_body.SetSensor(true);
			_body.SetUserData({thisObj:this,type:"bead"});
			_body.SetCustomGravity(new b2Vec2());
			_body.SetLinearVelocity(new b2Vec2(0,-_speed));
			
			_y0=_body.GetPosition().y;
			
			_animator=new Animator(_facade,_facade.global.layerMan.items1Layer);
			_animator.addAnimation("idle",Clip.fromDefName("Bead_idle",true));
			
			var clip:Clip=Clip.fromDefName("Bead_broken",true);
			clip.addFrameScript(clip.totalFrames-1,destroy);
			_animator.addAnimation("broken",clip);
			_animator.setDefaultAnimation("idle");
			_animator.addTransitionCondition(null,"idle",function():Boolean{ return !_isBroken; });
			_animator.addTransitionCondition(null,"broken",function():Boolean{ return _isBroken; });
			
			scaleHandler(0.4);
			syncView();
		}
		
		private function scaleHandler(value:Number):void{
			_scale=value;
			var circleShape:b2CircleShape=_body.GetFixtureList().GetShape() as b2CircleShape;
			circleShape.SetRadius(_radius*_scale);
		}
		
		private function syncView():void{
			if(_animator){
				var pos:b2Vec2=_body.GetPosition();
				_animator.x=pos.x*MyData.pixelToMeter;
				_animator.y=pos.y*MyData.pixelToMeter;
				_animator.scaleX=_animator.scaleY=_scale;
			}
		}
		
		private function update():void{
			if(_isBroken)return;
			syncView();
			_scale+=0.01; if(_scale>1)_scale=1;
			scaleHandler(_scale);
			
			var dy:Number=Math.abs(_body.GetPosition().y-_y0);
			var isBroken:Boolean=false;
			isBroken||=getCheckContacts();
			isBroken||=dy>=_dy;
			if(isBroken) broken();
		}
		
		private function getCheckContacts():Boolean{
			var ce:b2ContactEdge=_body.GetContactList();
			var contact:b2Contact,b1:b2Body,b2:b2Body,ob:b2Body,type:String;
			for(ce;ce;ce=ce.next){
				contact=ce.contact;
				if(!contact.IsTouching())continue;
				b1=contact.GetFixtureA().GetBody();
				b2=contact.GetFixtureB().GetBody();
				ob=b1==_body?b2:b1;
				type=ob.GetUserData()?ob.GetUserData().type:null;
				if(type=="switcherMovie"||type=="ground")
					return true;
			}
			return false;
		}
		
		private function broken():void{
			if(_isBroken)return;
			_isBroken=true;
			_facade.global.curWorld.DestroyBody(_body);
			_maker.addMakeDelayTime();
		}
		
		override public function destroy():void{
			if(_animator){
				_animator.dispose();
				_animator=null;
			}
			_facade.global.curWorld.DestroyBody(_body);
			_body=null;
			_maker=null;
			super.destroy();
		}
	};

}