package {

	public class Faller extends Enemy {
		
		public var previousX,previousY,previousSwitch,previousCounter,previousCounterMax;
		
		public function Faller() {
			super();
			pointVal = 10;
			speed = 1;
			lifeSpan = 60 * 20;
			bounceCounterMin = 1;
			chaser = false;
			zoomer = true;
			zoomerDelay = 100;
			previousX = this.x;
			previousY = this.y;
			previousSwitch = false;
			previousCounter = 0;
			previousCounterMax = 10;
			addEventListener("enterFrame",tailHandler);
		}
		
		//can this be added to Enemy and access tail from inside Faller?
		public function tailHandler(event) {
		
			if (! previousSwitch) {
				if (this.y < previousY) {
					previousCounter = 0;
					previousSwitch = true;
					//this.tail.gotoAndPlay("down");
				} else if (this.y>previousY) {
					previousSwitch = true;
					previousCounter = 0;
					//this.tail.gotoAndPlay("up");
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
