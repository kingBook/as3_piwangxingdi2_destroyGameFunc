package demo {
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import framework.events.FrameworkEvent;
	import framework.UpdateType;
	import framework.utils.Box2dUtil;
	import framework.utils.FuncUtil;
	import g.MyData;
	import g.MyEvent;
	import g.MyObj;
	/**
	 * ...
	 * @author kingBook
	 * 2014-10-10 14:43
	 */
	public class TestObj extends MyObj{
		private var sp:Sprite;
		private var bb:Sprite;
		private var cc:Sprite;
		private var b:b2Body;
		public function TestObj() {
			super();
			trace("new player");
		}
		
		override protected function addListeners():void {
			registerUpdateListener(UpdateType.UPDATE_2,update);
			super.addListeners();
		}
		
		override protected function initModelHandler(e:FrameworkEvent):void {
			sp = new Sprite();
			sp.graphics.beginFill(0xff0000,1);
			sp.graphics.drawRect( -20, -20, 40, 40)
			sp.graphics.endFill();
			_facade.global.layerMan.items0Layer.addChild(sp);
			//
			b = Box2dUtil.createBox(50,50, 200, 200, _facade.global.curWorld,MyData.pixelToMeter);
			b.SetBullet(true);
			Box2dUtil.createPolygon(200,200,new <b2Vec2>[new b2Vec2(-30,-30),new b2Vec2(30,-30),new b2Vec2(30,30)],_facade.global.curWorld,MyData.pixelToMeter).SetType(b2Body.b2_kinematicBody);
			//
			var bodyDef:b2BodyDef = new b2BodyDef();
			var body:b2Body = _facade.global.curWorld.CreateBody(bodyDef);
			
			var s:b2PolygonShape = b2PolygonShape.AsBox(50/MyData.pixelToMeter,50/MyData.pixelToMeter);
			var fixtureDef:b2FixtureDef=new b2FixtureDef();
			fixtureDef.shape=s;
			body.CreateFixture(fixtureDef);
			
			s=b2PolygonShape.AsOrientedBox(50/MyData.pixelToMeter,50/MyData.pixelToMeter,new b2Vec2(50/MyData.pixelToMeter,50/MyData.pixelToMeter));
			//fixtureDef=new b2FixtureDef();
			fixtureDef.shape=s;
			body.CreateFixture(fixtureDef);
			
			body.SetType(b2Body.b2_dynamicBody);
			body.SetPosition(new b2Vec2(300/MyData.pixelToMeter,100/MyData.pixelToMeter));
			//body.SetFixedRotation(true);
			//Box2dUtil.fixedBody(body,_facade.global.curWorld);
			//
			var bbb:b2Body=Box2dUtil.createRoundBottomBody(40,60,200,200,5,0.5,_facade.global.curWorld,MyData.pixelToMeter)
			
			
			//胜利按钮
			bb = createBtn(150, 100, "胜利", _facade.global.layerMan.items3Layer);
			bb.name = "胜利";
			//失败按钮
			cc = createBtn(250, 100, "失败", _facade.global.layerMan.items3Layer);
			cc.name = "失败";
			bb.addEventListener(MouseEvent.CLICK, clickHandler);
			cc.addEventListener(MouseEvent.CLICK, clickHandler);
			
			//滚动地图
			_facade.global.scorllMan.addToTargetList(b);
		}
		
		private function clickHandler(e:MouseEvent):void {
			var targetName:String=e.target["name"];
			switch (targetName) {
				case "胜利":
					trace("发送胜利");
					_facade.dispatchEvent(new MyEvent(MyEvent.WIN));
					break;
				case "失败":
					trace("发送失败");
					_facade.dispatchEvent(new MyEvent(MyEvent.FAILURE));
					break;
				default:
			}
		}
		
		private function createBtn(x:Number,y:Number,text:String, parent:Sprite):Sprite {
			var sp:Sprite = new Sprite();
			sp.x = x;
			sp.y = y;
			sp.graphics.beginFill(0xcccccc, 1);
			sp.graphics.drawRect(0, 0, 60, 20);
			sp.graphics.endFill();
			var txt:TextField = new TextField();
			txt.textColor = 0x0000ff;
			txt.text = text;
			txt.width = 60;
			txt.height = 20;
			sp.addChild(txt);
			parent.addChild(sp);
			sp.mouseChildren = false;
			sp.buttonMode = true;
			return sp;
		}
		
		private function update():void{
			sp.x = b.GetPosition().x*MyData.pixelToMeter;
			sp.y = b.GetPosition().y*MyData.pixelToMeter;
			sp.rotation = b.GetAngle()*57.3;
		}
		
		override public function destroy():void {
			trace("destroy TestObj");
			bb.removeEventListener(MouseEvent.CLICK, clickHandler);
			cc.removeEventListener(MouseEvent.CLICK, clickHandler);
			FuncUtil.removeChild(bb);
			FuncUtil.removeChild(cc);
			FuncUtil.removeChild(sp);
			_facade.global.curWorld.DestroyBody(b);
			b = null;
			bb = null;
			cc = null;
			sp = null;
			super.destroy();
		}
	}

}