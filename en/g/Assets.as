package g {
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	/**
	 * ...
	 * @author kingBook
	 * 2014-10-09 16:33
	 */
	public dynamic class Assets extends EventDispatcher {
		public function Assets(single:Single) {
			if (!single) throw new Error("单例");
		}
		private static var _instance:Assets;
		public static function getInstance():Assets {
			if (_instance == null){
				_instance = new Assets(new Single());
				_instance.init();
			}
			return _instance ;
		}
		
		public static function destroyInstance():void{
			if(_instance){
				_instance.onDestroy();
				_instance=null;
			}
		}
		//====================================================
		/*[Embed(source = "../../../assets/pangYutou.ttf", 
		embedAsCFF = false,
		fontName = "pangYuTou",
		unicodeRange = "U+77,U+61,U+69,U+74,U+6e,U+67,U+2e,U+7b49,U+5f85,U+4e2d,U+6f,U+20,U+30,U+31,U+32,U+33,U+34,U+35,U+36,U+37,U+38,U+39,U+2d,U+2b,U+73,U+63,U+72,U+65,U+3a,U+20,U+2d",
		mimeType = "application/x-font")]
		private const _PangYuTou:Class;
		
		[Embed(source = "../../../assets/huaKangWaWa.ttf", 
		embedAsCFF = false,
		fontName = "huaKangWaWa",
		unicodeRange = "U+77,U+61,U+69,U+74,U+6e,U+67,U+2e,U+7b49,U+5f85,U+4e2d,U+6f,U+20",
		mimeType = "application/x-font")]
		private const _HuaKangWaWa:Class;
		
		[Embed(source = "../../../assets/简娃娃篆.ttf", 
		embedAsCFF = false,
		fontName = "简娃娃篆",
		unicodeRange = "U+77,U+61,U+69,U+74,U+6e,U+67,U+2e,U+7b49,U+5f85,U+4e2d,U+6f,U+20",
		mimeType = "application/x-font")]
		private const _JianWaWaHao:Class;*/
		
		[Embed(source = '../assets/Hit_mc_1.xml', mimeType='application/octet-stream')]
		private const _XML_1:Class;
		[Embed(source = '../assets/Hit_mc_2.xml', mimeType='application/octet-stream')]
		private const _XML_2:Class;
		[Embed(source = '../assets/Hit_mc_3.xml', mimeType='application/octet-stream')]
		private const _XML_3:Class;
		[Embed(source = '../assets/Hit_mc_4.xml', mimeType='application/octet-stream')]
		private const _XML_4:Class;
		[Embed(source = '../assets/Hit_mc_5.xml', mimeType='application/octet-stream')]
		private const _XML_5:Class;
		[Embed(source = '../assets/Hit_mc_6.xml', mimeType='application/octet-stream')]
		private const _XML_6:Class;
		[Embed(source = '../assets/Hit_mc_7.xml', mimeType='application/octet-stream')]
		private const _XML_7:Class;
		[Embed(source = '../assets/Hit_mc_8.xml', mimeType='application/octet-stream')]
		private const _XML_8:Class;
		[Embed(source = '../assets/Hit_mc_9.xml', mimeType='application/octet-stream')]
		private const _XML_9:Class;
		[Embed(source = '../assets/Hit_mc_10.xml', mimeType='application/octet-stream')]
		private const _XML_10:Class;
		[Embed(source = '../assets/Hit_mc_11.xml', mimeType='application/octet-stream')]
		private const _XML_11:Class;
		[Embed(source = '../assets/Hit_mc_12.xml', mimeType='application/octet-stream')]
		private const _XML_12:Class;
		[Embed(source = '../assets/Hit_mc_13.xml', mimeType='application/octet-stream')]
		private const _XML_13:Class;
		[Embed(source = '../assets/Hit_mc_14.xml', mimeType='application/octet-stream')]
		private const _XML_14:Class;
		
		
		[Embed(source="../ui.swf", mimeType="application/octet-stream")]
		private const _Ui_SWF:Class;
		[Embed(source="../sounds.swf", mimeType="application/octet-stream")]
		private const _Sounds_SWF:Class;
		[Embed(source = "../views.swf", mimeType = "application/octet-stream")]
		private const _VIEWS_SWF:Class;
		[Embed(source="../levels.swf", mimeType="application/octet-stream")]
		private const _Levels_SWF:Class;
		
		private var _loader:Loader;
		//
		//____________________________________________________________
		private function init():void {
			var lc:LoaderContext = new LoaderContext();
			lc.allowCodeImport = true;
			lc.applicationDomain = ApplicationDomain.currentDomain;
			var ldr:Loader;
			
			ldr = new Loader();
			ldr.loadBytes(new _Ui_SWF(), lc);
			ldr = new Loader ();
			ldr.loadBytes(new _Sounds_SWF(), lc);
			ldr = new Loader();
			ldr.loadBytes(new _VIEWS_SWF(), lc);
						
			ldr = new Loader();
			ldr.loadBytes(new _Levels_SWF(), lc);
			
			ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, loaded);
			_loader=ldr;
		}
		
		
		private function loaded(e:Event):void {
			e.target.removeEventListener(Event.COMPLETE, loaded);
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function getMapXML(level:uint):XML {
			if(!this["_XML_" + level])trace("没有嵌入XML_"+level);
			var __XMLClass:Class = this["_XML_" + level] ? this["_XML_" + level] : null;
			return __XMLClass ? XML(new __XMLClass()): null;
		}
		
		private function onDestroy():void{
			if(_loader){
				if(_loader.contentLoaderInfo){
					_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loaded);
				}
				_loader=null;
			}
		}
		
		
	}

}
class Single {}