package framework.system
{
   import flash.events.EventDispatcher;
   import framework.Facade;
   import flash.geom.Point;
   import flash.display.DisplayObjectContainer;
   import framework.events.FrameworkEvent;
   import framework.events.ScorllEvent;
   import flash.display.DisplayObject;
   import flash.geom.Rectangle;
   import Box2D.Dynamics.b2Body;
   import flash.display.Sprite;
   import framework.UpdateType;
   
   public class ScorllManager extends EventDispatcher
   {
      
      public function ScorllManager(scorllContainer:Sprite, gameWidth:Number, gameHeight:Number, pixelToMeter:Number, facade:Facade)
      {
         this._targetCenter = new Point();
         this._p = new Point();
         this._coustomV = new Point();
         this._scorllMode = ScorllMode.TARGET_CENTER;
         this._scorllContainer = scorllContainer;
         this._gameWidth = gameWidth;
         this._gameHeight = gameHeight;
         this._pixelToMeter = pixelToMeter;
         this.setFocus(new Point(this._gameWidth >> 1,this._gameHeight >> 1));
         this._facade = facade;
         this._facade.addUpdateListener(UpdateType.UPDATE_3,this.update);
         this._facade.addEventListener(FrameworkEvent.PAUSE,this.pauseOrResumeHandler);
         this._facade.addEventListener(FrameworkEvent.RESUME,this.pauseOrResumeHandler);
         super();
      }
      
      private var _scorllMode:ScorllMode;
      
      public function setScorllMode(value:ScorllMode) : void
      {
         this._scorllMode = value;
      }
      
      private var _facade:Facade;
      
      private var _pixelToMeter:Number;
      
      private var _vx:Number = 0;
      
      private var _vy:Number = 0;
      
      public function setVelocity(x:Number, y:Number) : void
      {
         this._scorllMode = ScorllMode.COUSTOM_VELOCITY;
         this._vx = x;
         this._vy = y;
      }
      
      private var _resetVx:Number;
      
      private var _resetVy:Number;
      
      private var _lastContainerX:Number;
      
      private var _lastContainerY:Number;
      
      private var _targetCenter:Point;
      
      private var _pause:Boolean;
      
      public function setPause(value:Boolean) : void
      {
         this._pause = value;
      }
      
      private var _xEasingNum:Number = 0.2;
      
      private var _yEasingNum:Number = 0.2;
      
      private var _gameWidth:int = 0;
      
      private var _gameHeight:int = 0;
      
      private var _mapWidth:Number = 0;
      
      private var _mapHeight:Number = 0;
      
      public function setMapSize(w:Number, h:Number) : void
      {
         this._mapWidth = w;
         this._mapHeight = h;
      }
      
      private var _easingNum:Number = 0.05;
      
      private var _focus:Point;
      
      public function setFocus(value:Point) : void
      {
         this._focus = this._activeFocus = value;
      }
      
      private var _activeFocus:Point;
      
      public function setActiveFocus(value:Point) : void
      {
         this._activeFocus = value;
      }
      
      private var _scorllContainer:DisplayObjectContainer;
      
      public function setScorllContainer(value:DisplayObjectContainer) : void
      {
         this._scorllContainer = value;
      }
      
      private var _tList:Array;
      
      public function addToTargetList(o:*, clear:Boolean = false) : void
      {
         if(this._tList == null)
         {
            this._tList = [];
         }
         if(clear)
         {
            this._tList.splice(0,this._tList.length);
         }
         if(this._tList.indexOf(o) < 0)
         {
            this._tList.push(o);
         }
      }
      
      public function removeOfTargetList(o:*) : void
      {
         if(this._tList == null)
         {
            return;
         }
         var id:int = this._tList.indexOf(o);
         if(id > -1)
         {
            this._tList.splice(id,1);
         }
      }
      
      public function reset() : void
      {
         this._pause = false;
         if(this._tList != null)
         {
            this._tList.splice(0,this._tList.length);
         }
         this._vx = this._vy = 0;
         this._scorllMode = ScorllMode.TARGET_CENTER;
         this._mapWidth = this._mapHeight = 0;
         this.setFocus(new Point(this._gameWidth >> 1,this._gameHeight >> 1));
      }
      
      private function pauseOrResumeHandler(e:FrameworkEvent) : void
      {
         this._pause = e.type == FrameworkEvent.PAUSE;
      }
      
      private function update() : void
      {
         var vel:Point = null;
         if(this._pause)
         {
            return;
         }
         if((this._mapWidth == 0) || (this._mapHeight == 0))
         {
            return;
         }
         var vx:Number = 0;
         var vy:Number = 0;
         if(this._scorllMode == ScorllMode.TARGET_CENTER)
         {
            this.updateTargetCenter();
            vx = this.targetCenterXAI();
            vy = this.targetCenterYAI();
         }
         else if(this._scorllMode == ScorllMode.COUSTOM_VELOCITY)
         {
            vel = this.coustomVelAI();
            vx = vel.x;
            vy = vel.y;
         }
         else if(this._scorllMode == ScorllMode.TARGET_CENTER_X)
         {
            this.updateTargetCenter();
            vx = this.targetCenterXAI();
         }
         else if(this._scorllMode == ScorllMode.TARGET_CENTER_Y)
         {
            this.updateTargetCenter();
            vy = this.targetCenterYAI();
         }
         
         
         
         if((Math.abs(vx) > 0) || (Math.abs(vy) > 0))
         {
            this.dispatchUpdateEvent(vx,vy);
         }
      }
      
      private var _updateEvt:ScorllEvent;
      
      private function dispatchUpdateEvent(vx:Number, vy:Number) : void
      {
         if(this._updateEvt == null)
         {
            this._updateEvt = new ScorllEvent(ScorllEvent.UPDATE,{});
         }
         this._updateEvt.info.vx = vx;
         this._updateEvt.info.vy = vy;
         this._updateEvt.info.scorllContainer = this._scorllContainer;
         dispatchEvent(this._updateEvt);
      }
      
      private var _p:Point;
      
      private function updateTargetCenter() : void
      {
         var disObj:DisplayObject = null;
         var r:Rectangle = null;
         var b:b2Body = null;
         var pos:Point = null;
         if((this._tList == null) || (this._tList.length <= 0))
         {
            this._targetCenter.x = this._gameWidth >> 1;
            this._targetCenter.y = this._gameHeight >> 1;
            return;
         }
         var x:Number = 0;
         var y:Number = 0;
         var x0:Number = 0;
         var x1:Number = 0;
         var y0:Number = 0;
         var y1:Number = 0;
         var i:int = this._tList.length;
         while(--i >= 0)
         {
            if(this._tList[i] is DisplayObject)
            {
               disObj = this._tList[i] as DisplayObject;
               r = disObj.getBounds(disObj.stage);
               x = r.x + int(r.width + 0.5) >> 1;
               y = r.y + int(r.height + 0.5) >> 1;
            }
            else if(this._tList[i] is b2Body)
            {
               b = this._tList[i] as b2Body;
               this._p.x = b.GetPosition().x * this._pixelToMeter;
               this._p.y = b.GetPosition().y * this._pixelToMeter;
               pos = this._scorllContainer.localToGlobal(this._p);
               x = pos.x;
               y = pos.y;
            }
            
            x0 = x0 == 0?x:Math.min(x0,x);
            x1 = x1 == 0?x:Math.max(x1,x);
            y0 = y0 == 0?y:Math.min(y0,y);
            y1 = y1 == 0?y:Math.max(y1,y);
         }
         this._targetCenter.x = int(x0 + x1 + 0.5) >> 1;
         this._targetCenter.y = int(y0 + y1 + 0.5) >> 1;
      }
      
      private function updateFocusX() : void
      {
         var dx:Number = this._activeFocus.x - this._focus.x;
         if(Math.abs(dx) > 1)
         {
            this._focus.x = this._focus.x + dx * 0.05;
         }
         else
         {
            this._focus.x = this._activeFocus.x;
         }
      }
      
      private function updateFocusY() : void
      {
         var dy:Number = this._activeFocus.y - this._focus.y;
         if(Math.abs(dy) > 1)
         {
            this._focus.y = this._focus.y + dy * 0.05;
         }
         else
         {
            this._focus.y = this._activeFocus.y;
         }
      }
      
      private function targetCenterXAI() : Number
      {
         this.updateFocusX();
         this._vx = (this._focus.x - this._targetCenter.x) * this._xEasingNum;
         this.moveX();
         return this._scorllContainer.x - this._lastContainerX;
      }
      
      private function targetCenterYAI() : Number
      {
         this.updateFocusY();
         this._vy = (this._focus.y - this._targetCenter.y) * this._yEasingNum;
         this.moveY();
         return this._scorllContainer.y - this._lastContainerY;
      }
      
      private var _coustomV:Point;
      
      private function coustomVelAI() : Point
      {
         this.moveX();
         this._coustomV.x = this._scorllContainer.x - this._lastContainerX;
         this.moveY();
         this._coustomV.y = this._scorllContainer.y - this._lastContainerY;
         return this._coustomV;
      }
      
      public function rightNowToPos(gpt:Point = null) : void
      {
         if(gpt == null)
         {
            this.updateTargetCenter();
            var gpt:Point = this._targetCenter;
         }
         this.updateFocusX();
         this._vx = this._focus.x - gpt.x;
         this.moveX();
         this.updateFocusY();
         this._vy = this._focus.y - gpt.y;
         this.moveY();
         this.dispatchUpdateEvent(this._vx,this._vy);
      }
      
      private function moveX() : void
      {
         this._vx = this._vx > 0?int(this._vx + 0.9):int(this._vx - 0.9);
         if(this.toMapEdgeX())
         {
            this._vx = this._resetVx;
         }
         if(Math.abs(this._vx) < 0.05)
         {
            this._vx = 0;
         }
         this._lastContainerX = this._scorllContainer.x;
         this._scorllContainer.x = this._scorllContainer.x + this._vx;
         this._scorllContainer.x = int(this._scorllContainer.x + 0.9);
      }
      
      private function moveY() : void
      {
         this._vy = this._vy > 0?int(this._vy + 0.9):int(this._vy - 0.9);
         if(this.toMapEdgeY())
         {
            this._vy = this._resetVy;
         }
         if(Math.abs(this._vy) < 0.05)
         {
            this._vy = 0;
         }
         this._lastContainerY = this._scorllContainer.y;
         this._scorllContainer.y = this._scorllContainer.y + this._vy;
         this._scorllContainer.y = int(this._scorllContainer.y + 0.9);
      }
      
      private function toMapEdgeX() : Boolean
      {
         if(this._vx == 0)
         {
            return false;
         }
         if(this._vx > 0)
         {
            if(this._scorllContainer.x + this._vx > 0)
            {
               this._resetVx = 0 - this._scorllContainer.x;
               return true;
            }
         }
         else if(this._vx < 0)
         {
            if(this._scorllContainer.x + this._vx < -(this._mapWidth - this._gameWidth))
            {
               this._resetVx = -(this._mapWidth - this._gameWidth + this._scorllContainer.x);
               return true;
            }
         }
         
         return false;
      }
      
      private function toMapEdgeY() : Boolean
      {
         if(this._vy == 0)
         {
            return false;
         }
         if(this._vy > 0)
         {
            if(this._scorllContainer.y + this._vy > 0)
            {
               this._resetVy = 0 - this._scorllContainer.y;
               return true;
            }
         }
         else if(this._vy < 0)
         {
            if(this._scorllContainer.y + this._vy < -(this._mapHeight - this._gameHeight))
            {
               this._resetVy = -(this._mapHeight - this._gameHeight + this._scorllContainer.y);
               return true;
            }
         }
         
         return false;
      }
   }
}
