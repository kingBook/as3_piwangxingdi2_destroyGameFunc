package kingBook{
	import framework.events.FrameworkEvent;
	import g.objs.PatrolEnemy;
	import interfaces.IEnemy;
	/**
	 * 猪
	 * @author kingBook
	 * 2015/11/2 15:11
	 */
	public class Enemy1 extends PatrolEnemy implements IEnemy{
		
		public function Enemy1(){
			super();
		}
		
		override protected function initModelHandler(e:FrameworkEvent):void{
			super.initModelHandler(e);
			_body.SetFixedRotation(true);
		}
		
	};

}