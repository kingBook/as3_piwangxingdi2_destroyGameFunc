package kingBook{
	import Box2D.Common.Math.b2Math;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import framework.events.FrameworkEvent;
	import framework.UpdateType;
	import g.MyData;
	import g.objs.StandardObject;
	
	/**
	 * 宝物
	 * @author kingBook
	 * 2015/10/29 9:20
	 */
	public class Treasure extends StandardObject{
		private var _minPos:b2Vec2;
		private var _maxPos:b2Vec2;
		private var _tPos:b2Vec2;
		private var _speed:Number=0.5;
		private var _type:int;
		
		public function Treasure(){
			super();
		}
		
		override protected function addListeners():void{
			registerUpdateListener(UpdateType.UPDATE_2,update);
			super.addListeners();
		}
		
		override protected function initModelHandler(e:FrameworkEvent):void{
			super.initModelHandler(e);
			_type=e.info.type;
			_body.SetType(b2Body.b2_kinematicBody);
			_body.SetSensor(true);
			
			var pos:b2Vec2=_body.GetPosition();
			_minPos=new b2Vec2(pos.x,pos.y-5/MyData.pixelToMeter);
			_maxPos=new b2Vec2(pos.x,pos.y+5/MyData.pixelToMeter);
			
			_body.SetPosition(Math.random()>0.5?_minPos:_maxPos);
			_tPos=isEqualPos(_minPos)?_maxPos:_minPos;
			syncView();
		}
		
		private function isEqualPos(v2:b2Vec2):Boolean{
			var pos:b2Vec2=_body.GetPosition();
			return pos.x==v2.x&&pos.y==v2.y;
		}
		
		private function update():void{
			syncView();
			if(gotoPoint(_tPos)){
				_tPos=isEqualPos(_minPos)?_maxPos:_minPos;
			}
		}
		
		private function gotoPoint(pos:b2Vec2):Boolean{
			var dx:Number=(pos.x-_body.GetPosition().x)*MyData.pixelToMeter;
			var dy:Number=(pos.y-_body.GetPosition().y)*MyData.pixelToMeter;
			var c:Number=Math.sqrt(dx*dx+dy*dy);
			if(c>_speed){
				var angleRadian:Number=Math.atan2(dy,dx);
				var vx:Number=Math.cos(angleRadian)*_speed;
				var vy:Number=Math.sin(angleRadian)*_speed;
				_body.SetLinearVelocity(new b2Vec2(vx,vy));
				_body.SetAwake(true);
			}else{
				_body.SetLinearVelocity(new b2Vec2(0,0));
				_body.SetPosition(pos);
				return true;
			}
			return false;
		}
		
		public function playerEat(callback:Function):void{
			if(_isDestroy)return;
			callback(this);
			_facade.global.soundMan.play("获得物品");
			destroy();
		}
		
		private var _isDestroy:Boolean;
		override public function destroy():void{
			if(_isDestroy)return;
			_isDestroy=true;
			_tPos=_minPos=_maxPos=null;
			super.destroy();
		}
		
		public function get type():int{return _type;}
		
	};

}