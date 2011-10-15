package {

	public class Werner extends Enemy {
		
		public var previousX,previousY,previousSwitch,previousCounter,previousCounterMax;
		
		public function Werner() {
			super();
			pointVal = 50;
			speed = 3;
			lifeSpan = 60 * 120;
			bounceCounterMin = 1;
			chaser = true;
			zoomer = false;
			fixedTarget=true;
			previousX = this.x;
			previousY = this.y;
			previousSwitch = false;
			previousCounter = 0;
			previousCounterMax = 10;
			addEventListener("enterFrame",tailHandler);
			this.y = ground;
			var q = Math.random();
			if(q<0.5){
			this.x = -100;
			}else{
			this.x = 1124;	
			}
			targetX = Math.random() * 1024;
			targetY = this.y;			
		}
		
		//can this be added to Enemy and access tail from inside Werner?
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
			//~~~~~~~~~~~~~~~~~~~~~~~~~
			if(this.y>ground-10){
			this.y=ground;
			}
			
			if(this.x<targetX+50&&this.x>targetX-50){
			rocketFired=true;
			}
			
			if(runAway){
				rocketFired=false;
				runAway=false;
				var q=Math.random();
				if(q<0.5){
					targetX=-100;
				}else{
					targetX=1124;
				}
			}
			
			}
		
	}
}
