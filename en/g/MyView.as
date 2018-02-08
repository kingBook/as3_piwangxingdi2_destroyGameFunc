package g {
	import framework.objs.View;
	
	/**
	 * ...
	 * @author kingBook
	 * 2014-10-13 9:03
	 */
	public class MyView extends View {
		protected function get _myFacade():MyFacade { return _facade as MyFacade };
		public function MyView() {
			super();
		}
		
	}

}