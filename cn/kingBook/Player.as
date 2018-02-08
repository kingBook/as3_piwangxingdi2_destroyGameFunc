package kingBook {
	import Box2D.Collision.b2ContactID;
	import Box2D.Collision.b2Manifold;
	import Box2D.Collision.b2WorldManifold;
	import Box2D.Collision.Shapes.b2MassData;
	import Box2D.Common.Math.b2Math;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.Contacts.b2ContactEdge;
	import flash.geom.Point;
	import flash.utils.getTimer;
	import framework.events.FrameworkEvent;
	import framework.objs.Clip;
	import framework.objs.GameObject;
	import framework.snd.sound.SoundInstance;
	import framework.system.KeyboardManager;
	import framework.utils.Box2dUtil;
	import framework.utils.FuncUtil;
	import framework.utils.TweenMax;
	import g.Animator;
	import g.GameMessageUI;
	import g.MapModel;
	import g.MyData;
	import g.MyEvent;
	import g.MyObj;
	import interfaces.IEnemy;
	
	/**
	 * ...
	 * @author kingBook
	 * 2015/9/17 17:28
	 */
	public class Player extends MyObj {
		public static const HP:int = 3;
		protected var _body:b2Body;
		protected var _km:KeyboardManager;
		protected var _speedX:Number=7;
		protected var _jumpSpeed:Number=60;
		protected var _inAir:Boolean;
		protected var _animator:Animator;
		protected var _dirX:int=1;
		protected var _isPressL:Boolean;
		protected var _isPressR:Boolean;
		protected var _hitEdgeX:int;
		protected var _isFly:Boolean;
		protected var _treasureClip:Clip;
		protected var _other:Player;
		protected var _hitEdgeXBody:b2Body;
		
		public function Player() {
			super();
		}
		
		override protected function addListeners():void{
			registerEventListener(_facade,MyEvent.CREATE_MAP_COMPLETE,createMapComplete);
			super.addListeners();
		}
		
		override protected function initModelHandler(e:FrameworkEvent):void{
			_body=e.info.body;
			_body.SetUserData({thisObj:this,type:"player"});
			_body.SetPreSolveCallback(preSolve);
			
			_treasureClip=Clip.fromDefName("Treasure_view",true);
			_treasureClip.controlled=true;
			_facade.global.layerMan.items2Layer.addChildAt(_treasureClip,0);
			clearBackpack();
			syncView();
		}
		
		private function createMapComplete(e:MyEvent):void{
			logoutEventListener(_facade,MyEvent.CREATE_MAP_COMPLETE,createMapComplete);
			var players:Vector.<GameObject>=_facade.getGameObjList(Player);
			_other=players[0]==this?players[1] as Player:players[0] as Player;
		}
		
		
		private function preSolve(contact:b2Contact, oldManifold:b2Manifold):void{
			if(!contact.IsTouching())return;
			var b1:b2Body=contact.GetFixtureA().GetBody();
			var b2:b2Body=contact.GetFixtureB().GetBody();
			var ob:b2Body=b1==_body?b2:b1;
			var othis:*=ob.GetUserData()?ob.GetUserData().thisObj:null;
			if(othis is Player)contact.SetEnabled(false);
		}
		
		protected function walk(dirX:int):void{
			_dirX=dirX;
			
			if(_hitEdgeX!=dirX){
				_body.ApplyImpulse(b2Vec2.Make(1000*dirX,0),_body.GetWorldCenter());
			}else{
				var oUserData:*=_hitEdgeXBody.GetUserData();
				var othis:*=oUserData?oUserData.thisObj:null;
				if(othis is Stone && (othis as Stone).hitEdgeX==_hitEdgeX){
					
				}else{
					_body.ApplyImpulse(b2Vec2.Make(1000*dirX,0),_body.GetWorldCenter());
				}
			}
		}
		
		protected function limitVx():void{
			var vel:b2Vec2 = _body.GetLinearVelocity();
			if(Math.abs(vel.x)>_speedX){
				var dir:int=vel.x>=0?1:-1;
				vel.x=dir*_speedX;
			}
			if(_inAir){
				if(!_isPressL&&!_isPressR)vel.x*=0.9;
			}
		}
		
		protected function jump():void{
			if(_inAir)return;
			var v:b2Vec2=_body.GetLinearVelocity(); v.y=0;
			_body.SetLinearVelocity(v);
			_body.ApplyImpulse(b2Vec2.Make(0,-_jumpSpeed),_body.GetWorldCenter());
			
			var pos:b2Vec2=_body.GetPosition(); pos.y-=1;
			_body.SetPosition(pos);
			_inAir=true;
			_facade.global.soundMan.play("跳跃");
		}
		
		private var _worldManifold:b2WorldManifold=new b2WorldManifold();
		protected function checkInAir():void{
			var inAir:Boolean=true, contact:b2Contact, ce:b2ContactEdge=_body.GetContactList(), ny:Number;
			for(ce; ce; ce=ce.next){
				contact = ce.contact;
				if(!contact.IsTouching())continue;
				if(contact.IsSensor()||!contact.IsEnabled())continue;
				contact.GetWorldManifold(_worldManifold);
				ny=_worldManifold.m_normal.y; if(contact.GetFixtureA().GetBody()!=_body)ny=-ny;
				if(ny>0.6){
					inAir=false;
					break;
				}
			}
			if(!inAir&&_inAir){
				//落地
				_facade.global.soundMan.play("落地");
			}
			_inAir=inAir;
		}
		
		protected function checkHitEdgeX():void{
			var hitEdgeX:int=0,hitEdgeXBody:b2Body=null;
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
				contact.GetWorldManifold(_worldManifold);
				nx=_worldManifold.m_normal.x; if(contact.GetFixtureA().GetBody()!=_body)nx=-nx;
				if(Math.abs(nx)>0.8){
					hitEdgeX=nx>0?1:-1;
					hitEdgeXBody=ob;
					break;
				}
			}
			_hitEdgeX=hitEdgeX;
			_hitEdgeXBody=hitEdgeXBody;
		}
		
		protected function syncView():void{
			var pos:b2Vec2=_body.GetPosition();
			if(_animator){
				_animator.x=pos.x*MyData.pixelToMeter;
				_animator.y=pos.y*MyData.pixelToMeter;
				_animator.rotation=_body.GetAngle()*57.3;
				_animator.scaleX=Math.abs(_animator.scaleX)*_dirX;
			}
			if(_treasureClip){
				_treasureClip.x=pos.x*MyData.pixelToMeter-20*_dirX;
				_treasureClip.y=pos.y*MyData.pixelToMeter-5;
				_treasureClip.scaleX=Math.abs(_treasureClip.scaleX)*_dirX;
			}
		}
		
		private var _wounding:Boolean;
		private var _delayCount:int;
		public function wound():void {
			if(MyData.isPower)return;
			if (_wounding) return;
			_wounding=true;
			_myFacade.myGlobal.playerHp--;
			_facade.global.soundMan.play("受伤");
			var pos:b2Vec2=_body.GetPosition();
			ObjectFactory.instance.createSubHpEffect(pos.x*MyData.pixelToMeter,pos.y*MyData.pixelToMeter-40);
			var msgUI:GameMessageUI=_facade.getGameObj(GameMessageUI.ID) as GameMessageUI;
			msgUI.updateHpTxt(_myFacade.myGlobal.playerHp.toString());
			if (death) {
				deathHandler();
			}else{
				//闪烁
				_delayCount=0;
				TweenMax.to(this, 3, { onUpdate:flashingHandler, onComplete:flashingComplete } );
			}
		}
		private function flashingHandler():void{
			_delayCount++;
			_animator.curAnimation.alpha = _delayCount%3==0?0.3:1;
		}
		private function flashingComplete():void{
			_animator.curAnimation.alpha = 1;
			_wounding=false;
		}
		private function get death():Boolean { return _myFacade.myGlobal.playerHp <= 0; }
		protected var _isDeath:Boolean;
		protected function deathHandler():void {
			if(MyData.isPower)return;
			if (_isDeath) return;
			_isDeath = true;
			_facade.global.scorllMan.setPause(true);
			_body.SetLinearVelocity(new b2Vec2(_dirX*6,-15));
			_body.SetSensor(true);
			//_body.SetType(b2Body.b2_kinematicBody);
			//_facade.dispatchEvent(new MyEvent(MyEvent.FAILURE));
			//_facade.global.soundMan.play("玩家挂了");
			TweenMax.delayedCall(0.5,failureDelayComplete);
		}
		
		private function failureDelayComplete():void {
			_facade.dispatchEvent(new MyEvent(MyEvent.FAILURE));
		}
		
		public function moveToGround():void {
			if (_isDeath) return;
			var nearestPos:b2Vec2 = getNearestPos();
			//找到的点在舞台上才移到点上
			//var gpt:Point = FuncUtil.globalXY(_facade.global.viewMan.gameLayer, nearestPos.ToPoint());
			//if (FuncUtil.stageContainsPt(gpt, MyData.stageW, MyData.stageH)) {
				_body.SetPosition(new b2Vec2(nearestPos.x/MyData.pixelToMeter,nearestPos.y/MyData.pixelToMeter));
			//}else {
				//_myFacade.myGlobal.playerHp = 0;
			//	deathHandler();
			//}
		}
		
		private function getNearestPos():b2Vec2 {
			if (_myFacade.myGlobal.resetPointList.length == 0) return new b2Vec2(100, 100);
			var distanceList:Array = []; 
			var i:int = _myFacade.myGlobal.resetPointList.length;
			var pos:b2Vec2;
			var myPos:b2Vec2=_body.GetPosition().Copy();
			myPos.Multiply(MyData.pixelToMeter);
			while (--i >= 0) {
				pos = _myFacade.myGlobal.resetPointList[i];
				distanceList.push({distance: b2Vec2.Distance(myPos, pos), index: i});
			}
			distanceList.sortOn("distance", Array.NUMERIC);
			var nearestId:int = distanceList[0].index;
			return _myFacade.myGlobal.resetPointList[nearestId];
		}
		
		protected function checkDropCliff():void {
			var maxY:Number = _body.GetPosition().y*MyData.pixelToMeter+38;
			var mapModel:MapModel = _facade.getModel(MapModel.ID) as MapModel;
			if (maxY > mapModel.height - 2) wound();
		}
		
		/**用于计算持续飞行的时间*/
		private var _enterFlyTime:int;
		protected function setIsFly(value:Boolean):void{
			if(_isFly==value)return;
			_isFly=value;
			if(_isFly){
				var v:b2Vec2=_body.GetLinearVelocity();
				if(v.y<0)v.y=0;
				_body.SetLinearVelocity(v);
				_body.SetAwake(true);
				_enterFlyTime=getTimer();
				playOrStopFartSound(false);
				
				
			}
		}
		
		protected function playOrStopFartSound(isStop:Boolean):void{
			var soundName:String=this is P1?"屁p1":"屁p2";
			var si:SoundInstance=_facade.global.soundMan.getSound(soundName);
			if(isStop){
				si&&si.stop();
			}else{
				if(si&&si.isPlaying){}else{
					_facade.global.soundMan.play(soundName);
				}
			}
		}
		
		
		protected function fly():void{
			if(getTimer()-_enterFlyTime>=1400) return; //判断飞行持续时间
			_body.ApplyImpulse(new b2Vec2(0,_body.GetMass()*-1.6),_body.GetPosition());
			if(_animator.curAniKey=="fly"){
				var clip:Clip=_animator.curAnimation as Clip;
				if(clip.currentFrame==1)createFart();
			}
		}
		
		private var _fartCount:int;
		/**创建屁*/
		private function createFart():void{
			_fartCount++;
			if(_fartCount%3==0)_fartCount=0;
			var fartDir:int=_fartCount>0?1:-1;
			
			var pos:b2Vec2=_body.GetPosition();
			var clip:Clip=ObjectFactory.instance.createEffect("Fart_view",pos.x*MyData.pixelToMeter,pos.y*MyData.pixelToMeter+35,_facade.global.layerMan.effLayer);
			clip.scaleX*=fartDir;
			
		}
		
		protected function limitStageEdgeX():void{
			checkStopMoveX();
			_other&&_other.checkStopMoveX();
		}
		
		private function checkStopMoveX():void{
			var pos:Point=new Point(_body.GetPosition().x*MyData.pixelToMeter, _body.GetPosition().y*MyData.pixelToMeter);
			var myGpt:Point = FuncUtil.globalXY(_facade.global.layerMan.gameLayer, pos);
			var dx:Number = 20;
			var min:Number = dx;
			var max:Number = MyData.stageW - dx;
			
			var result:Boolean=false;
			result||=_dirX>0 && myGpt.x>=max;
			result||=_dirX<0 && myGpt.x<=min;
			if(result){
				var v:b2Vec2=_body.GetLinearVelocity();
				v.x=0;
				_body.SetLinearVelocity(v);
			}
		}
		
		protected function checkContacts():void{
			if(_isDestroy)return;
			var ce:b2ContactEdge=_body.GetContactList();
			var contact:b2Contact,ob:b2Body,othis:*,userData:*,type:String;
			for(ce;ce;ce=ce.next){
				contact=ce.contact;
				if(!contact.IsTouching())continue;
				ob=contact.GetFixtureA().GetBody();if(ob==_body)ob=contact.GetFixtureB().GetBody();
				userData=ob.GetUserData();
				othis=userData?userData.thisObj:null;
				type=userData?userData.type:null;
				if(!foreachContact(othis,userData,type))break;
			}
		}
		
		private function clearBackpack():void{_treasureClip.gotoAndStop(_treasureClip.totalFrames);}
		private function backpackIsEmpty():Boolean{return _treasureClip.currentFrame==_treasureClip.totalFrames;}
		
		protected function foreachContact(othis:*,userData:*,type:String):Boolean{
			if(othis is Treasure){//宝物
				if(backpackIsEmpty()){
					var treasure:Treasure=othis as Treasure;
					treasure.playerEat(eatTreasureCallback);
					if(treasure.type==1&&_myFacade.myGlobal.gameLevel==1){
						var hints:Vector.<GameObject>=_facade.getGameObjList(Hint);
						for each(var hint:Hint in hints){
							if(hint.name=="hint1"){
								hint.destroy();
								break;
							}
						}
					}
				}
			}else if(othis is Altar){//祭坛
				if(!backpackIsEmpty()){
					if(userData.isEmpty && userData.id==_treasureClip.currentFrame){
						clearBackpack();
						var altar:Altar=othis as Altar;
						altar.setEmpty(userData.id,false);
					}
				}
			}else if(othis is IEnemy||othis is Bead){
				wound();
			}else if(othis is Hint){
				hint=othis as Hint;
				if(_myFacade.myGlobal.gameLevel==1&&hint.name=="hint3"){
					hint.destroy();
				}
			}
			//
			if(type=="danger"){
				wound();
			}
			return true;
		}
		
		private function eatTreasureCallback(treasure:Treasure):void{
			_treasureClip.gotoAndStop(treasure.type);
		}
		
		/**检测顶，左右是否超边界*/
		protected function check_T_L_R_outWorldRest():void{
			var mapModel:MapModel=_facade.getModel(MapModel.ID) as MapModel;
			var xmax:Number=mapModel.width/MyData.pixelToMeter;
			var pos:b2Vec2=_body.GetPosition();
			var ww:Number=14/MyData.pixelToMeter;
			var hh:Number=32/MyData.pixelToMeter;
			
			if(pos.x-ww>mapModel.width/MyData.pixelToMeter){
				pos.x=xmax-ww;
				_body.SetPosition(pos);
			}else if(pos.x+ww<0){
				pos.x=ww;
				_body.SetPosition(pos);
			}
			
			if(pos.y+hh<0){
				pos.y=hh;
				_body.SetPosition(pos);
			}
		}
		
		/**检测播放打嗝*/
		protected function checkPlayBurpSound():void{
			if(_animator){
				if(_animator.curAniKey=="eat"){
					var clip:Clip=_animator.curAnimation as Clip;
					if(clip.currentFrame==91){
						_facade.global.soundMan.play("打嗝",0.2);
					}
				}
			}
		}
		
		protected var _isDestroy:Boolean;
		override public function destroy():void {
			TweenMax.killTweensOf(this);
			TweenMax.killDelayedCallsTo(failureDelayComplete);
			_facade.global.curWorld.DestroyBody(_body);
			FuncUtil.removeChild(_treasureClip);
			_body=null;
			_worldManifold=null;
			if(_km){
				_km.destroy();
				_km=null;
			}
			if(_animator){
				_animator.dispose();
				_animator=null;
			}
			_treasureClip=null;
			_other=null;
			super.destroy();
		}
		
		public function get inAir():Boolean{return _inAir;}
		public function get body():b2Body{return _body;}
		public function get dirX():int{ return _dirX; }
		public function get isPressL():Boolean{ return _isPressL; }
		public function get isPressR():Boolean{ return _isPressR; }
		public function get linearVelocity():b2Vec2{ return _body.GetLinearVelocity(); }
		
	};

}