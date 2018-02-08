package g {
	import Box2D.Dynamics.b2World;
	import demo.TestObj;
	import flash.display.MovieClip;
	import flash.events.Event;
	import framework.events.FrameworkEvent;
	import framework.Facade;
	import framework.system.LocalManager;
	import framework.system.ScorllMode;
	import framework.utils.Fps;
	import framework.utils.LibUtil;
	import framework.utils.TweenMax;
	import g.MapCtrl;
	import g.MapModel;
	import g.MapView;
	import kingBook.ObjectFactory;
	
	public class MyFacade extends Facade {
		public function MyFacade() {
			super();
		}
		
		public static function getInstance():MyFacade {
			if (_instance == null) 
				_instance = new MyFacade();
			return MyFacade(_instance);
		}
		
		override public function startup(params:*=null):void{
			_global = new MyGlobal(params.main, this, MyData.stageW, MyData.stageH, MyData.box2dDebugVisible,MyData.pixelToMeter);//初始全局对象
			var world:b2World = _global.createBox2dMan(0,_global.layerMan.gameLayer,MyData.gravity,MyData.useMouseJoint,MyData.deltaTime,MyData.pixelToMeter).world;
			_global.setCurWorld(world);
			params.main.addEventListener(Event.ENTER_FRAME, update);//游戏刷新
			//
			if (MyData.clearLocalData) _global.localManager.clear();
			if (MyData.closeSound) _global.soundMan.mute = true;
			//
			addEventListener(MyEvent.TO_TITLE, toTitle);
			addEventListener(MyEvent.TO_SELECT_LEVEL, toSelectLevel);
			addEventListener(MyEvent.TO_HELP, toHelp);
			addEventListener(MyEvent.GO_TO_LEVEL, gotoLevel);
			addEventListener(MyEvent.WIN, gameWin);
			addEventListener(MyEvent.FAILURE, gameFailure);
			addEventListener(MyEvent.RESET_LEVEL, resetLevel);
			addEventListener(MyEvent.NEXT_LEVEL, nextLevel);
			addEventListener(FrameworkEvent.PAUSE,pauseOrResumeHandler);
			addEventListener(FrameworkEvent.RESUME,pauseOrResumeHandler);
			//
			dispatchEvent(new MyEvent(MyEvent.TO_TITLE));
			//
			if(MyData.fpsVisible){
				Fps.setup(_global.main);
				Fps.visible = true;
			}
		}

		
		private function toTitle(e:MyEvent):void {
			if (e.info && e.info.doDestroy) destroyCurLevel();
			createGameObj(new UI(), { viewComponent: LibUtil.getDefSprite("TitleUI_mc"), type: UI.TITLE } );
			_global.soundMan.stopAll();
			_global.soundMan.playLoop("开场",0.8);
		}
		
		private function toSelectLevel(e:MyEvent):void {
			if (e.info && e.info.doDestroy) destroyCurLevel();
			createGameObj(new UI(), { viewComponent: LibUtil.getDefSprite("SelectLevelUI_mc"), type: UI.SELECT_LEVEL } );
			if (!_global.soundMan.isPlaying("开场")) {
				_global.soundMan.stopAll();
				_global.soundMan.playLoop("开场",0.8);
			}
		}
		
		private function toHelp(e:MyEvent):void {
			createGameObj(new UI(), {viewComponent: LibUtil.getDefSprite("HelpUI_mc"), type: UI.HELP});
		}
		
		private function gameWin(e:MyEvent):void {
			if (myGlobal.gameStatus == MyGlobal.GAME_END) return;
			trace("gameWin");
			_global.dispatchEvent(e);
			// 弹过关，通关 界面
			if (myGlobal.gameLevel < MyData.maxLevel) {
				createGameObj(new UI(), {viewComponent: LibUtil.getDefSprite("MissionCompleteUI_mc"), type: UI.MISSION_COMPLETE});
			}else {
				createGameObj(new UI(), {viewComponent: LibUtil.getDefSprite("VictoryUI_mc"), type: UI.VICTORY});
			}
			
			var localMan:LocalManager = _global.localManager;
			// 解锁关卡
			var unlockLevel:int = int(localMan.get("unlockLevel"));
			if (myGlobal.gameLevel+1>unlockLevel)
				localMan.save("unlockLevel", myGlobal.gameLevel + 1 > MyData.maxLevel?MyData.maxLevel:myGlobal.gameLevel + 1);
			//播放胜利音效
			_global.soundMan.stopAll();
			_global.soundMan.play("胜利",0.6)
			
		}
		
		private function gameFailure(e:MyEvent):void {
			if (myGlobal.gameStatus == MyGlobal.GAME_END) return;
			trace("gameFailure");
			_global.dispatchEvent(e);
			createGameObj(new UI(), {viewComponent: LibUtil.getDefSprite("Failure_mc"), type: UI.FAILURE});
			
			_global.soundMan.stopAll();
			_global.soundMan.play("失败",0.6);
		}
		
		private function resetLevel(e:MyEvent):void {
			destroyCurLevel();
			_global.dispatchEvent(e);
			dispatchEvent(new MyEvent(MyEvent.GO_TO_LEVEL, {level: myGlobal.gameLevel}));
		}
		
		private function nextLevel(e:MyEvent):void {
			destroyCurLevel();
			_global.dispatchEvent(e);
			dispatchEvent(new MyEvent(MyEvent.GO_TO_LEVEL, {level: myGlobal.gameLevel + 1}));
		}
		
		private function gotoLevel(e:MyEvent):void {
			_global.dispatchEvent(e);
			_global.scorllMan.setScorllMode(ScorllMode.TARGET_CENTER);
			//创建 控制界面
			createGameObj(new UI(), { viewComponent: LibUtil.getDefSprite("ControlUI_mc"), type: UI.CONTROL_BAR } );
			//创建地图
			createMvc(new MapModel(), new MapView(), null, new MapCtrl());
			dispatchEvent(new MyEvent(MyEvent.CREATE_MAP_COMPLETE));
			//创建 游戏信息界面
			createGameObj(new GameMessageUI(), { viewComponent: LibUtil.getDefSprite("GameMessageUI_mc") } );
			var msgUI:GameMessageUI=getGameObj(GameMessageUI.ID) as GameMessageUI;
			msgUI.updateHpTxt(myGlobal.playerHp.toString());
			//创建玩家
			
			//立刻滚动地图到中心
			_global.scorllMan.rightNowToPos();
			// 播放背景音乐
			_global.soundMan.stopAll();
			_global.soundMan.playLoop("背景",0.7);
		}
		
		private function destroyCurLevel():void {
			destroyAll();
			TweenMax.killAll();
		}
		
		private function pauseOrResumeHandler(e:FrameworkEvent):void {
			if (e.type == FrameworkEvent.PAUSE) TweenMax.pauseAll(true,true);
			else TweenMax.resumeAll(true,true);
		}
		
		public function get myGlobal():MyGlobal { return _global as MyGlobal; }

	}
	
}
