package g {
	import Box2D.Collision.b2Manifold;
	import Box2D.Dynamics.b2ContactImpulse;
	import Box2D.Dynamics.b2ContactListener;
	import Box2D.Dynamics.b2ContactListener;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.b2Body;
	
	/**
	 * ...
	 * @author kingBook
	 * 2015/9/18 11:39
	 */
	public class MyContactListener extends b2ContactListener {
		
		public function MyContactListener() {super();}
		
		override public function BeginContact(contact:b2Contact):void {
			var b1:b2Body = contact.GetFixtureA().GetBody();
			var b2:b2Body = contact.GetFixtureB().GetBody();
			b1.RunContactBeginCallback(contact);
			b2.RunContactBeginCallback(contact);
		}


		override public function EndContact(contact:b2Contact):void {
			var b1:b2Body = contact.GetFixtureA().GetBody();
			var b2:b2Body = contact.GetFixtureB().GetBody();
			b1.RunContactEndCallback(contact);
			b2.RunContactEndCallback(contact);
		}
		
		override public function PreSolve(contact:b2Contact, oldManifold:b2Manifold):void {
			var b1:b2Body = contact.GetFixtureA().GetBody();
			var b2:b2Body = contact.GetFixtureB().GetBody();
			b1.RunPreSolveCallback(contact,oldManifold);
			b2.RunPreSolveCallback(contact,oldManifold);
		}
		
		override public function PostSolve(contact:b2Contact, impulse:b2ContactImpulse):void {
			var b1:b2Body = contact.GetFixtureA().GetBody();
			var b2:b2Body = contact.GetFixtureB().GetBody();
			b1.RunPostSolveCallback(contact,impulse);
			b2.RunPostSolveCallback(contact,impulse);
		}
	}

}