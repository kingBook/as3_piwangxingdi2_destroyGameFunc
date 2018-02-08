package framework.flintparticles.common.particles
{
   import flash.geom.ColorTransform;
   import flash.utils.Dictionary;
   
   public class Particle extends Object
   {
      
      public function Particle()
      {
         super();
      }
      
      public var color:uint = 4.294967295E9;
      
      private var _colorTransform:ColorTransform = null;
      
      private var _previousColor:uint;
      
      public var scale:Number = 1;
      
      public var mass:Number = 1;
      
      public var collisionRadius:Number = 1;
      
      public var image:* = null;
      
      public var lifetime:Number = 0;
      
      public var age:Number = 0;
      
      public var energy:Number = 1;
      
      public var isDead:Boolean = false;
      
      public function get dictionary() : Dictionary
      {
         if(this._dictionary == null)
         {
            this._dictionary = new Dictionary(true);
         }
         return this._dictionary;
      }
      
      private var _dictionary:Dictionary = null;
      
      public function initialize() : void
      {
         this.color = 4.294967295E9;
         this.scale = 1;
         this.mass = 1;
         this.collisionRadius = 1;
         this.lifetime = 0;
         this.age = 0;
         this.energy = 1;
         this.isDead = false;
         this.image = null;
         this._dictionary = null;
         this._colorTransform = null;
      }
      
      public function get colorTransform() : ColorTransform
      {
         if((!this._colorTransform) || (!(this._previousColor == this.color)))
         {
            this._colorTransform = new ColorTransform((this.color >>> 16 & 255) / 255,(this.color >>> 8 & 255) / 255,(this.color & 255) / 255,(this.color >>> 24 & 255) / 255,0,0,0,0);
            this._previousColor = this.color;
         }
         return this._colorTransform;
      }
      
      public function get alpha() : Number
      {
         return ((this.color & 4.27819008E9) >>> 24) / 255;
      }
      
      protected function cloneInto(p:Particle) : Particle
      {
         var key:Object = null;
         p.color = this.color;
         p.scale = this.scale;
         p.mass = this.mass;
         p.collisionRadius = this.collisionRadius;
         p.lifetime = this.lifetime;
         p.age = this.age;
         p.energy = this.energy;
         p.isDead = this.isDead;
         p.image = this.image;
         if(this._dictionary)
         {
            p._dictionary = new Dictionary(true);
            for(key in this._dictionary)
            {
               p._dictionary[key] = this._dictionary[key];
            }
         }
         return p;
      }
      
      public function clone(factory:ParticleFactory = null) : Particle
      {
         var p:Particle = null;
         if(factory)
         {
            p = factory.createParticle();
         }
         else
         {
            p = new Particle();
         }
         return this.cloneInto(p);
      }
      
      public function revive() : void
      {
         this.lifetime = 0;
         this.age = 0;
         this.energy = 1;
         this.isDead = false;
      }
   }
}
