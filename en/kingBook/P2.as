package kingBook {
	import Box2D.Collision.b2WorldManifold;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.Contacts.b2ContactEdge;
	import flash.events.Event;
	import framework.events.FrameworkEvent;
	import framework.objs.Clip;
	import framework.system.KeyboardManager;
	import framework.UpdateType;
	import framework.utils.TweenMax;
	import g.Animator;
	import g.fixtures.Switcher;
	/**
	 * 红
	 * @author kingBook
	 * 2015/10/13 10:21
	 */
	public class P2 extends Player {
		public function P2() {
			super();
		}
		
		override protected function addListeners():void {
			super.addListeners();
			registerUpdateListener(UpdateType.UPDATE_2,update);
		}
		
		override protected function initModelHandler(e:FrameworkEvent):void {
			super.initModelHandler(e);
			_animator=new Animator(_facade,_facade.global.layerMan.items2Layer);
			_animator.addEventListener(Event.CHANGE,changeAnimation);
			_animator.addAnimation("idle",Clip.fromDefName("P2_idle",true));
			_animator.addAnimation("eat",Clip.fromDefName("P2_eat",true));
			_animator.addAnimation("walk",Clip.fromDefName("P2_walk",true));
			_animator.addAnimation("push",Clip.fromDefName("P2_push",true));
			_animator.addAnimation("fly",Clip.fromDefName("P2_fly",true));
			_animator.addAnimation("drop",Clip.fromDefName("P2_drop",true));
			_animator.setDefaultAnimation("idle");
			
			_animator.addTransitionCondition(null,"idle",function():Boolean{return !_isDeath&&!_inAir&&!_isFly&&!isPushStone()&&!_isEat&&(!_isPressL&&!_isPressR);});
			_animator.addTransitionCondition(null,"eat",function():Boolean{return !_isDeath&&!_inAir&&!_isFly&&!isPushStone()&&_isEat;});
			_animator.addTransitionCondition(null,"walk",function():Boolean{return !_isDeath&&!_isFly&&!_inAir&&!isPushStone()&&(_isPressL||_isPressR);});
			//
			function isPushStone():Boolean{
				var hitEdgeXBodyIsStone:Boolean=_hitEdgeXBody&&_hitEdgeXBody.GetUserData()&&_hitEdgeXBody.GetUserData().thisObj is Stone;
				var result:Boolean=false;
				result||=_isPressL&&_hitEdgeX<0&&hitEdgeXBodyIsStone;
				result||=_isPressR&&_hitEdgeX>0&&hitEdgeXBodyIsStone;
				return result;
			}
			_animator.addTransitionCondition(null,"push",function():Boolean{return !_isDeath&&!_isFly&&!_inAir&&isPushStone();});
			//
			_animator.addTransitionCondition(null,"fly",function():Boolean{return !_isDeath&&_inAir&&_isFly;});
			_animator.addTransitionCondition(null,"drop",function():Boolean{return !_isDeath&&_inAir&&!_isFly;});
			
			Switcher.AddActiveObj(this);
			_km=new KeyboardManager(_facade);
			_facade.global.scorllMan.addToTargetList(_body);
			syncView();
			
			
		}
		
		private function changeAnimation(e:Event):void{
			if(_animator.curAniKey=="idle"){
				addEatDelay();
			}else if(_animator.curAniKey!="eat"){
				removeEatDelay();
				_isEat=false;
			}
			if(_animator.curAniKey!="fly"){
				playOrStopFartSound(true);
			}
		}
		private var _isEat:Boolean;
		private function addEatDelay():void{
			TweenMax.delayedCall(1,eatDelayComplete);
		}
		private function removeEatDelay():void{
			TweenMax.killDelayedCallsTo(eatDelayComplete);
		}
		private function eatDelayComplete():void{
			_isEat=true;
		}		
		private function update():void{
			syncView();
			ai();
		}
		
		private function ai():void {
			if(_isDeath)return;
			checkPlayBurpSound();
			check_T_L_R_outWorldRest();
			checkInAir();
			checkHitEdgeX();
			if(!_myFacade.myGlobal.disableKeyboard){
				if(_km.p("LEFT")){walk(-1); _isPressL=true;_isPressR=false;}
				else if(_km.p("RIGHT")){walk(1); _isPressL=false;_isPressR=true;}
				else{ _isPressL=false;_isPressR=false; }
				if(!_inAir)setIsFly(false);
				if(_km.p("UP")){
					if(_inAir){
						var vy:Number=_body.GetLinearVelocity().y;
						setIsFly(vy<=4);
					}else{ setIsFly(true); }
				}else{ setIsFly(false); }
				if(_isFly)fly();
			}else{
				_isPressL=false;_isPressR=false;
			}
			limitVx();
			
			checkContacts();
			limitStageEdgeX();
			checkDropCliff();
		}
		
		
		override public function destroy():void {
			removeEatDelay();
			if(_isDestroy)return;
			_isDestroy=true;
			Switcher.RemoveActiveObj(this);
			super.destroy();
		}
		
	}

}