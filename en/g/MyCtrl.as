package g {
	import framework.objs.Controller;
	
	/**
	 * ...
	 * @author kingBook
	 * 2014-10-13 9:02
	 */
	public class MyCtrl extends Controller {
		protected function get _myFacade():MyFacade { return _facade as MyFacade };
		public function MyCtrl() {
			super();
		}
		
	}

}