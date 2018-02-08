package g {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import framework.Facade;
	import framework.objs.Clip;
	import framework.UpdateType;
	import framework.utils.FuncUtil;
	/**
	 * ...
	 * @author kingBook
	 * 2015-02-25 11:38
	 */
	[Event(name="change", type="flash.events.Event")] 
	public dynamic class Animator extends EventDispatcher{
		private var _animations:*;
		private var _container:DisplayObjectContainer;
		private var _facade:Facade;
		private var _curAnimation:DisplayObject;
		private var _curAniKey:String;
		private var _transitionConditions:*;
		
		private var _x:Number = 0;
		private var _y:Number = 0;
		private var _rotation:Number=0;
		private var _scaleX:Number = 1;
		private var _scaleY:Number = 1;
		private const ANY_STATE:String = "anyState";
		
		public function Animator(facade:Facade,container:DisplayObjectContainer) {
			_animations = { };
			_transitionConditions = { };
			_container = container;
			_facade = facade;
			_facade.addUpdateListener(UpdateType.UPDATE_2, update);
		}
		/**添加动画*/
		public function addAnimation(name:String, animation:DisplayObject = null):void {
			if (animation is Clip) { (animation as Clip).removeIsDestroy = false; }
			_animations[name] = animation;
		}
		/**
		 * 添加过渡条件
		 * @param	name1  !name1 时为任意状态
		 * @param	name2
		 * @param	condition 一个返回Boolean类型的Function
		 */
		public function addTransitionCondition(name1:String, name2:String, condition:Function):void {
			name1||=ANY_STATE;
			_transitionConditions[name1] ||= [];
			_transitionConditions[name1].push({ target:name2, condition:condition});
		}
		/**设置默认动画*/
		public function setDefaultAnimation(name:String):void {
			changeCurAnimation(name);
		}
		private function update():void {
			//指定状态过渡到目标状态
			var transitionCondition:Array = _transitionConditions[_curAniKey];
			if (transitionCondition) {
				var i:int = transitionCondition.length, obj:*;
				while (--i >= 0) {
					obj = transitionCondition[i];
					//条件成立，则切换到目标动画
					if (obj.condition()) changeCurAnimation(obj.target);
					
				}
			}
			//任意状态过渡到目标状态
			transitionCondition = _transitionConditions[ANY_STATE];
			if (transitionCondition) {
				i = transitionCondition.length;
				while (--i>=0) {
					obj = transitionCondition[i];
					//条件成立，则切换到目标动画
					if (obj.condition())changeCurAnimation(obj.target);
				}
			}
		}
		private var _changeEvent:Event=new Event(Event.CHANGE);
		public function changeCurAnimation(name:String):void {
			if (_curAniKey == name) return;
			if (_animations[name]) _curAniKey = name;
			else trace("警告：发现动作 "+name+" , 为null/undefined，请检查是否正确使用addAnimation方法添加");
			this.dispatchEvent(_changeEvent);//发出改变动作事件 
			
			if (_curAnimation) {
				FuncUtil.removeChild(_curAnimation);
				_curAnimation.alpha = 1;
			}
			
			_curAnimation = _animations[_curAniKey];
			if(_curAnimation){
				_curAnimation.x = x;
				_curAnimation.y = y;
				_curAnimation.rotation = rotation;
				_curAnimation.scaleX = scaleX;
				_curAnimation.scaleY = scaleY;
				_container.addChild(_curAnimation);
			}
		}
		private var _isDispose:Boolean;
		public function dispose():void {
			if (_isDispose) return; _isDispose = true;
			for (var key:String in _animations) {
				var clip:Clip = _animations[key] as Clip;
				if (clip) {
					FuncUtil.removeChild(clip);
					clip.destroy();
				}
			}
			_facade.removeUpdateListener(UpdateType.UPDATE_2, update);
			_facade = null;
			_animations = null;
			_transitionConditions = null;
			_container = null;
			_changeEvent = null;
		}
		
		public function get x():Number { return _x; }
		public function set x(value:Number):void { 
			_x = value; 
			if(_curAnimation)_curAnimation.x = _x;
		}
		
		public function get y():Number { return _y; }
		public function set y(value:Number):void {
			_y = value;
			if(_curAnimation)_curAnimation.y = _y;
		}
		
		public function get rotation():Number { return _rotation; }
		public function set rotation(value:Number):void { 
			_rotation = value; 
			if(_curAnimation)_curAnimation.rotation = _rotation;
		}
		
		public function get scaleX():Number { return _scaleX; }
		public function set scaleX(value:Number):void {
			_scaleX = value; 
			if(_curAnimation)_curAnimation.scaleX = _scaleX;
		}
		
		public function get scaleY():Number { return _scaleY; }
		public function set scaleY(value:Number):void {
			_scaleY = value; 
			if(_curAnimation)_curAnimation.scaleY = _scaleY;
		}
		
		public function get curAnimation():DisplayObject { return _curAnimation; }
		public function get curAniKey():String { return _curAniKey; }
	}

}