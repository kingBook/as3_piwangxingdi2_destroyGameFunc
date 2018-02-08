package framework.system
{
   import Box2D.Dynamics.b2World;
   import flash.display.DisplayObject;
   import Box2D.Dynamics.Joints.b2MouseJoint;
   import framework.Facade;
   import Box2D.Common.Math.b2Vec2;
   import flash.events.MouseEvent;
   import Box2D.Dynamics.Joints.b2Joint;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2Fixture;
   import Box2D.Dynamics.Joints.b2MouseJointDef;
   import framework.UpdateType;
   
   public class Box2dManager extends Object
   {
      
      public function Box2dManager(worldDisObj:DisplayObject, facade:Facade, useMouseJoint:Boolean, gravity:b2Vec2, deltaTime:Number, pixelToMeter:Number)
      {
         super();
         this._deltaTime = deltaTime;
         this._pixelToMeter = pixelToMeter;
         this._worldDisObj = worldDisObj;
         this._gravity = gravity;
         this._facade = facade;
         this._world = new b2World(this._gravity,true);
         this._facade.addUpdateListener(UpdateType.UPDATE_1,this.step);
         if(useMouseJoint)
         {
            this._facade.global.stage.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseHandler);
            this._facade.addUpdateListener(UpdateType.UPDATE_2,this.update);
            this._facade.global.stage.addEventListener(MouseEvent.MOUSE_UP,this.mouseHandler);
         }
      }
      
      private var _deltaTime:Number;
      
      private var _pixelToMeter:Number;
      
      private var _world:b2World;
      
      private var _worldDisObj:DisplayObject;
      
      private var _mj:b2MouseJoint;
      
      private var _facade:Facade;
      
      private var _gravity:b2Vec2;
      
      private function mouseHandler(e:MouseEvent) : void
      {
         var x:Number = this._worldDisObj.mouseX;
         var y:Number = this._worldDisObj.mouseY;
         switch(e.type)
         {
            case MouseEvent.MOUSE_DOWN:
               this.mouseDownHandler(x,y);
               break;
            case MouseEvent.MOUSE_MOVE:
               this.mouseMoveHandler(x,y);
               break;
            case MouseEvent.MOUSE_UP:
               this.mouseUpHandler();
               break;
         }
      }
      
      public function reset() : void
      {
         if(this._mj)
         {
            this._world.DestroyJoint(this._mj);
            this._mj = null;
         }
         this.clearWorld(this._world);
      }
      
      private function clearWorld(world:b2World) : void
      {
         var j:b2Joint = world.GetJointList();
         while(j)
         {
            world.DestroyJoint(j);
            j = j.GetNext();
         }
         var b:b2Body = world.GetBodyList();
         while(b)
         {
            world.DestroyBody(b);
            b = b.GetNext();
         }
      }
      
      public function step() : void
      {
         this._world.Step(1 / this._deltaTime,10,10);
         this._world.ClearForces();
         this._world.DrawDebugData();
      }
      
      private function mouseUpHandler() : void
      {
         this.stopDragBody();
      }
      
      private function update() : void
      {
         var x:Number = this._worldDisObj.mouseX;
         var y:Number = this._worldDisObj.mouseY;
         this.mouseMoveHandler(x,y);
      }
      
      private function mouseMoveHandler(x:Number, y:Number) : void
      {
         if(this._mj)
         {
            this._mj.SetTarget(new b2Vec2(x / this._pixelToMeter,y / this._pixelToMeter));
         }
      }
      
      private function mouseDownHandler(x:Number, y:Number) : void
      {
         var b:b2Body = this.getPosBody(x,y,this._world);
         this.startDragBody(b,x,y);
      }
      
      private function getPosBody(x:Number, y:Number, world:b2World) : b2Body
      {
         var b:b2Body = null;
         world.QueryPoint(function(fixture:b2Fixture):Boolean
         {
            b = fixture.GetBody();
            return false;
         },new b2Vec2(x / this._pixelToMeter,y / this._pixelToMeter));
         return b;
      }
      
      private function startDragBody(b:b2Body, x:Number, y:Number) : void
      {
         if((!b) || (!(b.GetType() == b2Body.b2_dynamicBody)))
         {
            return;
         }
         this._mj && this._world.DestroyJoint(this._mj);
         var jointDef:b2MouseJointDef = new b2MouseJointDef();
         jointDef.bodyA = this._world.GetGroundBody();
         jointDef.bodyB = b;
         jointDef.target.Set(x / this._pixelToMeter,y / this._pixelToMeter);
         jointDef.maxForce = 1000000;
         this._mj = this._world.CreateJoint(jointDef) as b2MouseJoint;
      }
      
      private function stopDragBody() : void
      {
         this._mj && this._world.DestroyJoint(this._mj);
      }
      
      public function destroy() : void
      {
         this._facade.global.stage.removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseHandler);
         this._facade.global.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.mouseHandler);
         this._facade.removeUpdateListener(UpdateType.UPDATE_2,this.update);
         this._facade.global.stage.removeEventListener(MouseEvent.MOUSE_UP,this.mouseHandler);
         if(this._facade)
         {
            this._facade.removeUpdateListener(UpdateType.UPDATE_1,this.step);
            this._facade = null;
         }
         if(this._mj)
         {
            this._world.DestroyJoint(this._mj);
            this._mj = null;
         }
         this._worldDisObj = null;
         this._world = null;
      }
      
      public function get world() : b2World
      {
         return this._world;
      }
   }
}
