package kingBook {
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2MassData;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import fl.motion.AdjustColor;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	import framework.Facade;
	import framework.objs.Clip;
	import framework.utils.Box2dUtil;
	import framework.utils.FuncUtil;
	import framework.utils.LibUtil;
	import g.fixtures.Platform;
	import g.fixtures.SwitcherButton;
	import g.fixtures.SwitcherMovieOneClip;
	import g.fixtures.SwitcherMovieTwoClip;
	import g.fixtures.SwitcherRocker;
	import g.MyData;
	import g.MyFacade;
	import g.objs.FloatingEffect;
	/**
	 * ...
	 * @author kingBook
	 * 2015/8/31 15:04
	 */
	public class ObjectFactory {
		private var _myFacade:MyFacade = MyFacade.getInstance();
		private var _facade:Facade=_myFacade as Facade;
		public function ObjectFactory() {
			super();
		}
		private static var _instance:ObjectFactory;
		public static function get instance():ObjectFactory { return _instance||=new ObjectFactory(); }
		public static function destroyInstance():void{
			if(_instance){
				_instance.onDestroy();
				_instance=null;
			}
		}
		
		private function onDestroy():void{
			_myFacade=null;
			_facade=null;
		}
		
		/**根矩形显示对象创建矩形刚体*/
		private function createBoxFromChild(child:DisplayObject):b2Body{
			return Box2dUtil.createBox(child.width,child.height,child.x,child.y,_facade.global.curWorld,MyData.pixelToMeter);
		}
		
		/**根矩形显示对象创建圆形刚体*/
		private function createCircleFromChild(child:DisplayObject):b2Body{
			return Box2dUtil.createCircle(child.width*0.5,child.x,child.y,_facade.global.curWorld,MyData.pixelToMeter)
		}
		
		/**创建开关*/
		public function createSwitcher(childMc:MovieClip):void{
			var type:String=childMc.type||"button";
			var angleRadian:Number=childMc.rotation*0.01745;
			var w:Number=FuncUtil.getTransformWidth(childMc);
			var h:Number=FuncUtil.getTransformHeight(childMc);
			var body:b2Body=Box2dUtil.createBox(w,h,childMc.x,childMc.y,_facade.global.curWorld,MyData.pixelToMeter);
			body.SetAngle(angleRadian);
			
			var color:String=childMc.color||"red";
			var clip:Clip=Clip.fromDefName(type=="button"?"SwitcherButton_"+color:"SwitcherRocker_"+color,true);
			clip.transform=childMc.transform;
			_facade.global.layerMan.items1Layer.addChildAt(clip,0);
			
			_facade.createGameObj(type=="button"?new SwitcherButton():new SwitcherRocker(),{
				body:body,
				clip:clip,
				isOpen:childMc.isOpen,
				myName:childMc.myName
			});
		}
		/**创建开关影片*/
		public function createSwitcherMovie(childMc:MovieClip):void {
			var type:String=childMc.type||"oneClip";
			if(type=="oneClip") createSwitcherMovieOneClip(childMc);
			else createSwitcherMovieTwoClip(childMc);
		}
		/**创建一个剪辑开关影片*/
		private function createSwitcherMovieOneClip(childMc:MovieClip):void{
			var angleRadian:Number=childMc.rotation*0.01745;
			var w:Number=FuncUtil.getTransformWidth(childMc);
			var h:Number=FuncUtil.getTransformHeight(childMc);
			var body:b2Body=Box2dUtil.createBox(w,h,childMc.x,childMc.y,_facade.global.curWorld,MyData.pixelToMeter);
			body.SetAngle(angleRadian);
			
			var color:String=childMc.color||"red";
			var clip:Clip=Clip.fromDefName("SwitcherMovieOneClip_"+color,true);
			clip.transform=childMc.transform;
			_facade.global.layerMan.items1Layer.addChildAt(clip,0);
			
			_facade.createGameObj(new SwitcherMovieOneClip(),{
				body:body,
				long:w,
				isOpen:childMc.isOpen,
				clip:clip,
				ctrlMySwitcherName:childMc.ctrlMySwitcherName
			});
		}
		/**创建两个剪辑开关影片*/
		private function createSwitcherMovieTwoClip(childMc:MovieClip):void{
			var angleRadian:Number=childMc.rotation*0.01745;
			var w:Number=FuncUtil.getTransformWidth(childMc);
			var h:Number=FuncUtil.getTransformHeight(childMc);
			var body:b2Body=Box2dUtil.createBox(w,h,childMc.x,childMc.y,_facade.global.curWorld,MyData.pixelToMeter);
			body.SetAngle(angleRadian);
			
			var parent:Sprite=_facade.global.layerMan.items1Layer;
			var color:String=childMc.color||"red";
			var clipA:Clip=Clip.fromDefName("SwitcherMovieTwoClipA_"+color,true);
			clipA.transform=childMc.transform;
			var clipB:Clip=Clip.fromDefName("SwitcherMovieTwoClipB_"+color,true);
			clipB.transform=childMc.transform;
			parent.addChildAt(clipB,0);
			parent.addChildAt(clipA,0);
			
			var maskW:Number=w+4; var maskH:Number=h+4;
			var clipAMask:Sprite=new Sprite();
			clipAMask.graphics.beginFill(0,1);
			clipAMask.graphics.drawRect(-maskW*0.5,-maskH*0.5,maskW,maskH);
			clipAMask.graphics.endFill();
			clipAMask.x=childMc.x,clipAMask.y=childMc.y,clipAMask.rotation=childMc.rotation;
			parent.addChild(clipAMask);
			
			_facade.createGameObj(new SwitcherMovieTwoClip(),{
				body:body,
				long:w,
				isOpen:childMc.isOpen,
				clipA:clipA,
				clipB:clipB,
				clipAMask:clipAMask,
				ctrlMySwitcherName:childMc.ctrlMySwitcherName
			});
		}
		
		/**创建平台*/
		public function createPlatform(childMc:MovieClip):void{
			var body:b2Body=createBoxFromChild(childMc);;
			
			var color:String=childMc.color||"red";
			var clip:Clip=Clip.fromDefName("Platform_"+color,true,true,_facade.global.layerMan.items1Layer);
			clip.transform=childMc.transform;
			_facade.createGameObj(new Platform(),{
				body:body,
				clip:clip,
				type:childMc.type||"controlled",
				ctrlMySwitcherName:childMc.ctrlMySwitcherName,
				min:Number(childMc.min),
				max:Number(childMc.max),
				axis:childMc.axis||"y",
				isOneWay:childMc.isOneWay,
				speed:childMc.speed||3
			});
		}
		
		/**创建特效*/
		public function createEffect(defName:String,x:Number,y:Number,parent:DisplayObjectContainer):Clip{
			var clip:Clip=Clip.fromDefName(defName,true);
			clip.x=x,clip.y=y;
			clip.addFrameScript(clip.totalFrames-1,function():void{
				FuncUtil.removeChild(clip);
			});
			parent.addChild(clip);
			return clip;
		}
		
		public function createP1(childMc:MovieClip):void{
			//var body:b2Body=Box2dUtil.createRoundBottomBody(childMc.width,childMc.height,childMc.x,childMc.y,5,0.7,_facade.global.curWorld,MyData.pixelToMeter);
			var body:b2Body=Box2dUtil.createRoundBox(childMc.width,childMc.height,childMc.x,childMc.y,_facade.global.curWorld,MyData.pixelToMeter,5,10);
			body.SetFixedRotation(true);
			body.SetIsIgnoreFrictionY(true);
			_facade.createGameObj(new P1(),{body:body});
		}
		public function createP2(childMc:MovieClip):void{
			//var body:b2Body=Box2dUtil.createRoundBottomBody(childMc.width,childMc.height,childMc.x,childMc.y,5,0.7,_facade.global.curWorld,MyData.pixelToMeter);
			var body:b2Body=Box2dUtil.createRoundBox(childMc.width,childMc.height,childMc.x,childMc.y,_facade.global.curWorld,MyData.pixelToMeter,5,10);
			body.SetFixedRotation(true);
			body.SetIsIgnoreFrictionY(true);
			_facade.createGameObj(new P2(),{body:body});
		}
		
		/**创建宝物*/
		public function createTreasure(childMc:MovieClip,type:int):void{
			var body:b2Body=createBoxFromChild(childMc);;
			var clip:Clip=Clip.fromDefName("Treasure_view",true,true,_facade.global.layerMan.items2Layer,childMc.x,childMc.y);
			clip.controlled=true;
			clip.gotoAndStop(type);
			_facade.createGameObj(new Treasure(),{
				body:body,
				view:clip,
				type:type
			});
		}
		
		/**创建祭坛*/
		public function createAltar(childMc:MovieClip):void{
			var mc:MovieClip=LibUtil.getDefMovie("Altar_view");
			mc.transform=childMc.transform;
			_facade.global.layerMan.items1Layer.addChildAt(mc,0);
			_facade.createGameObj(new Altar(),{
				b1:createSubBody(childMc,"m1"),
				b2:createSubBody(childMc,"m2"),
				b3:createSubBody(childMc,"m3"),
				b4:createSubBody(childMc,"m4"),
				b5:createSubBody(childMc,"m5"),
				mc:mc
			});
		}
		private function createSubBody(parent:MovieClip,childName:String):b2Body{
			var child:DisplayObject=parent.getChildByName(childName);
			var w:Number=child.width*parent.scaleX;
			var h:Number=child.height*parent.scaleY;
			var pos:Point=FuncUtil.localXY(child,_facade.global.layerMan.gameLayer);
			var body:b2Body=Box2dUtil.createBox(w,h,pos.x,pos.y,_facade.global.curWorld,MyData.pixelToMeter);
			body.SetType(b2Body.b2_staticBody);
			body.SetSensor(true);
			return body;
		}
		
		/**创建猪*/
		public function createEnemy1(childMc:MovieClip):void{
			var body:b2Body=createBoxFromChild(childMc);;
			
			var clip:Clip=Clip.fromDefName("Enemy1_walk",true,true,_facade.global.layerMan.items2Layer,childMc.x,childMc.y);
			
			var colorAdjust:AdjustColor = new AdjustColor();
			colorAdjust.brightness = -54;// 亮度
			colorAdjust.contrast = 35;//对比度
			colorAdjust.saturation = -68;//饱和度
			colorAdjust.hue = 0// 色相偏移
			var colorFilter:ColorMatrixFilter = new ColorMatrixFilter(colorAdjust.CalculateFinalFlatArray());
			clip.filters = [colorFilter];
			
			_facade.createGameObj(new Enemy1(),{
				body:body,
				min:childMc.min||0,
				max:childMc.max||1e4,
				view:clip
			});
		}
		
		/**创建黑色飞行鸟*/
		public function createEnemy2(childMc:MovieClip):void{
			var body:b2Body=createBoxFromChild(childMc);;
			var clip:Clip=Clip.fromDefName("Enemy2_view",true,true,_facade.global.layerMan.items2Layer,childMc.x,childMc.y);
			_facade.createGameObj(new Enemy2(),{
				body:body,
				min:childMc.min||0,
				max:childMc.max||1e4,
				axis:childMc.axis||"x",
				view:clip
			});
		}
		
		public function createBeadMaker(childMc:MovieClip):void{
			_facade.createGameObj(new BeadMaker(),{
				x:childMc.x,
				y:childMc.y,
				dy:childMc.dy||1e4
			});
		}
		/**创建水滴*/
		public function createBead(x:Number,y:Number,dy:Number,maker:BeadMaker):void{
			_facade.createGameObj(new Bead(),{
				x:x,
				y:y,
				dy:dy,
				maker:maker
			});
		}
		
		/**创建危险刚体*/
		public function createDangerBody(childMc:MovieClip):void{
			var body:b2Body=createBoxFromChild(childMc);
			body.SetType(b2Body.b2_staticBody);
			body.SetSensor(true);
			body.SetUserData({type:"danger"});
		}
		
		/** 创建石头*/
		public function createStone(childMc:MovieClip):void{
			var body:b2Body=createCircleFromChild(childMc);
			/*var body:b2Body=_facade.global.curWorld.CreateBody(new b2BodyDef());
			var fixtureDef:b2FixtureDef=new b2FixtureDef();
			fixtureDef.isSensor=true;
			fixtureDef.shape=new b2CircleShape(childMc.width*0.5/MyData.pixelToMeter);
			body.CreateFixture(fixtureDef);
			fixtureDef.isSensor=false;
			fixtureDef.shape=new b2CircleShape((childMc.width*0.5/MyData.pixelToMeter)*0.8);
			body.CreateFixture(fixtureDef);
			body.SetPosition(new b2Vec2(childMc.x/MyData.pixelToMeter,childMc.y/MyData.pixelToMeter));
			body.SetType(b2Body.b2_dynamicBody);*/
			
			var clip:Clip=Clip.fromDefName("Stone_view",true,true,_facade.global.layerMan.items1Layer,childMc.x,childMc.y);
			_facade.createGameObj(new Stone(),{
				body:body,
				view:clip
			});
		}
		
		/**创建拿箭的敌人*/
		public function createEnemy3(childMc:MovieClip):void{
			var body:b2Body=createBoxFromChild(childMc);;
			var clip:Clip=Clip.fromDefName("Enemy3_walk",true,true,_facade.global.layerMan.items2Layer,childMc.x,childMc.y);
			_facade.createGameObj(new Enemy3(),{
				body:body,
				min:childMc.min||0,
				max:childMc.max||1e4,
				view:clip
			});
		}
		/**减血特效 x,y像素为单位*/
		public function createSubHpEffect(x:Number,y:Number):void{
			var clip:Clip=Clip.fromDefName("TextEffect",true,true,_facade.global.layerMan.effLayer,x,y);
			_facade.createGameObj(new FloatingEffect(),{view:clip});
		}
		
		/**创建第一关的提示*/
		public function craeteHint(childMc:MovieClip):void{
			var body:b2Body=createBoxFromChild(childMc);
			var clip:Clip=Clip.fromDisplayObject(childMc);
			_facade.global.layerMan.items2Layer.addChildAt(clip,0);
			_facade.createGameObj(new Hint(),{
				body:body,
				view:clip,
				name:childMc.name
			});
			
		}
		
		
		
	};

}