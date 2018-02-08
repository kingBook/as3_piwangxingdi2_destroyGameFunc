package framework.flintparticles.twoD.particles
{
   import framework.flintparticles.common.particles.Particle;
   import flash.geom.Matrix;
   import framework.flintparticles.common.particles.ParticleFactory;
   
   public class Particle2D extends Particle
   {
      
      public function Particle2D()
      {
         super();
      }
      
      public var x:Number = 0;
      
      public var y:Number = 0;
      
      public var previousX:Number = 0;
      
      public var previousY:Number = 0;
      
      public var velX:Number = 0;
      
      public var velY:Number = 0;
      
      public var rotation:Number = 0;
      
      public var angVelocity:Number = 0;
      
      private var _previousMass:Number;
      
      private var _previousRadius:Number;
      
      private var _inertia:Number;
      
      public function get inertia() : Number
      {
         if((!(mass == this._previousMass)) || (!(collisionRadius == this._previousRadius)))
         {
            this._inertia = mass * collisionRadius * collisionRadius * 0.5;
            this._previousMass = mass;
            this._previousRadius = collisionRadius;
         }
         return this._inertia;
      }
      
      public var sortID:int = -1;
      
      override public function initialize() : void
      {
         super.initialize();
         this.x = 0;
         this.y = 0;
         this.previousX = 0;
         this.previousY = 0;
         this.velX = 0;
         this.velY = 0;
         this.rotation = 0;
         this.angVelocity = 0;
         this.sortID = -1;
      }
      
      public function get matrixTransform() : Matrix
      {
         var cos:Number = scale * Math.cos(this.rotation);
         var sin:Number = scale * Math.sin(this.rotation);
         return new Matrix(cos,sin,-sin,cos,this.x,this.y);
      }
      
      override public function clone(factory:ParticleFactory = null) : Particle
      {
         var p:Particle2D = null;
         if(factory)
         {
            p = factory.createParticle() as Particle2D;
         }
         else
         {
            p = new Particle2D();
         }
         cloneInto(p);
         p.x = this.x;
         p.y = this.y;
         p.velX = this.velX;
         p.velY = this.velY;
         p.rotation = this.rotation;
         p.angVelocity = this.angVelocity;
         return p;
      }
   }
}
