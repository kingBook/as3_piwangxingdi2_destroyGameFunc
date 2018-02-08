package g {
	import flash.filters.BitmapFilter;
	import flash.geom.Point;
	import framework.events.FrameworkEvent;
	import framework.flintparticles.common.actions.Age;
	import framework.flintparticles.common.actions.ColorChange;
	import framework.flintparticles.common.counters.Steady;
	import framework.flintparticles.common.counters.TimePeriod;
	import framework.flintparticles.common.displayObjects.Dot;
	import framework.flintparticles.common.displayObjects.RadialDot;
	import framework.flintparticles.common.displayObjects.Star;
	import framework.flintparticles.common.initializers.ApplyFilter;
	import framework.flintparticles.common.initializers.ImageClass;
	import framework.flintparticles.common.initializers.Lifetime;
	import framework.flintparticles.common.initializers.SharedImage;
	import framework.flintparticles.twoD.actions.Move;
	import framework.flintparticles.twoD.actions.RandomDrift;
	import framework.flintparticles.twoD.actions.RotateToDirection;
	import framework.flintparticles.twoD.actions.ScaleAll;
	import framework.flintparticles.twoD.emitters.Emitter2D;
	import framework.flintparticles.twoD.initializers.Position;
	import framework.flintparticles.twoD.initializers.Velocity;
	import framework.flintparticles.twoD.zones.DiscZone;
	import framework.flintparticles.twoD.zones.LineZone;
	import framework.flintparticles.twoD.zones.PointZone;
	import g.MyObj;
	/**
	 * ...
	 * @author kingBook
	 * 2015-03-13 14:44
	 */
	public class EmitterManager extends MyObj {
		
		private var _emitter:Emitter2D;
		public function EmitterManager() {
			super();
		}
		
		override protected function addListeners():void {
			registerEventListener(_facade,FrameworkEvent.PAUSE, pauseResumeHandler);
			registerEventListener(_facade,FrameworkEvent.RESUME, pauseResumeHandler);
			super.addListeners();
		}
		
		override protected function initModelHandler(e:FrameworkEvent):void {
			_emitter = new Emitter2D();
		}
		
		private function pauseResumeHandler(e:FrameworkEvent):void {
			if (e.type == FrameworkEvent.PAUSE)_emitter.pause();
			else _emitter.resume();
		}
		
		public function initEmitterA(imageClass:Class = null, parameters:Array = null):void {
			if (!imageClass) {
				imageClass = Star;
				parameters = [8, 0x00ff00];
			}
			_emitter.counter=new Steady(60);
			_emitter.addInitializer(new ImageClass(imageClass,parameters,true));
			_emitter.addInitializer( new Lifetime( 0.3, 3 ) );
			_emitter.addInitializer( new Velocity( new DiscZone(new Point( 0, 0 ), 40, 5 ) ) );
			_emitter.addAction(new ScaleAll(1,0.1));
			_emitter.addAction( new Age() );
			_emitter.addAction(new Move());
			_emitter.addAction( new RotateToDirection() );
		}
		
		/**线区域向上，类似火*/
		public function initEmitterB(lineStart:Point,lineEnd:Point,cor1:uint=0xffff3300,cor2:uint = 0x00ffff00):void {
			_emitter.counter = new Steady(150);
			_emitter.addInitializer( new ImageClass(RadialDot,[10],true ));
			_emitter.addInitializer(new Position(new LineZone(lineStart, lineEnd)));
			_emitter.addInitializer(new Lifetime(0.2, 1.5));
			_emitter.addInitializer(new Velocity(new PointZone(new Point(0, -150))));
			_emitter.addAction(new ScaleAll(1, 0.3));
			_emitter.addAction(new Age());
			_emitter.addAction(new Move());
			_emitter.addAction(new RotateToDirection());
			_emitter.addAction(new RandomDrift(30, 30));
			_emitter.addAction(new ColorChange(cor1,cor2));
		}
		
		/**中心向外部散开*/
		public function initEmitterC(numParticles:uint=6,duration:Number=0.1,particleRadius:Number=5,filter:BitmapFilter=null):void{
			emitter.counter = new TimePeriod(numParticles,duration);
			emitter.addInitializer( new ImageClass(Dot,[particleRadius,0xffffff],true) );
			if(filter)emitter.addInitializer(new ApplyFilter(filter));
			emitter.addInitializer( new Lifetime(1, 2.5 ) );
			emitter.addInitializer( new Velocity(new DiscZone(new Point(0,-100),150,100)) );

			emitter.addAction( new RandomDrift( 200, 200) );
			emitter.addAction(new ScaleAll(1,0.3));
			emitter.addAction( new Age() );
			emitter.addAction(new Move());
			emitter.addAction( new RotateToDirection() );
		}
		
		private var _isDestroy:Boolean;
		override public function destroy():void {
			if (_isDestroy) return;
			_isDestroy = true;
			if (_emitter)_emitter.stop();
			_emitter = null;
			super.destroy();
		}
		
		public function get emitter():Emitter2D { return _emitter; }
		
	}

}