package g {
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import framework.events.FrameworkEvent;
	import framework.Facade;
	import framework.system.KeyboardManager;
	import framework.UpdateType;
	import framework.utils.ButtonEffect;
	import framework.snd.sound.SoundAsEvent;
	import framework.utils.TweenMax;
	import g.MyObj;
	/**
	 * ...
	 * @author kingBook
	 * 2014-10-09 15:36
	 */
	public class UI extends MyObj {
		
		public static const TITLE:String = "title";
		public static const SELECT_LEVEL:String = "selectLevel";
		public static const FAILURE:String = "failure";
		public static const VICTORY:String = "victory";
		public static const MISSION_COMPLETE:String = "missionComplete";
		public static const CONTROL_BAR:String = "controlBar";
		public static const HELP:String = "help";
		
		private var _view:Sprite;
		private var _type:String;
		
		private var _moreGame:InteractiveObject;
		private var _logo:InteractiveObject;
		private var _toSelectLevel:InteractiveObject;
		private var _help:InteractiveObject;
		private var _toTitle:InteractiveObject;
		private var _resetLevel:InteractiveObject;
		private var _nextLevel:InteractiveObject;
		private var _mute:InteractiveObject;
		private var _pause:InteractiveObject;
		private var _numMcList:Array;
		private var _keyboardMan:KeyboardManager;
		private function get _muteMc():MovieClip {return _mute as MovieClip;}
		private function get _pauseMc():MovieClip {return _pause as MovieClip;}
		public function UI() {
			super();
		}
		
		override protected function initModelHandler(e:FrameworkEvent):void {
			_type = e.info.type;
			_view = e.info.viewComponent;
			_view.addEventListener(MouseEvent.CLICK, clickHandler);
			
			_moreGame = _view.getChildByName("moreGame") as InteractiveObject;
			_logo = _view.getChildByName("logo") as InteractiveObject;
			_toSelectLevel = _view.getChildByName("toSelectLevel") as InteractiveObject;
			_help = _view.getChildByName("help") as InteractiveObject;
			_toTitle = _view.getChildByName("toTitle") as InteractiveObject;
			_resetLevel = _view.getChildByName("resetLevel") as InteractiveObject;
			_nextLevel = _view.getChildByName("nextLevel") as InteractiveObject;
			_mute = _view.getChildByName("mute") as InteractiveObject;
			_pause = _view.getChildByName("pause") as InteractiveObject;
			
			var unlockLevel:int = int(_facade.global.localManager.get("unlockLevel")) || 1; 
			var numMc:MovieClip;
			var i:int;
			while (++i <= MyData.maxLevel) {
				numMc = _view.getChildByName("numMc" + i) as MovieClip;
				if(numMc){
					numMc.gotoAndStop((MyData.unlock || i <= unlockLevel) ? 1 : 2);
					if (numMc.txt) numMc.txt.text = (i<10?"0":"")+i;
					numMc.mouseChildren = false;
					if (numMc.currentFrame == 1) {
						numMc.buttonMode = true;
						ButtonEffect.to(numMc, {scale: {}});
					} else {
						numMc.buttonMode = false;
					}
					_numMcList ||= [];
					_numMcList[i - 1] = numMc;
				}
			}
			
			if (_muteMc) {
				_muteMc.buttonMode = true;
				_muteMc.gotoAndStop(_facade.global.soundMan.mute ? 2 : 1);
			}
			_facade.global.soundMan.addEventListener(SoundAsEvent.MUTE, muteHandler);
			
			if (_pauseMc) {
				_pauseMc.buttonMode = true;
				_pauseMc.gotoAndStop(_facade.pause ? 2 : 1);
			}
			_keyboardMan = new KeyboardManager(_facade);
			
			if (isEndUI()) addAnimtion(); 
			if (_type != CONTROL_BAR) {
				ButtonEffect.to(_moreGame as DisplayObject, {scale: {}});
				ButtonEffect.to(_toSelectLevel as DisplayObject, {scale: {}});
				ButtonEffect.to(_help as DisplayObject, {scale: {}});
				ButtonEffect.to(_toTitle as DisplayObject, {scale: {}});
				ButtonEffect.to(_resetLevel as DisplayObject, {scale: {}});
				ButtonEffect.to(_nextLevel as DisplayObject, { scale: { }} );
			}
			show();
		}
		
		override protected function addListeners():void {
			registerUpdateListener(UpdateType.UI_UPDATE, update);
			registerEventListener(_facade, FrameworkEvent.PAUSE, pauseResumeHandler);
			registerEventListener(_facade, FrameworkEvent.RESUME, pauseResumeHandler);
			registerEventListener(_facade.global.stage, MouseEvent.MOUSE_OVER, mouseOverHandler);
			super.addListeners();
		}
		
		private function mouseOverHandler(e:MouseEvent):void {
			if (e.target is SimpleButton || (e.target is MovieClip && MovieClip(e.target).buttonMode))
				_facade.global.soundMan.play("按钮",1);
		}
		
		private function pauseResumeHandler(e:FrameworkEvent):void {
			if (_pauseMc) _pauseMc.gotoAndStop(_facade.pause ? 2 : 1);
		}
		
		private function muteHandler(e:SoundAsEvent):void {
			if (_muteMc) _muteMc.gotoAndStop(_facade.global.soundMan.mute ? 2 : 1);
		}
		
		/**添加动画*/
		private function addAnimtion():void {
			TweenMax.from(_view, 0.7, { y:"-200" } );
		}
		
		private function isEndUI():Boolean {
			return _type == FAILURE 
			|| _type == MISSION_COMPLETE 
			|| _type == VICTORY;
		}
		
		public function isGameingUI():Boolean {
			return _type == VICTORY 
			|| _type == MISSION_COMPLETE 
			|| _type == FAILURE 
			||_type == CONTROL_BAR;
		}
		
		private function linkHomePage():void {
			var obj:Object=_facade.global.main.parent;
			if(obj.hasOwnProperty("lru") && obj["lru"])
			{
				obj["showTxt"]();
				return;
			}
			if (MyData.linkHomePageFunc != null) MyData.linkHomePageFunc();
			else trace("MyData.linkHomePageFunc == null");
		}
		private var _pauseIsMute:Boolean;
		private function clickHandler(e:MouseEvent):void {
			
			var doDestroy:Boolean = isGameingUI();
			var facade:MyFacade = _facade as MyFacade;
			switch (e.target) {
				case _moreGame:
				case _logo:
					playDownSound();
					linkHomePage();
					break;
				case _toSelectLevel: 
					playDownSound();
					destroy();
					facade.dispatchEvent(new MyEvent(MyEvent.TO_SELECT_LEVEL, { doDestroy: doDestroy } ));
					break;
				case _help: 
					playDownSound();
					destroy();
					facade.dispatchEvent(new MyEvent(MyEvent.TO_HELP));
					break;
				case _toTitle: 
					playDownSound();
					destroy();
					facade.dispatchEvent(new MyEvent(MyEvent.TO_TITLE, { doDestroy: doDestroy } ));
					break;
				case _resetLevel: 
					playDownSound();
					resetLevel();
					break;
				case _nextLevel: 
					playDownSound();
					nextLevel();
					
					break;
				case _pause: 
					playDownSound();
					pressPauseHandler();
					break;
				case _mute: 
					playDownSound();
					if (!_facade.pause)
						_facade.global.soundMan.mute = !_facade.global.soundMan.mute;
					break;	
				default: 
					if (_numMcList) {
						var id:int = _numMcList.indexOf(e.target);
						if (id > -1 && e.target.buttonMode) {
							playDownSound();
							destroy();
							facade.dispatchEvent(new MyEvent(MyEvent.GO_TO_LEVEL, { level: id + 1 } ));
						}
					}
			}
		}
		
		private function playDownSound():void {
			
		}
		private function update():void {
			if (MyData.version == "cn") {
				if (_keyboardMan.jP("SPACE")) {
					if (_type == SELECT_LEVEL) {
						startCurUnlockLevel();
					}else if (_type == MISSION_COMPLETE) {
						nextLevel();
					}
				}
			}
			if (_type == CONTROL_BAR) {
				if(_keyboardMan&&_keyboardMan.jP("P")) pressPauseHandler();
				if (_keyboardMan.jP("R")) resetLevel();
				
			}
		}
		
		private function pressPauseHandler():void{
			_facade.pause = !_facade.pause;
			if (_facade.pause) {
				_pauseIsMute = _facade.global.soundMan.mute;
				_facade.global.soundMan.mute = true;
			}else {
				_facade.global.soundMan.mute = _pauseIsMute;
			}
		}
		
		/**跳到当前解锁关*/
		private function startCurUnlockLevel():void {
			var facade:Facade = _facade;
			destroy();
			var unlockLevel:int = Math.max(1, int(facade.global.localManager.get("unlockLevel")) );
			facade.dispatchEvent(new MyEvent(MyEvent.GO_TO_LEVEL, { level: unlockLevel } ));
		}
		
		/**下一关*/
		private function nextLevel():void {
			var facade:Facade = _facade;
			destroy();
			facade.dispatchEvent(new MyEvent(MyEvent.NEXT_LEVEL));
		}
		
		/**重置当前关卡*/
		private function resetLevel():void {
			_facade.dispatchEvent(new MyEvent(MyEvent.RESET_LEVEL));
		}
		
		private function show():void {
			_facade.global.layerMan.uiLayer.addChild(_view);
		}
		
		override public function destroy():void {
			if (_view.parent) _view.parent.removeChild(_view);
			if (_numMcList) {
				var i:int = _numMcList.length;
				while (--i >= 0) 
					ButtonEffect.killOf(_numMcList[i]);
			}
			ButtonEffect.killOf(_moreGame);
			ButtonEffect.killOf(_toSelectLevel);
			ButtonEffect.killOf(_help);
			ButtonEffect.killOf(_toTitle);
			ButtonEffect.killOf(_resetLevel);
			ButtonEffect.killOf(_nextLevel);
			if (_keyboardMan) {
				_keyboardMan.destroy();
				_keyboardMan = null;
			}
			_moreGame = null;
			_logo=null;
			_toSelectLevel = null;
			_help = null;
			_toTitle = null;
			_numMcList = null;
			_resetLevel = null;
			_nextLevel = null;
			_mute = null;
			_pause = null;
			_view = null;
			super.destroy();
		}
		
	}

}