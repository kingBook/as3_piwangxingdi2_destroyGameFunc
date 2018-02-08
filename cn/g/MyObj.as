package g {
	import framework.objs.GameObject;
	
	/**
	 * ...
	 * @author kingBook
	 * 2014-10-09 15:34
	 */
	public class MyObj extends GameObject {
		
		protected function get _myFacade():MyFacade { return _facade as MyFacade };
		
		public function MyObj() {
			super();
		}
		
		
	}

}