package g {
	import Box2D.Dynamics.b2World;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import framework.events.FrameworkEvent;
	import framework.Facade;
	import framework.flintparticles.twoD.renderers.BitmapRenderer;
	import framework.system.Global;
	import framework.utils.FuncUtil;
	import kingBook.Player;
	
	/**
	 * ...
	 * @author kingBook
	 * 2014-10-09 14:40
	 */
	public class MyGlobal extends Global {
		public static const GAMEING:String = "gameing";
		public static const GAME_END:String = "gameEnd";
		private var _gameLevel:int;
		private var _gameStatus:String;
		private var _disableKeyboard:Boolean;
		private var _renderer:BitmapRenderer;
		private var _allCtrlObjList:Array;
		private var _resetPointList:Array;
		
		public var playerHp:int;
		
		public function MyGlobal(main:Sprite, facade:Facade, gameWidth:Number, gameHeight:Number, box2dDebugVisible:Boolean=false,pixelToMeter:Number=30) {
			super(main,facade,gameWidth,gameHeight,box2dDebugVisible,pixelToMeter);
			addEventListener(MyEvent.GO_TO_LEVEL, gotoLevel);
			addEventListener(MyEvent.RESET_LEVEL, resetLevel);
			addEventListener(MyEvent.NEXT_LEVEL, nextLevel);
			addEventListener(MyEvent.WIN, gameWin);
			addEventListener(MyEvent.FAILURE, gameFailure);
			_facade.addEventListener(FrameworkEvent.PAUSE, pauseResumeHandler);
			_facade.addEventListener(FrameworkEvent.RESUME, pauseResumeHandler);
		}
		
		private function gotoLevel(e:MyEvent):void {
			reset();
			_gameLevel = e.info.level;
			_gameStatus = GAMEING;
			_disableKeyboard = false;
			_main["gameLevel"] = _gameLevel;
			
			_allCtrlObjList = [];
			_resetPointList = [];
			playerHp = Player.HP;
			
		}
		
		private function gameWin(e:MyEvent):void {
			_gameStatus = GAME_END;
			_disableKeyboard = true;
		}
		
		private function gameFailure(e:MyEvent):void {
			_gameStatus = GAME_END;
			_disableKeyboard = true;
		}
		
		private function pauseResumeHandler(e:FrameworkEvent):void {
			_disableKeyboard = _facade.pause;
		}
		
		private function resetLevel(e:MyEvent):void { disposeVars(); }
		private function nextLevel(e:MyEvent):void { disposeVars(); }
		public function disposeVars():void {
			FuncUtil.removeChild(_renderer);
			_renderer = null;
			_resetPointList.length = 0;
			_allCtrlObjList.length = 0;
		}
		
		override public function setCurWorld(value:b2World):void {
			if(_curWorld==value)return;
			value.SetContactListener(new MyContactListener());
			super.setCurWorld(value);
		}
		
		public function get allCtrlObjList():Array { return _allCtrlObjList; }
		public function get resetPointList():Array { return _resetPointList; }
		public function get gameLevel():int { return _gameLevel; }
		public function get gameStatus():String { return _gameStatus; }
		public function get disableKeyboard():Boolean { return _disableKeyboard; }
		/*public function get renderer():BitmapRenderer {
			var mapModel:MapModel = _facade.getModel(MapModel.ID)as MapModel;
			_renderer ||= new BitmapRenderer(new Rectangle(0, 0, mapModel.width, mapModel.height));
			_facade.global.viewMan.effLayer.addChild(_renderer);
			return _renderer;
		}*/
	}

}