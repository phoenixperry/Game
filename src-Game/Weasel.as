package {

	public class Weasel extends Enemy {
		
		public var previousX,previousY,previousSwitch,previousCounter,previousCounterMax;

		public function Weasel() {
			super();
			speed = 5;
			lifeSpan = 60 * 10;
			bounceCounterMin = 3;
			chaser = true;
			chaseFriction = 100;// lower value means it tracks you faster; 1 means impossible to shake.
			previousX = this.x;
			previousY = this.y;
			previousSwitch = false;
			previousCounter = 0;
			previousCounterMax = 10;
			addEventListener("enterFrame",tailHandler);
		}
		
		//can this be added to Enemy and access tail from inside Kitty?
		public function tailHandler(event) {
			if (! previousSwitch) {
				if (this.y < previousY) {
					previousCounter = 0;
					previousSwitch = true;
					this.tail.gotoAndPlay("down");
				} else if (this.y>previousY) {
					previousSwitch = true;
					previousCounter = 0;
					this.tail.gotoAndPlay("up");
				}
			} else if (previousSwitch) {
				if (previousCounter<previousCounterMax) {
					previousCounter++;
				} else {
					previousCounter = 0;
					previousSwitch = false;
				}
			}
			previousY = this.y;
		}
		
	}
}
