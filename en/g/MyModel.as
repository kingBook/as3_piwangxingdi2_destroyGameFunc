package g {
	import framework.objs.Model;
	
	/**
	 * ...
	 * @author kingBook
	 * 2014-10-13 9:02
	 */
	public class MyModel extends Model {
		protected function get _myFacade():MyFacade { return _facade as MyFacade };
		public function MyModel() {
			super();
		}
		
	}

}