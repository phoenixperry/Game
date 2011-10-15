package {

	public class Rocket extends Bullet {
		
		public var previousX,previousY,previousSwitch,previousCounter,previousCounterMax;
		public var rocketFired;
		
		public function Rocket() {
			super();
			pointVal = 0;
			speed = 30;
			lifeSpan = 60 * 20;
			bounceCounterMin = 1;
			chaser = true;
			zoomer = false;
			fixedTarget=true;
			previousX = this.x;
			previousY = this.y;
			previousSwitch = false;
			rocketFired=false;
			previousCounter = 0;
			previousCounterMax = 10;
			addEventListener("enterFrame",tailHandler);
			this.y = ground;
			targetX = this.x;
			targetY = -100;			
		}
		
		//can this be added to Enemy and access tail from inside Rocket?
		public function tailHandler(event) {
		
			/*
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
			//~~~~~~~~~~~~~~~~~~~~~~~~~
			if(this.y>ground-10){
			this.y=ground;
			}
			
			if(this.x<targetX+10&&this.x>targetX-10){
			rocketFired=true;
			}
			
			if(rocketFired){
				rocketFired=false;
				var q=Math.random();
				if(q<0.5){
					targetX=-100;
				}else{
					targetX=1124;
				}
			}*/
			
			}
		
	}
}
