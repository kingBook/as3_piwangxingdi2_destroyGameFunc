package g {
	import flash.display.Sprite;
	import flash.text.TextField;
	import framework.events.FrameworkEvent;
	import framework.utils.FuncUtil;
	import g.MyObj;
	/**
	 * ...
	 * @author kingBook
	 * 2014-10-10 11:22
	 */
	public class GameMessageUI extends MyObj {
		private var _view:Sprite;
		public function GameMessageUI() {
			super();
		}
		
		public static var ID:int=-1;
		override public function setId(value:int):void{
			_id=ID=value;
		}
		
		override protected function initModelHandler(e:FrameworkEvent):void {
			_view = e.info.viewComponent;
			//level text
			var lvTxt:TextField = _view.getChildByName("lvTxt") as TextField;
			lvTxt.text = (_myFacade.myGlobal.gameLevel < 10?"0":"") + _myFacade.myGlobal.gameLevel;
			//
			show();
		}
		
		private var _hpTxt:TextField;
		public function updateHpTxt(text:String):void{
			_hpTxt||=_view.getChildByName("hpTxt") as TextField;
			_hpTxt.text=text;
		}
		
		private function show():void {
			_facade.global.layerMan.uiLayer.addChild(_view);
		}
		override public function destroy():void {
			FuncUtil.removeChild(_view);
			_view = null;
			super.destroy();
		}
		
	}

}