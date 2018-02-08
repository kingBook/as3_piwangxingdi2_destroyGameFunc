package g.fixtures {
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.Contacts.b2ContactEdge;
	import framework.events.FrameworkEvent;
	import framework.objs.GameObject;
	/**
	 * ...
	 * @author kingBook
	 * 2015/10/20 9:16
	 */
	public class SwitcherRocker extends Switcher {
		
		public function SwitcherRocker() { super(); }
		
		override protected function initModelHandler(e:FrameworkEvent):void {
			super.initModelHandler(e);
			_body.SetContactBeginCallback(contactBegin);
			_body.SetContactEndCallback(contactEnd);
		}
		
		override protected function handlingLinkObjects():void{
			var ctrlObjs:Vector.<GameObject>=_facade.getGameObjList(SwitcherCtrlObj);
			for each(var ctrlObj:SwitcherCtrlObj in ctrlObjs){
				if(ctrlObj.ctrlMySwitcherName==_myName)ctrlObj.control(true);
			}
		}
		
		private function contactBegin(contact:b2Contact):void{
			var b1:b2Body=contact.GetFixtureA().GetBody();
			var b2:b2Body=contact.GetFixtureB().GetBody();
			var ob:b2Body=b1==_body?b2:b1;
			var userData:*=ob.GetUserData();
			if(userData){
				if(_activeObjs.indexOf(userData.thisObj)>-1){
					if(!userData.swithcerRockerHit){
						userData.swithcerRockerHit=true;
						control(true);
					}
				}
			}
		}
		
		private function contactEnd(contact:b2Contact):void{
			var b1:b2Body=contact.GetFixtureA().GetBody();
			var b2:b2Body=contact.GetFixtureB().GetBody(); 
			var ob:b2Body=b1==_body?b2:b1;
			var userData:*=ob.GetUserData();
			if(userData){
				if(_activeObjs.indexOf(userData.thisObj)>-1){
					var result:Boolean=true;
					result&&=userData.swithcerRockerHit;
					result&&=!checkContactsIsTouching(getContacts(b1,b2));//所有接触都分离
					if(result){
						userData.swithcerRockerHit=false;
					}
				}
			}
		}
		
		private function checkContactsIsTouching(contacts:Vector.<b2Contact>):Boolean{
			for each(var contact:b2Contact in contacts){
				if(contact.IsTouching())return true;
			}
			return false;
		}
		
		private function getContacts(b1:b2Body,b2:b2Body):Vector.<b2Contact>{
			var list:Vector.<b2Contact>=new Vector.<b2Contact>();
			var ce:b2ContactEdge=b1.GetContactList();
			var contact:b2Contact,ba:b2Body,bb:b2Body;
			for(ce;ce;ce=ce.next){
				contact=ce.contact;
				ba=contact.GetFixtureA().GetBody();
				bb=contact.GetFixtureB().GetBody();
				var result:Boolean=false;
				result||=ba==b1&&bb==b2;
				result||=ba==b2&&bb==b1;
				if(result)list.push(contact);
			}
			return list;
		}
	};

}