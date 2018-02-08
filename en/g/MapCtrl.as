package g {
	import Box2D.Dynamics.b2Body;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;
	import framework.events.FrameworkEvent;
	import framework.events.ScorllEvent;
	import framework.objs.Clip;
	import framework.system.ObjectPool;
	import framework.utils.Box2dUtil;
	import g.Assets;
	import g.MyCtrl;
	import g.MyData;
	import g.MyEvent;
	import kingBook.ObjectFactory;
	/**
	 * ...
	 * @author kingBook
	 * 2014-10-13 9:02
	 */
	public class MapCtrl extends MyCtrl {
		private function get _myModel():MapModel { return _model as MapModel; }
		public function MapCtrl() {
			super();
		}
		public static var ID:int;
		override public function setId(value:int):void {
			_id = ID = value;
		}
		
		override protected function addListeners():void {
			registerEventListener(this, MyEvent.UPDATE_MAP_BODIES, updateMapBodies);
			registerEventListener(this, MyEvent.UPDATE_BITMAP_DATA, updateBitmapData);
			registerEventListener(this, MyEvent.CREATE_ITEMS, createItems);
			registerEventListener(_facade.global.scorllMan, ScorllEvent.UPDATE, scorllUpdate);
			super.addListeners();
		}
		
		override protected function initModelHandler(e:FrameworkEvent):void {
			_myModel.offset = 10;
			_myModel.configObj = MapData.getMapConfigObj(_myFacade.myGlobal.gameLevel);
			var size:Object = _myModel.configObj.size;
			_myModel.width = size.width;
			_myModel.height = size.height;
			trace(_myModel.width,_myModel.height);
			//if(MyData)_facade.global.napeDebug.setSize(_myModel.width, _myModel.height);
			_myModel.xml = Assets.getInstance().getMapXML(_myFacade.myGlobal.gameLevel);
		}
		
		override protected function initStatusHandler():void {
			_facade.global.scorllMan.setMapSize(_myModel.width, _myModel.height);
		}
		
		private function scorllUpdate(e:ScorllEvent):void {
			var vx:Number = e.info.vx;
			var vy:Number = e.info.vy;
			_myModel.updateWallMaskViewBmd(vx, vy);
			_myModel.updateWallViewBmd(vx, vy);
			_myModel.updateBgMidViewBmd(vx, vy);
			_myModel.updateBgViewBmd(vx, vy);
		}
		
		private function updateMapBodies(e:MyEvent):void {
			if (! e.info.hit) return;
			var lt:int = getTimer();
			
			var mapBodies:Vector.<b2Body> = new Vector.<b2Body>();
			//碰撞区刚体列表
			var hitBodies:Vector.<b2Body> = _myModel.createHitBodies(e.info.hit, setBodyPropertys);
			mapBodies = mapBodies.concat(hitBodies);
			//地图边缘刚体列表
			var wrapBodies:Vector.<b2Body> = Box2dUtil.getWrapWallBodies(0, -20, _myModel.width, _myModel.height+20 + 10,_facade.global.curWorld,MyData.pixelToMeter);
			for each (var b:b2Body in wrapBodies) setBodyPropertys(b,"edge");
			mapBodies = mapBodies.concat(wrapBodies);
			
			_myModel.mapBodies = mapBodies;
			trace("level: " + _myFacade.myGlobal.gameLevel + " createMapTotalTime:", getTimer() - lt, "ms");
		}
		
		private function updateBitmapData(e:MyEvent):void {
			_myModel.updateSourceBitmapData(e.info.bg, e.info.bgMid, e.info.wall, e.info.wallMask, e.info.bgEff, e.info.wallEff);
		}
		
		private function setBodyPropertys(b:b2Body, typeId:String):void {
			b.SetType(b2Body.b2_staticBody);//所有地图刚体为静态
			switch (typeId) {
				//地面
				case "ground" :
					Box2dUtil.setBodyFixture(b,1,0.6);
					b.SetUserData({type:"ground"});
					break;
				//危险物
				case "danger" :
					b.SetSensor(true);
					b.SetUserData({type:"danger"});
					break;
				case "edge":
					b.SetUserData({type:"edgeGround"});
					break;
				default :
			}
		}
		
		private function createItems(e:MyEvent):void {
			var sprite:Sprite = e.info.mapItems;
			var len:int = sprite.numChildren;
			var childMc:MovieClip;
			for(var i:int; i<len; i++){
				childMc = sprite.getChildAt(i) as MovieClip;
				var qName:String = getQualifiedClassName(childMc);
				switch (qName) {
					case "Switcher_pos":
						ObjectFactory.instance.createSwitcher(childMc);
						break;
					case "SwitcherMovie_pos":
						ObjectFactory.instance.createSwitcherMovie(childMc);
						break;
					case "Platform_pos":
						ObjectFactory.instance.createPlatform(childMc);
						break;
					case "P1_pos":
						ObjectFactory.instance.createP1(childMc);
						break;
					case "P2_pos":
						ObjectFactory.instance.createP2(childMc);
						break;
					case "Altar_pos":
						ObjectFactory.instance.createAltar(childMc);
						break;
					case "Enemy1_pos":
						ObjectFactory.instance.createEnemy1(childMc);
						break;
					case "Enemy2_pos":
						ObjectFactory.instance.createEnemy2(childMc);
						break;
					case "Enemy3_pos":
						ObjectFactory.instance.createEnemy3(childMc);
						break;
					case "BeadMaker_pos":
						ObjectFactory.instance.createBeadMaker(childMc);
						break;
					case "Stone_pos":
						ObjectFactory.instance.createStone(childMc);
						break;
					default:
				}
				if(childMc.name=="danger"){
					ObjectFactory.instance.createDangerBody(childMc);
				}else if(childMc.name.indexOf("hint")>-1){
					ObjectFactory.instance.craeteHint(childMc);
				}
				
				if(qName.indexOf("Treasure_pos")>-1){
					var type:int=int(qName.substr(qName.length-1,1));
					ObjectFactory.instance.createTreasure(childMc,type);
				}
			}
			
		}
		override public function destroy():void {
			ObjectFactory.destroyInstance();
			super.destroy();
		}
		
	};

}