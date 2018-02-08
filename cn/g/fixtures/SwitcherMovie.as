package g.fixtures {
	import Box2D.Collision.b2Manifold;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.Contacts.b2Contact;
	import framework.events.FrameworkEvent;
	import framework.snd.sound.SoundInstance;
	import framework.UpdateType;
	import g.MyData;
	
	/**
	 * ...
	 * @author kingBook
	 * 2015/10/19 9:10
	 */
	public class SwitcherMovie extends SwitcherCtrlObj {
		protected var _body:b2Body;
		protected var _long:Number;
		protected var _botPos:b2Vec2;
		protected var _minPos:b2Vec2;
		protected var _maxPos:b2Vec2;
		private var _speed:Number=3;
		
		public function SwitcherMovie() {
			super();
		}
		
		override protected function addListeners():void {
			registerUpdateListener(UpdateType.UPDATE_2,update);
			super.addListeners();
		}
		
		override protected function initModelHandler(e:FrameworkEvent):void {
			_body=e.info.body;
			_body.SetUserData({thisObj:this,type:"switcherMovie"});
			_body.SetType(b2Body.b2_kinematicBody);
			_body.SetPreSolveCallback(preSolve);
			_long=e.info.long/MyData.pixelToMeter;
			_isOpen=e.info.isOpen;
			_isGotoEnd=true;
			_ctrlMySwitcherName=e.info.ctrlMySwitcherName;
			
			var reAngle:Number=_body.GetAngle()+Math.PI;
			_botPos=_body.GetPosition().Copy();
			_botPos.Add(new b2Vec2(Math.cos(reAngle)*_long*0.5,Math.sin(reAngle)*_long*0.5));
			
			var offset:Number=2/MyData.pixelToMeter;//陷入地面一点点
			_minPos=_body.GetPosition().Copy();
			_minPos.Add(new b2Vec2(Math.cos(reAngle)*(_long+offset),Math.sin(reAngle)*(_long+offset)));
			
			_maxPos=_body.GetPosition().Copy();
			
			//初始化状态
			_body.SetPosition(_isOpen?_maxPos:_minPos);
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
			var key:String="机关";
			var si:SoundInstance=_facade.global.soundMan.getSound(key);
			if(isStop){
				si&&si.stop();
			}else{
				if(si&&si.isPlaying){}else{
					_facade.global.soundMan.playLoop(key,1);
				}
			}
		}
		
		private function update():void{
			if(!_isGotoEnd){
				_isGotoEnd=gotoPoint(_isOpen?_maxPos:_minPos);
				if(_isGotoEnd)playOrStopSound(true);
				updateProgress();
			}
		}
		protected function updateProgress():void{}
			
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
		
		private function preSolve(contact:b2Contact, oldManifold:b2Manifold):void{
			if(!contact.IsTouching())return;
			var b1:b2Body=contact.GetFixtureA().GetBody();
			var b2:b2Body=contact.GetFixtureB().GetBody();
			var ob:b2Body=b1==_body?b2:b1;
			if(!inAcceptRange(ob))contact.SetEnabled(false);
		}
		
		public function inAcceptRange(body:b2Body):Boolean {
			var len:Number=10/MyData.pixelToMeter;
			var angle1:Number=_body.GetAngle()-Math.PI*0.5;
			var angle2:Number=_body.GetAngle()+Math.PI*0.5;
			var p1:b2Vec2 = new b2Vec2(_botPos.x+len*Math.cos(angle1),_botPos.y+len*Math.sin(angle1));
			var p2:b2Vec2 = new b2Vec2(_botPos.x+len*Math.cos(angle2),_botPos.y+len*Math.sin(angle2));
			return pointOnSegment(body.GetPosition(),p1,p2) < 0;
		}
		
		private function pointOnSegment(p:b2Vec2,p1:b2Vec2,p2:b2Vec2):Number {
			var ax:Number = p2.x-p1.x;
			var ay:Number = p2.y-p1.y;
			
			var bx:Number = p.x-p1.x;
			var by:Number = p.y-p1.y;
			return ax*by-ay*bx;
		}
		
		override public function destroy():void {
			playOrStopSound(true);
			_facade.global.curWorld.DestroyBody(_body);
			_body=null;
			_botPos=null;
			_minPos=null;
			_maxPos=null;
			super.destroy();
		}
		
	};

}