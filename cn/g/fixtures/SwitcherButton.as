package g.fixtures {
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.Contacts.b2ContactEdge;
	import framework.objs.GameObject;
	
	/**
	 * ...
	 * @author kingBook
	 * 2015/10/20 9:16
	 */
	public class SwitcherButton extends Switcher {
		private var _isHit:Boolean;
		public function SwitcherButton() { super(); }
		
		override protected function ai():void{
			checkIsHit();
			control(false,!_isHit);
		}
		
		override protected function handlingLinkObjects():void{
			var ctrlObjs:Vector.<GameObject>=_facade.getGameObjList(SwitcherCtrlObj);
			for each(var ctrlObj:SwitcherCtrlObj in ctrlObjs){
				if(ctrlObj.ctrlMySwitcherName==_myName)ctrlObj.control(false,_isOpen?ctrlObj.initIsOpen:!ctrlObj.initIsOpen);
			}
		}
		
		private function checkIsHit():void {
			var isHit:Boolean=false;
			var ce:b2ContactEdge=_body.GetContactList();
			var contact:b2Contact,b1:b2Body,b2:b2Body,ob:b2Body,userData:*;
			for(ce;ce;ce=ce.next){
				contact=ce.contact;
				if(!contact.IsTouching())continue;
				b1=contact.GetFixtureA().GetBody();
				b2=contact.GetFixtureB().GetBody();
				ob=b1==_body?b2:b1;
				userData=ob.GetUserData();
				if(userData){
					if(_activeObjs.indexOf(userData.thisObj)>-1){
						isHit=true;
						break;
					}
				}
			}
			_isHit=isHit;
		}
		
		

	};

}