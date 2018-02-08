package kingBook{
	import Box2D.Dynamics.b2Body;
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import framework.events.FrameworkEvent;
	import framework.objs.GameObject;
	import framework.UpdateType;
	import framework.utils.FuncUtil;
	import g.MyEvent;
	import g.MyObj;
	import g.objs.StandardObject;
	
	/**
	 * 祭坛
	 * @author kingBook
	 * 2015/10/29 16:05
	 */
	public class Altar extends MyObj{
		
		private var _bodies:Vector.<b2Body>;
		private var _mList:Vector.<MovieClip>;
		private var _mc:MovieClip;
		
		public function Altar(){
			super();
		}
		
		override protected function initModelHandler(e:FrameworkEvent):void{
			_bodies=new <b2Body>[e.info.b1,e.info.b2,e.info.b3,e.info.b4,e.info.b5];
			_bodies.fixed=true;
			
			var mc:MovieClip=e.info.mc; _mc=mc;
			_mList=new <MovieClip>[mc.m1,mc.m2,mc.m3,mc.m4,mc.m5];
			_mList.fixed=true;
			
			for each (var b:b2Body in _bodies){
				b.SetUserData({thisObj:this, id:_bodies.indexOf(b)+1, isEmpty:true});
			}
			for each(var m:MovieClip in _mList){
				m.visible=false;
			}
			
		}
		
		public function setEmpty(id:int,value:Boolean):void{
			_bodies[id-1].GetUserData().isEmpty=value;
			_mList[id-1].visible=!value;
			if(!value){
				trace(id);
				if(id==1&&_myFacade.myGlobal.gameLevel==1){
					var hints:Vector.<GameObject>=_facade.getGameObjList(Hint);
					for each(var hint:Hint in hints){
						if(hint.name=="hint2"){
							hint.destroy();
							break;
						}
					}
				}
				_facade.global.soundMan.play("获得物品");
				checkWin();
			}
		}
		
		private var _isWin:Boolean;
		private function checkWin():void{
			var hasEmpty:Boolean=false;
			for each (var b:b2Body in _bodies){
				if(b.GetUserData().isEmpty){
					hasEmpty=true;
					break;
				}
			}
			if(!hasEmpty){
				_isWin=true;
				registerUpdateListener(UpdateType.UPDATE_2,update);
			}
		}
		
		private function update():void{
			if(_isWin){
				var players:Vector.<GameObject>=_facade.getGameObjList(Player);
				var isAllPlayerOnGround:Boolean=true;
				for each (var p:Player in players){
					if(p.inAir){
						isAllPlayerOnGround=false;
						break;
					}
				}
				if(isAllPlayerOnGround){
					logoutUpdateListener(UpdateType.UPDATE_2,update);
					_facade.dispatchEvent(new MyEvent(MyEvent.WIN));
				}
			}
		}
		
		override public function destroy():void{
			for each (var b:b2Body in _bodies){
				_facade.global.curWorld.DestroyBody(b);
			}
			FuncUtil.removeChild(_mc);
			_bodies=null;
			super.destroy();
		}
		
	};

}