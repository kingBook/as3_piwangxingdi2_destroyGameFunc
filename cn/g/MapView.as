package g {
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import framework.utils.FuncUtil;
	import framework.utils.LibUtil;
	import g.MapModel;
	import g.MyEvent;
	import g.MyModel;
	import g.MyView;
	
	/**
	 * ...
	 * @author kingBook
	 * 2014-10-13 9:05
	 */
	public class MapView extends MyView {
		private function get _myModel():MapModel { return _model as MapModel; }
		private var _bgBmp:Bitmap;
		private var _bgMidBmp:Bitmap;
		private var _wallBmp:Bitmap;
		private var _wallMaskBmp:Bitmap;
		private var _mapEffect:MovieClip;
		public function MapView() {
			super();
		}
		public static var ID:int;
		override public function setId(value:int):void {
			_id = ID = value;
		}
		
		override protected function addListeners():void {
			registerEventListener(_model, MyEvent.RESET_BITMAP_POSITION, resetBitMapPosHandler);
			super.addListeners();
		}
		
		override protected function initModelComplete():void {
			_bgBmp = new Bitmap();
			_bgBmp.x = _bgBmp.y = -_myModel.offset;
			
			_bgMidBmp = new Bitmap();
			_bgMidBmp.x = _bgMidBmp.y = -_myModel.offset;
			
			_wallBmp = new Bitmap();
			_wallBmp.x = _wallBmp.y =  -_myModel.offset;
			
			_wallMaskBmp = new Bitmap();
			_wallMaskBmp.x = _wallMaskBmp.y = -_myModel.offset;
			initView();
			setBmp();
			show();
			//创建物品
			var mapItems:MovieClip = getDefMovieGoToAndStop(_myModel.configObj.items,false);
			_controller.dispatchEvent(new MyEvent(MyEvent.CREATE_ITEMS, { mapItems: mapItems } ));
			//停止
			mapItems && mapItems.gotoAndStop(mapItems.totalFrames);
		}
		
		/**初始视图，刷新BitmapData, bodies*/
		private function initView():void {
			var hit:MovieClip;
			var bg:MovieClip;
			var wall:MovieClip;
			var wallEff:MovieClip;
			var bgMid:MovieClip;
			var bgEff:MovieClip;
			var wallMask:MovieClip;
			//碰撞区
			hit = getDefMovieGoToAndStop(_myModel.configObj.hit, true);
			//发送刷新地图刚体事件
			_controller.dispatchEvent(new MyEvent(MyEvent.UPDATE_MAP_BODIES, { hit: hit } ));
			//背景
			bg = getDefMovieGoToAndStop(_myModel.configObj.bg, true);
			//墙
			wall = getDefMovieGoToAndStop(_myModel.configObj.wall, true);
			//墙特效
			wallEff = getDefMovieGoToAndStop(_myModel.configObj.wallEff, true);
			//中层背景
			bgMid = getDefMovieGoToAndStop(_myModel.configObj.bgMid, true);
			//背景特效
			bgEff = getDefMovieGoToAndStop(_myModel.configObj.bgEff, true);
			//墙前遮挡层
			wallMask = getDefMovieGoToAndStop(_myModel.configObj.wallMask, true);
			//地图特效层
			FuncUtil.removeChild(_mapEffect);
			_mapEffect = getDefMovieGoToAndStop(_myModel.configObj.effect, true);
			//发送刷新位图数据事件
			var info:* = { bg:bg, wall:wall, bgMid:bgMid, wallMask:wallMask, bgEff:bgEff, wallEff:wallEff };
			_controller.dispatchEvent(new MyEvent(MyEvent.UPDATE_BITMAP_DATA, info));
			//各元件跳至空白帧并停止
			hit && hit.gotoAndStop(hit.totalFrames);
			bg && bg.gotoAndStop(bg.totalFrames);
			wall && wall.gotoAndStop(wall.totalFrames);
			wallEff && wallEff.gotoAndStop(wallEff.totalFrames);
			bgMid && bgMid.gotoAndStop(bgMid.totalFrames);
			bgEff && bgEff.gotoAndStop(bgEff.totalFrames);
			wallMask && wallMask.gotoAndStop(wallMask.totalFrames);
		}
		private function getDefMovieGoToAndStop(obj:*, addToPool:Boolean = false):MovieClip {
			if (!obj) return null;
			var movie:MovieClip = LibUtil.getDefMovie(obj.name, addToPool);
			movie.gotoAndStop(obj.frame);
			return movie;
		}
		
		private function setBmp():void {
			_bgBmp.bitmapData = _myModel.bgViewBmd;
			_bgMidBmp.bitmapData = _myModel.bgMidViewBmd;
			_wallBmp.bitmapData = _myModel.wallViewBmd;
			_wallMaskBmp.bitmapData = _myModel.wallMaskViewBmd;
		}
		
		private function resetBitMapPosHandler(e:MyEvent):void {
			var vx:Number = e.info.vx;
			var vy:Number = e.info.vy;
			var name:String = e.info.name;
			switch (name) {
				case "wall": 
					_wallBmp.x += -vx;
					_wallBmp.y += -vy;
					break;
				case "mask": 
					_wallMaskBmp.x += -vx;
					_wallMaskBmp.y += -vy;
					break;
				default: 
			}
		}
		
		private var _added:Boolean;
		override protected function show():void {
			if (_mapEffect) _facade.global.layerMan.effLayer.addChild(_mapEffect);
			if (_added) return;
			_added = true;
			FuncUtil.addChildListToContainer(_myModel.mapBgEffClipList, _facade.global.layerMan.items0Layer);
			_facade.global.layerMan.bgLayer.addChild(_bgBmp);
			_facade.global.layerMan.bgLayer.addChild(_bgMidBmp);
			_facade.global.layerMan.items1Layer.addChild(_wallBmp);
			FuncUtil.addChildListToContainer(_myModel.wallEffClipList, _facade.global.layerMan.items1Layer);
			_facade.global.layerMan.items3Layer.addChild(_wallMaskBmp);
		}
		
		override public function destroy():void {
			FuncUtil.removeChildList(_myModel.mapBgEffClipList);
			FuncUtil.removeChildList(_myModel.wallEffClipList);
			FuncUtil.removeChild(_bgBmp);
			FuncUtil.removeChild(_bgMidBmp);
			FuncUtil.removeChild(_wallBmp);
			FuncUtil.removeChild(_wallMaskBmp);
			FuncUtil.removeChild(_mapEffect);
			_mapEffect = null;
			_wallBmp = null;
			_wallMaskBmp = null;
			_bgMidBmp = null;
			_bgBmp = null;
			super.destroy();
		}
	}

}