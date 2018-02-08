package g.fixtures {
	import Box2D.Collision.b2Manifold;
	import Box2D.Collision.b2WorldManifold;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.Contacts.b2Contact;
	import framework.events.FrameworkEvent;
	import framework.objs.Clip;
	import framework.snd.sound.SoundInstance;
	import framework.UpdateType;
	import framework.utils.FuncUtil;
	import g.MyData;
	
	/**
	 * ...
	 * @author kingBook
	 * 2015/10/21 9:11
	 */
	public class Platform extends SwitcherCtrlObj {
		
		private var _type:String;//平台类型
		private const CONTROLLED:String="controlled";
		private const AUTO:String="auto";
		private const FIXED:String="fixed";
		
		private var _body:b2Body;
		private var _clip:Clip;
		private var _isOneWay:Boolean;
		private var _minPos:b2Vec2;
		private var _maxPos:b2Vec2;
		private var _speed:Number=3;
		
		override protected function addListeners():void {
			registerUpdateListener(UpdateType.UPDATE_2,update);
			super.addListeners();
		}
		
		public function Platform() { super(); }
		
		override protected function initModelHandler(e:FrameworkEvent):void {
			_speed=e.info.speed;
			_body=e.info.body;
			_body.SetType(b2Body.b2_kinematicBody);
			_body.SetPreSolveCallback(preSolve);
			_body.SetUserData({thisObj:this,type:"platform"});
			
			_isOneWay=e.info.isOneWay;
			_type=e.info.type;
			_ctrlMySwitcherName=e.info.ctrlMySwitcherName;
			_clip=e.info.clip;
			
			if(isKinematic()){
				var min:Number=e.info.min;
				var max:Number=e.info.max;
				var axis:String=e.info.axis;
				if(min||max){
					min/=MyData.pixelToMeter;
					max/=MyData.pixelToMeter;
					_minPos=new b2Vec2(axis=="x"?min:_body.GetPosition().x, axis=="y"?min:_body.GetPosition().y);
					_maxPos=new b2Vec2(axis=="x"?max:_body.GetPosition().x, axis=="y"?max:_body.GetPosition().y);
					
					var dMin:Number=b2Vec2.Distance(_body.GetPosition(),_minPos);
					var dMax:Number=b2Vec2.Distance(_body.GetPosition(),_maxPos);
					if(_type==CONTROLLED)_body.SetPosition(dMin<dMax?_minPos:_maxPos);//贴紧到靠近的一边 
					_isOpen=!(dMin<dMax);//靠近minPos则为关，靠近maxPos则为开
					//如果body.position等于minPos或maxPos则_isGotoEnd为true;
					_isGotoEnd=false;
					_isGotoEnd||=_body.GetPosition().x==_minPos.x&&_body.GetPosition().y==_minPos.y;
					_isGotoEnd||=_body.GetPosition().x==_maxPos.x&&_body.GetPosition().y==_maxPos.y;
				}
			}
			syncView();
		}
		
		private function isKinematic():Boolean{ return _type==CONTROLLED||_type==AUTO; }
		
		private var _worldManifold:b2WorldManifold;
		private function preSolve(contact:b2Contact,oldManifold:b2Manifold):void{
			if(!_isOneWay)return;
			if(!contact.IsTouching())return;
			var b1:b2Body=contact.GetFixtureA().GetBody();
			var b2:b2Body=contact.GetFixtureB().GetBody();
			//
			_worldManifold||=new b2WorldManifold();
			contact.GetWorldManifold(_worldManifold);
			var ny:Number=_worldManifold.m_normal.y; if(b2!=_body)ny=-ny;
			if(ny>0.7){}else{
				contact.SetEnabled(false);
			}
			
		}
		
		private function syncView():void{
			if(!_clip)return;
			var pos:b2Vec2=_body.GetPosition();
			_clip.x=pos.x*MyData.pixelToMeter;
			_clip.y=pos.y*MyData.pixelToMeter;
		}
		
		private function update():void{
			if(isKinematic()){
				syncView();
				ai();
			}
		}
		
		private function ai():void{
			if(!_isGotoEnd){
				_isGotoEnd=gotoPoint(_isOpen?_maxPos:_minPos);
				if(_isGotoEnd){
					playOrStopSound(true);
					if(_type==AUTO)control(true);
				}
			}
		}
		
		private function gotoPoint(pos:b2Vec2):Boolean{
			var dx:Number=(pos.x-_body.GetPosition().x)*MyData.pixelToMeter;
			var dy:Number=(pos.y-_body.GetPosition().y)*MyData.pixelToMeter;
			var c:Number=Math.sqrt(dx*dx+dy*dy);
			if(c>_speed){
				var angleRadian:Number=Math.atan2(dy,dx);
				var vx:Number=Math.cos(angleRadian)*_speed;
				var vy:Number=Math.sin(angleRadian)*_speed;
				_body.SetLinearVelocity(new b2Vec2(vx,vy));
				_body.SetAwake(true);
			}else{
				_body.SetLinearVelocity(new b2Vec2(0,0));
				_body.SetPosition(pos);
				return true;
			}
			return false;
		}
		
		override protected function open():void {
			if(_isOpen)return;
			_isOpen=true;
			_isGotoEnd=false;
			playOrStopSound(false);
		}
		
		override protected function close():void {
			if(!_isOpen)return;
			_isOpen=false;
			_isGotoEnd=false;
			playOrStopSound(false);
		}
		
		private function playOrStopSound(isStop:Boolean):void{
			var key:String="平台移动";
			var si:SoundInstance=_facade.global.soundMan.getSound(key);
			if(isStop){
				si&&si.stop();
			}else{
				if(si&&si.isPlaying){}else{
					_facade.global.soundMan.play(key,1,0,int.MAX_VALUE);
				}
			}
		}
		
		override public function destroy():void {
			playOrStopSound(true);
			_facade.global.curWorld.DestroyBody(_body);
			FuncUtil.removeChild(_clip);
			_clip=null;
			_body=null;
			_minPos=null;
			_maxPos=null;
			_worldManifold=null;
			super.destroy();
		}
		
	};

}