package g {
	import Box2D.Dynamics.b2Body;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getQualifiedClassName;
	import framework.objs.Clip;
	import framework.system.ObjectPool;
	import framework.utils.Box2dUtil;
	import g.MyData;
	import g.MyEvent;
	import g.MyModel;
	
	/**
	 * ...
	 * @author kingBook
	 * 2014-10-13 9:05
	 */
	public class MapModel extends MyModel {
		public var offset:int;
		public var width:Number;
		public var height:Number;
		public var configObj:*;
		public var xml:XML;
		public var mapBodies:Vector.<b2Body>;
		/**底层背景*/
		public var bgSourceBmd:BitmapData;
		public var bgViewBmd:BitmapData;
		public var bgViewRect:Rectangle;
		/**中层背景*/
		public var bgMidSourceBmd:BitmapData;
		public var bgMidViewBmd:BitmapData;
		public var bgMidViewRect:Rectangle;
		/**墙*/
		public var wallSourceBmd:BitmapData;
		public var wallViewBmd:BitmapData;
		public var wallViewRect:Rectangle;
		/** 墙mask*/
		public var wallMaskSourceBmd:BitmapData;
		public var wallMaskViewBmd:BitmapData;
		public var wallMaskViewRect:Rectangle;
		
		public var mapBgEffClipList:Vector.<Clip>;
		public var wallEffClipList:Vector.<Clip>;
		
		private var _restBmpEvt:MyEvent = new MyEvent(MyEvent.RESET_BITMAP_POSITION);
		private var _dt:Point = new Point(0,0);
		private var _mat:Matrix;
		
		public static var ID:int;
		override public function setId(value:int):void  {
			_id = ID = value;
		}
		public function MapModel() {
			super();
		}
		
		public function createHitBodies(hitSp:Sprite, setBodyPropFunc:Function):Vector.<b2Body> {
			if (!width || !height) throw new Error("width或height未初始化");
			var bodies:Vector.<b2Body> = new Vector.<b2Body>();
			// 创建xml刚体 
			if (xml) {
				var xmlBodies:Vector.<b2Body> = Box2dUtil.getXmlBodies(xml, width, height,_facade.global.curWorld,MyData.pixelToMeter);
				for each (var bb:b2Body in xmlBodies){
					setBodyPropFunc.apply(null,  [bb, "ground"]);//设置刚体属性为地面
				}
				if(xmlBodies)bodies=bodies.concat(xmlBodies);
			}
			// 创建图形刚体 
			if (hitSp) {
				var spBodies:Vector.<b2Body>=new Vector.<b2Body>();
				var i:uint = hitSp.numChildren;
				var obj:DisplayObject;
				var b:b2Body;
				var childName:String;
				var type:int;
				while (--i >= 0) {
					obj = hitSp.getChildAt(i);
					if(obj is MovieClip||obj is Sprite){
						b = Box2dUtil.createBox(obj.width, obj.height,obj.x, obj.y,_facade.global.curWorld,MyData.pixelToMeter);
						childName = (obj as MovieClip).childName;
						childName ||= "ground";
						setBodyPropFunc.apply(null, [b, childName]);//名称作为类型，设置刚体属性
						spBodies.push(b);
					}
				}
				bodies=bodies.concat(spBodies);
			}
			return bodies;
		}
		
		public function updateSourceBitmapData(bg:Sprite, bgMid:Sprite, wall:Sprite, wallMask:Sprite, bgEff:Sprite, wallEff:Sprite):void {
			_mat ||= new Matrix(1, 0, 0, 1, offset, offset);
			//刷新底层背景数据 
			if (bg) {
				bgSourceBmd = getSourceBmdFromPool(bg,_mat);
				updateBgViewBmd();
			} else {
				bgSourceBmd = null;
				if (bgViewBmd) {
					bgViewBmd.dispose();
					bgViewBmd = null;
				}
			}
			//刷新中层背景数据
			if (bgMid) {
				bgMidSourceBmd = getSourceBmdFromPool(bgMid,_mat);
				updateBgMidViewBmd();
			} else {
				bgMidSourceBmd = null;
				if (bgMidViewBmd) {
					bgMidViewBmd.dispose();
					bgMidViewBmd = null;
				}
			}
			//刷新地图墙数据
			if (wall) {
				wallSourceBmd = getSourceBmdFromPool(wall,_mat);
				updateWallViewBmd();
			} else {
				wallSourceBmd = null;
				if (wallViewBmd) {
					wallViewBmd.dispose();
					wallViewBmd = null;
				}
			}
			//刷新地图墙mask数据
			if (wallMask) {
				wallMaskSourceBmd = getSourceBmdFromPool(wallMask,_mat);
				updateWallMaskViewBmd();
			} else {
				wallMaskSourceBmd = null;
				if (wallMaskViewBmd) {
					wallMaskViewBmd.dispose();
					wallMaskViewBmd = null;
				}
			}
			//刷新背景特效clip列表
			if (bgEff) mapBgEffClipList = containerToClipList(bgEff,"mapBgEff");
			//刷新墙特效clip列表
			if (wallEff) wallEffClipList = containerToClipList(wallEff,"wallEff");
		}
		
		/**源位图数据是不变的，不可见的，所以保存到对象池，并且不可以执行dispose()*/
		public function getSourceBmdFromPool(disO:DisplayObject, mat:Matrix):BitmapData {
			var pool:ObjectPool = _facade.global.objectPool;
			var bmd:BitmapData;
			var key:String = "sourceBmd_" + getQualifiedClassName(disO)+"_"+_myFacade.myGlobal.gameLevel;
			if (pool.has(key)) {
				bmd = pool.get(key) as BitmapData;
			} else {
				bmd = getSourceBmd();
				bmd.draw(disO, mat);
				pool.add(bmd, key);
			}
			return bmd;
		}
		
		public function updateBgViewBmd(vx:Number = 0, vy:Number = 0):void {
			if (! bgSourceBmd) return;
			vx *=  0.5;
			vy *=  0.8;
			bgViewBmd ||=  getViewBmd();
			bgViewRect ||=  getViewRect();
			bgViewRect.offset(-vx, -vy);
			bgViewBmd.fillRect(bgViewRect, 0);
			bgViewBmd.copyPixels(bgSourceBmd, bgViewRect, _dt);
		}
		
		public function updateBgMidViewBmd(vx:Number = 0, vy:Number = 0):void {
			if (! bgMidSourceBmd) return;
			vx *=  0.7;
			vy *=  0.9;
			bgMidViewBmd ||=  getViewBmd();
			bgMidViewRect ||=  getViewRect();
			bgMidViewRect.offset(-vx, -vy);
			bgMidViewBmd.fillRect(bgMidViewRect, 0);
			bgMidViewBmd.copyPixels(bgMidSourceBmd, bgMidViewRect, _dt);
		}
		
		public function updateWallViewBmd(vx:Number = 0, vy:Number = 0):void {
			if (! wallSourceBmd) return;
			wallViewBmd ||=  getViewBmd();
			wallViewRect ||=  getViewRect();
			wallViewRect.offset(-vx, -vy);
			wallViewBmd.fillRect(wallViewRect, 0);
			wallViewBmd.copyPixels(wallSourceBmd, wallViewRect, _dt);
			_restBmpEvt.info = {name:"wall",vx:vx,vy:vy};
			dispatchEvent(_restBmpEvt);
		}
		
		public function updateWallMaskViewBmd(vx:Number = 0, vy:Number = 0):void {
			if (!wallMaskSourceBmd) return;
			_restBmpEvt.info = {name:"mask",vx:vx,vy:vy};
			dispatchEvent(_restBmpEvt);
			wallMaskViewRect ||=  getViewRect();
			wallMaskViewRect.offset(-vx, -vy);
			if (!wallMaskSourceBmd)return;
			wallMaskViewBmd ||=  getViewBmd();
			wallMaskViewBmd.fillRect(wallMaskViewRect, 0);
			wallMaskViewBmd.copyPixels(wallMaskSourceBmd, wallMaskViewRect, _dt);
		}
		
		private function getSourceBmd():BitmapData {
			return new BitmapData(width + offset * 2, height + offset * 2, true, 0);
		}
		
		private function getViewBmd():BitmapData {
			return new BitmapData(MyData.stageW + offset * 2, MyData.stageH + offset * 2, true, 0);
		}

		private function getViewRect():Rectangle {
			return new Rectangle(0, 0, MyData.stageW + offset * 2, MyData.stageH + offset * 2);
		}
		
		private function containerToClipList(c:DisplayObjectContainer,poolKey:String=null):Vector.<Clip >  {
			var i:uint = c.numChildren;
			var list:Vector.<Clip >  = new Vector.<Clip > (i,true);

			var child:DisplayObject;
			var clip:Clip;

			while (--i >= 0) {
				child = c.getChildAt(i);
				//1.
				var defName:String = getQualifiedClassName(child);
				if(defName.indexOf("flash.display::")<0){
					clip = Clip.fromDefName(defName, true);
					clip.transform = child.transform;
				}else {
					clip = Clip.fromDisplayObject(child);
				}
				//2.
				//clip = Clip.fromDisplayObject(child);
				
				list[i] = clip;
			  
			}
			return list;
		}
		
		override public function destroy():void {
			/**源位图数据会保存到对象池中，不执行dispose()*/
			bgSourceBmd = null;
			bgMidSourceBmd = null;
			wallSourceBmd = null;
			wallMaskSourceBmd = null;
			//--------------------------------------------
			if (bgViewBmd) {
				bgViewBmd.dispose();
				bgViewBmd = null;
			}
			if (bgMidViewBmd) {
				bgMidViewBmd.dispose();
				bgMidViewBmd = null;
			}
			if (wallViewBmd) {
				wallViewBmd.dispose();
				wallViewBmd = null;
			}
			if (wallMaskViewBmd) {
				wallMaskViewBmd.dispose();
				wallMaskViewBmd = null;
			}
			bgViewRect = null;
			bgMidViewRect = null;
			wallViewRect = null;
			wallMaskViewRect = null;
			
			mapBgEffClipList = null;
			mapBodies = null;
			configObj = null;
			xml = null;
			_restBmpEvt = null;
			_mat = null;
			_dt = null;
			super.destroy();
		}
		
	}

}