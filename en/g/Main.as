package g {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import g.MyFacade;
	
	public dynamic class Main extends MovieClip {
		
		private var _maskBmp:Bitmap;
		
		public function Main() {
			if(stage)  init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
			addEventListener(Event.ENTER_FRAME,enterFrame);
			addEventListener(Event.REMOVED_FROM_STAGE,removedFromStage);
		}
		
		private function enterFrame(e:Event):void {
			removeEventListener(Event.ENTER_FRAME, enterFrame);
			if (!MyData.cancelStageMask) setMask();//进入帧后再设置舞台遮罩,避免在main的第一帧无法更改
		}
		
		private function init(e:Event=null):void{
			if (e) removeEventListener(Event.ADDED_TO_STAGE, init);
			stage.frameRate = MyData.frameRate;//锁定帧频
			Assets.getInstance().addEventListener(Event.COMPLETE, assetsLoaded);
		}
		
		private function setMask():void {
			var maskBmd:BitmapData = new BitmapData(MyData.stageW, MyData.stageH, false,0);
			maskBmd.fillRect(new Rectangle(0,0,MyData.stageW, MyData.stageH),0x00000000);
			var maskBmp:Bitmap = new Bitmap(maskBmd);
			addChild(maskBmp);
			mask = maskBmp;
			_maskBmp=maskBmp;
		}
		
		/**资源加载完成*/
		private function assetsLoaded(e:Event):void {
			e.target.removeEventListener(Event.COMPLETE, assetsLoaded);
			//启动
			MyFacade.getInstance().startup({main:this});
		}
		
		private function removedFromStage(e:Event):void{
			removeEventListener(Event.REMOVED_FROM_STAGE,removedFromStage);
			if(_maskBmp){
				if(_maskBmp.parent){
					_maskBmp.parent.removeChild(_maskBmp);
				}
				if(_maskBmp.bitmapData){
					_maskBmp.bitmapData.dispose();
				}
				_maskBmp=null;
			}
			Assets.destroyInstance();
			MyFacade.destroyInstance();
		}
		
	}
	
}
