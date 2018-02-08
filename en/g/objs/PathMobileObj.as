package g.objs{
	import Box2D.Dynamics.b2Body;
	import framework.events.FrameworkEvent;
	import framework.UpdateType;
	import g.MyData;
	import g.MyObj;
	import Box2D.Common.Math.b2Vec2;
	/**
	 * 给一个路径点列表，根据这个列表上的点移动
	 * @author kingBook
	 * 2015/10/30 12:05
	 */
	public class PathMobileObj extends MovableObject{
		protected var _speed:Number=3;
		protected var _points:Vector.<b2Vec2>=new Vector.<b2Vec2>();//b2World为单位
		protected var _curId:int;
		public function PathMobileObj(){
			super();
		}
		override protected function addListeners():void{
			registerUpdateListener(UpdateType.UPDATE_2,update);
			super.addListeners();
		}
		override protected function initModelHandler(e:FrameworkEvent):void{
			super.initModelHandler(e);
			_body.SetType(b2Body.b2_kinematicBody);
			//设最近点为起点
			var dList:Array=[],pos:b2Vec2=_body.GetPosition();
			var i:int=_points.length;
			while(--i>=0) dList.push({id:i,distance:b2Vec2.Distance(_points[i],pos)});
			dList.sortOn("distance",Array.NUMERIC);
			_curId=dList.length>=2?dList[0].id:0;
			
		}
		private function update():void{
			if(_points.length<2)return;
			if(gotoPoint(_points[_curId])){
				_curId++; if(_curId>=_points.length)_curId=0;
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
		override public function destroy():void{
			_points=null;
			super.destroy();
		}
	};

}