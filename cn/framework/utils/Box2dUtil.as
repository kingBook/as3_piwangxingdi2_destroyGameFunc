package framework.utils
{
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.Contacts.b2ContactEdge;
   import Box2D.Dynamics.b2World;
   import Box2D.Dynamics.b2BodyDef;
   import Box2D.Collision.Shapes.b2PolygonShape;
   import Box2D.Dynamics.b2FixtureDef;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Collision.Shapes.b2CircleShape;
   import flash.display.Sprite;
   import flash.display.DisplayObject;
   import Box2D.Dynamics.b2FilterData;
   import Box2D.Dynamics.b2Fixture;
   
   public class Box2dUtil extends Object
   {
      
      public function Box2dUtil()
      {
         super();
      }
      
      public static function setContactBodiesAwake(b:b2Body, awake:Boolean) : void
      {
         var b1:b2Body = null;
         var b2:b2Body = null;
         var ob:b2Body = null;
         var ce:b2ContactEdge = b.GetContactList();
         while(ce)
         {
            b1 = ce.contact.GetFixtureA().GetBody();
            b2 = ce.contact.GetFixtureB().GetBody();
            ob = b1 == b?b2:b1;
            ob.SetAwake(awake);
            ce = ce.next;
         }
      }
	  
	  public static function createRoundBox(w:Number,h:Number,x:Number,y:Number,world:b2World,ptm_ratio:Number,roundRadius:Number,smooth:int=20):b2Body{
		var bodyDef:b2BodyDef = new b2BodyDef();
		bodyDef.type=b2Body.b2_dynamicBody;
		bodyDef.position.Set(x/ptm_ratio,y/ptm_ratio);
		
		var fixtureDef:b2FixtureDef = new b2FixtureDef();
		fixtureDef.shape = getRoundPolygonShape(w/ptm_ratio*0.5,h/ptm_ratio*0.5,roundRadius/ptm_ratio,smooth);
		var body:b2Body=world.CreateBody(bodyDef);
		body.CreateFixture(fixtureDef);
		return body;
	}
      
	  public static function getRoundPolygonShape(hx:Number,hy:Number,roundRadius:Number,smooth:int=20):b2PolygonShape{
		var vertices:Vector.<b2Vec2>=new Vector.<b2Vec2>();
		var x:Number,y:Number;
		
		x=-hx, y=-hy;
		ComputeRoundVertices(x,y,x+roundRadius,y+roundRadius,roundRadius,smooth,vertices);
		
		x=hx, y=-hy;
		ComputeRoundVertices(x,y,x-roundRadius,y+roundRadius,roundRadius,smooth,vertices);
		
		x=hx, y=hy;
		ComputeRoundVertices(x,y,x-roundRadius,y-roundRadius,roundRadius,smooth,vertices);
		
		x=-hx, y=hy;
		ComputeRoundVertices(x,y,x+roundRadius,y-roundRadius,roundRadius,smooth,vertices);
		
		return b2PolygonShape.AsVector(vertices,vertices.length);
	}
	
	private static function ComputeRoundVertices(x:Number,y:Number,cx:Number,cy:Number,roundRadius:Number,smooth:int,outputVertices:Vector.<b2Vec2>):void{
		var cAngle:Number=Math.atan2(y-cy,x-cx);
		var angle:Number=cAngle-Math.PI/4;//-90°
		var angle1:Number;
		var interval:Number=Math.PI*0.5/smooth;//90°平均分smooth
		var x1:Number,y1:Number;
		for(var i:int=0;i<smooth;i++){
			angle1=angle+interval*i;
			x1=cx+Math.cos(angle1)*roundRadius;
			y1=cy+Math.sin(angle1)*roundRadius;
			outputVertices.push(new b2Vec2(x1,y1));
		}
	}
	  
      public static function createBox(w:Number, h:Number, x:Number, y:Number, world:b2World, pixelToMeter:Number) : b2Body
      {
         var bodyDef:b2BodyDef = new b2BodyDef();
         var body:b2Body = world.CreateBody(bodyDef);
         var s:b2PolygonShape = new b2PolygonShape();
         s.SetAsBox(w / pixelToMeter * 0.5,h / pixelToMeter * 0.5);
         var fixtrureDef:b2FixtureDef = new b2FixtureDef();
         fixtrureDef.shape = s;
         body.CreateFixture(fixtrureDef);
         body.SetType(b2Body.b2_dynamicBody);
         body.SetPosition(new b2Vec2(x / pixelToMeter,y / pixelToMeter));
         return body;
      }
      
      public static function createCircle(radius:Number, x:Number, y:Number, world:b2World, pixelToMeter:Number) : b2Body
      {
         var bodyDef:b2BodyDef = new b2BodyDef();
         var body:b2Body = world.CreateBody(bodyDef);
         var s:b2CircleShape = new b2CircleShape(radius / pixelToMeter);
         var fixtrureDef:b2FixtureDef = new b2FixtureDef();
         fixtrureDef.shape = s;
         body.CreateFixture(fixtrureDef);
         body.SetType(b2Body.b2_dynamicBody);
         body.SetPosition(new b2Vec2(x / pixelToMeter,y / pixelToMeter));
         return body;
      }
      
      public static function createPolygon(x:Number, y:Number, vertices:Vector.<b2Vec2>, world:b2World, pixelToMeter:Number) : b2Body
      {
         var v2:b2Vec2 = null;
         var s:b2PolygonShape = null;
         var fixtrureDef:b2FixtureDef = null;
         var bodyDef:b2BodyDef = new b2BodyDef();
         var body:b2Body = world.CreateBody(bodyDef);
         for each(v2 in vertices)
         {
            v2.x = v2.x / pixelToMeter;
            v2.y = v2.y / pixelToMeter;
         }
         s = b2PolygonShape.AsVector(vertices,vertices.length);
         fixtrureDef = new b2FixtureDef();
         fixtrureDef.shape = s;
         body.CreateFixture(fixtrureDef);
         body.SetType(b2Body.b2_dynamicBody);
         body.SetPosition(new b2Vec2(x / pixelToMeter,y / pixelToMeter));
         return body;
      }
      
      public static function createRoundBottomBody(w:Number, h:Number, x:Number, y:Number, radius:Number, bottomFriction:Number, world:b2World, pixelToMeter:Number) : b2Body
      {
         var w:Number = w / pixelToMeter;
         var h:Number = h / pixelToMeter;
         var x:Number = x / pixelToMeter;
         var y:Number = y / pixelToMeter;
         var radius:Number = radius / pixelToMeter;
         var dx:Number = w * 0.5 - radius + 0.2 / pixelToMeter;
         var dy:Number = h * 0.5 - radius;
         var body:b2Body = world.CreateBody(new b2BodyDef());
         var fixtureDef:b2FixtureDef = new b2FixtureDef();
         var pol:b2PolygonShape = b2PolygonShape.AsOrientedBox(w * 0.5,h * 0.5,b2Vec2.Make(0,-radius));
         fixtureDef.friction = 0;
         fixtureDef.shape = pol;
         body.CreateFixture(fixtureDef);
         fixtureDef = new b2FixtureDef();
         fixtureDef.friction = bottomFriction;
         var c:b2CircleShape = new b2CircleShape(radius);
         c.SetLocalPosition(b2Vec2.Make(-dx,dy));
         fixtureDef.shape = c;
         body.CreateFixture(fixtureDef);
         c = c.Copy() as b2CircleShape;
         c.SetLocalPosition(b2Vec2.Make(dx,dy));
         fixtureDef.shape = c;
         body.CreateFixture(fixtureDef);
         body.SetType(b2Body.b2_dynamicBody);
         body.SetFixedRotation(true);
         body.SetPosition(b2Vec2.Make(x,y));
         return body;
      }
      
      public static function createBoxFromSprite(sprite:Sprite, world:b2World, pixelToMeter:Number) : b2Body
      {
         var child:DisplayObject = null;
         var i:* = 0;
         var fixtureDef:b2FixtureDef = null;
         var poly:b2PolygonShape = null;
         var len:int = sprite.numChildren;
         var body:b2Body = world.CreateBody(new b2BodyDef());
         while(i < len)
         {
            child = sprite.getChildAt(i);
            fixtureDef = new b2FixtureDef();
            poly = new b2PolygonShape();
            poly.SetAsOrientedBox(child.width * 0.5 / pixelToMeter,child.height * 0.5 / pixelToMeter,b2Vec2.Make(child.x / pixelToMeter,child.y / pixelToMeter));
            fixtureDef.shape = poly;
            body.CreateFixture(fixtureDef);
            i++;
         }
         body.SetType(b2Body.b2_kinematicBody);
         body.SetFixedRotation(true);
         body.SetPosition(b2Vec2.Make(sprite.x / pixelToMeter,sprite.y / pixelToMeter));
         return body;
      }
      
      public static function setBodyFixture(body:b2Body, density:Number = NaN, friction:Number = NaN, restitution:Number = NaN, filter:b2FilterData = null, data:* = null) : void
      {
         var fixture:b2Fixture = body.GetFixtureList();
         while(fixture)
         {
            if(!isNaN(density))
            {
               fixture.SetDensity(density);
            }
            if(filter)
            {
               fixture.SetFilterData(filter);
            }
            if(!isNaN(friction))
            {
               fixture.SetFriction(friction);
            }
            if(!isNaN(restitution))
            {
               fixture.SetRestitution(restitution);
            }
            if(data)
            {
               fixture.SetUserData(data);
            }
            fixture = fixture.GetNext();
         }
      }
      
      public static function getWrapWallBodies(x:Number, y:Number, w:Number, h:Number, world:b2World, pixelToMeter:Number) : Vector.<b2Body>
      {
         var thickness:uint = 20;
         var bodies:Vector.<b2Body> = new Vector.<b2Body>(4,true);
         bodies[0] = createBox(w,thickness,w * 0.5 + x,y - thickness * 0.5,world,pixelToMeter);
         bodies[1] = createBox(w,thickness,w * 0.5 + x,h + thickness * 0.5 + y,world,pixelToMeter);
         bodies[2] = createBox(thickness,h,x - thickness * 0.5,h * 0.5 + y,world,pixelToMeter);
         bodies[3] = createBox(thickness,h,x + w + thickness * 0.5,h * 0.5 + y,world,pixelToMeter);
         return bodies;
      }
      
      public static function getXmlBodies(xml:XML, mapWidth:Number, mapHeight:Number, world:b2World, pixelToMeter:Number) : Vector.<b2Body>
      {
         var j:* = 0;
         var bodyDef:b2BodyDef = null;
         var b:b2Body = null;
         var s:b2PolygonShape = null;
         var bodies:Vector.<b2Body> = new Vector.<b2Body>();
         var vertices:Array = getXmlVerts(xml,mapWidth,mapHeight,pixelToMeter);
         var i:int = vertices.length;
         var fixtrureDef:b2FixtureDef = new b2FixtureDef();
         while(--i >= 0)
         {
            b = world.CreateBody(new b2BodyDef());
            j = vertices[i].length;
            while(--j >= 0)
            {
               s = b2PolygonShape.AsArray(vertices[i][j],vertices[i][j].length);
               fixtrureDef.shape = s;
               b.CreateFixture(fixtrureDef);
            }
            b.SetType(b2Body.b2_staticBody);
            bodies.push(b);
         }
         return bodies;
      }
      
      public static function getXmlVerts(xml:XML, mapWidth:Number, mapHeight:Number, pixelToMeter:Number) : Array
      {
         var numBodies:* = 0;
         var numPolygons:* = 0;
         var numVertexes:* = 0;
         var i:* = 0;
         var j:* = 0;
         var k:* = 0;
         var vertices:Array = [];
         numBodies = xml.bodies.body.fixture.length();
         i = 0;
         while(i < numBodies)
         {
            vertices[i] = [];
            numPolygons = xml.bodies.body.fixture[i].polygon.length();
            j = 0;
            while(j < numPolygons)
            {
               vertices[i][j] = [];
               numVertexes = xml.bodies.body.fixture[i].polygon[j].vertex.length();
               k = 0;
               while(k < numVertexes)
               {
                  vertices[i][j][k] = new b2Vec2(Number(xml.bodies.body.fixture[i].polygon[j].vertex[k].@x) / pixelToMeter,Number(xml.bodies.body.fixture[i].polygon[j].vertex[k].@y) / pixelToMeter);
                  k++;
               }
               j++;
            }
            i++;
         }
         return vertices;
      }
   }
}
