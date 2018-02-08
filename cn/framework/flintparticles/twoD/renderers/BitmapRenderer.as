package framework.flintparticles.twoD.renderers
{
   import framework.flintparticles.common.renderers.SpriteRendererBase;
   import flash.geom.Point;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.geom.Rectangle;
   import flash.filters.BitmapFilter;
   import framework.flintparticles.twoD.particles.Particle2D;
   import flash.geom.Matrix;
   import flash.display.DisplayObject;
   
   public class BitmapRenderer extends SpriteRendererBase
   {
      
      public function BitmapRenderer(canvas:Rectangle, smoothing:Boolean = false)
      {
         super();
         mouseEnabled = false;
         mouseChildren = false;
         this._smoothing = smoothing;
         this._preFilters = new Array();
         this._postFilters = new Array();
         this._canvas = canvas;
         this.createBitmap();
         this._clearBetweenFrames = true;
      }
      
      protected static var ZERO_POINT:Point = new Point(0,0);
      
      protected var _bitmap:Bitmap;
      
      protected var _bitmapData:BitmapData;
      
      protected var _preFilters:Array;
      
      protected var _postFilters:Array;
      
      protected var _colorMap:Array;
      
      protected var _smoothing:Boolean;
      
      protected var _canvas:Rectangle;
      
      protected var _clearBetweenFrames:Boolean;
      
      public function addFilter(filter:BitmapFilter, postRender:Boolean = false) : void
      {
         if(postRender)
         {
            this._postFilters.push(filter);
         }
         else
         {
            this._preFilters.push(filter);
         }
      }
      
      public function removeFilter(filter:BitmapFilter) : void
      {
         var i:int = 0;
         while(i < this._preFilters.length)
         {
            if(this._preFilters[i] == filter)
            {
               this._preFilters.splice(i,1);
               return;
            }
            i++;
         }
         i = 0;
         while(i < this._postFilters.length)
         {
            if(this._postFilters[i] == filter)
            {
               this._postFilters.splice(i,1);
               return;
            }
            i++;
         }
      }
      
      public function get preFilters() : Array
      {
         return this._preFilters.slice();
      }
      
      public function set preFilters(value:Array) : void
      {
         var filter:BitmapFilter = null;
         for each(filter in this._preFilters)
         {
            this.removeFilter(filter);
         }
         for each(filter in value)
         {
            this.addFilter(filter,false);
         }
      }
      
      public function get postFilters() : Array
      {
         return this._postFilters.slice();
      }
      
      public function set postFilters(value:Array) : void
      {
         var filter:BitmapFilter = null;
         for each(filter in this._postFilters)
         {
            this.removeFilter(filter);
         }
         for each(filter in value)
         {
            this.addFilter(filter,true);
         }
      }
      
      public function setPaletteMap(red:Array = null, green:Array = null, blue:Array = null, alpha:Array = null) : void
      {
         this._colorMap = new Array(4);
         this._colorMap[0] = alpha;
         this._colorMap[1] = red;
         this._colorMap[2] = green;
         this._colorMap[3] = blue;
      }
      
      public function clearPaletteMap() : void
      {
         this._colorMap = null;
      }
      
      protected function createBitmap() : void
      {
         if(!this._canvas)
         {
            return;
         }
         if((this._bitmap) && (this._bitmapData))
         {
            this._bitmapData.dispose();
            this._bitmapData = null;
         }
         if(this._bitmap)
         {
            removeChild(this._bitmap);
            this._bitmap = null;
         }
         this._bitmap = new Bitmap(null,"auto",this._smoothing);
         this._bitmapData = new BitmapData(Math.ceil(this._canvas.width),Math.ceil(this._canvas.height),true,0);
         this._bitmap.bitmapData = this._bitmapData;
         addChild(this._bitmap);
         this._bitmap.x = this._canvas.x;
         this._bitmap.y = this._canvas.y;
      }
      
      public function get canvas() : Rectangle
      {
         return this._canvas;
      }
      
      public function set canvas(value:Rectangle) : void
      {
         this._canvas = value;
         this.createBitmap();
      }
      
      public function get clearBetweenFrames() : Boolean
      {
         return this._clearBetweenFrames;
      }
      
      public function set clearBetweenFrames(value:Boolean) : void
      {
         this._clearBetweenFrames = value;
      }
      
      public function get smoothing() : Boolean
      {
         return this._smoothing;
      }
      
      public function set smoothing(value:Boolean) : void
      {
         this._smoothing = value;
         if(this._bitmap)
         {
            this._bitmap.smoothing = value;
         }
      }
      
      override protected function renderParticles(particles:Array) : void
      {
         var i:* = 0;
         var len:* = 0;
         if(!this._bitmap)
         {
            return;
         }
         this._bitmapData.lock();
         len = this._preFilters.length;
         i = 0;
         while(i < len)
         {
            this._bitmapData.applyFilter(this._bitmapData,this._bitmapData.rect,BitmapRenderer.ZERO_POINT,this._preFilters[i]);
            i++;
         }
         if((this._clearBetweenFrames) && (len == 0))
         {
            this._bitmapData.fillRect(this._bitmap.bitmapData.rect,0);
         }
         len = particles.length;
         if(len)
         {
            i = len;
            while(i--)
            {
               this.drawParticle(Particle2D(particles[i]));
            }
         }
         len = this._postFilters.length;
         i = 0;
         while(i < len)
         {
            this._bitmapData.applyFilter(this._bitmapData,this._bitmapData.rect,BitmapRenderer.ZERO_POINT,this._postFilters[i]);
            i++;
         }
         if(this._colorMap)
         {
            this._bitmapData.paletteMap(this._bitmapData,this._bitmapData.rect,ZERO_POINT,this._colorMap[1],this._colorMap[2],this._colorMap[3],this._colorMap[0]);
         }
         this._bitmapData.unlock();
      }
      
      protected function drawParticle(particle:Particle2D) : void
      {
         var matrix:Matrix = null;
         matrix = particle.matrixTransform;
         matrix.translate(-this._canvas.x,-this._canvas.y);
         this._bitmapData.draw(particle.image,matrix,particle.colorTransform,DisplayObject(particle.image).blendMode,null,this._smoothing);
      }
      
      public function get bitmapData() : BitmapData
      {
         return this._bitmapData;
      }
   }
}
