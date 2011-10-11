package {

	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import flash.display.*;
	import flash.events.*;
	import flash.external.*;
	import flash.geom.*;
	import flash.text.*;
	import flash.net.*;
	import flash.ui.*;

	public class Balloon extends MovieClip {
		public var hitPointsOrig,hitPoints,hitBalloon,deadBalloon;
		public var damageClock,damageTimer,damageTimerMax;
		public var lifeArray,lifeReady;
		public var tweenXStart,tweenXEnd,tweenYStart,tweenYEnd,tweenTime,tweenX,tweenY;

		public function Balloon() {
			super();
			lifeReady=false;
			lifeArray=[];
			init();
			addEventListener("enterFrame",lifeMeterHandler);
		}

		public function init() {
			hitPointsOrig=5;
			hitPoints=hitPointsOrig;
			damageClock=false;
			damageTimer=0;
			damageTimerMax=0.75*60;
			tweenXStart=this.x;
			tweenXEnd=mouseX;
			tweenYStart=this.y;
			tweenYEnd=mouseY;
			tweenTime=100;
			tweenX=new Tween(this,'x',Elastic.easeOut,tweenXStart,tweenXEnd,tweenTime,false);
			tweenY=new Tween(this,'y',Elastic.easeOut,tweenYStart,tweenYEnd,tweenTime,false);
			tweenX.stop();
			tweenY.stop();
			this.gotoAndPlay("loop");
			hitBalloon=false;
			deadBalloon=false;
			lifeMeterSetup();
		}

		public function lifeMeterSetup() {
			if(lifeReady){
			for (var i=0; i<lifeArray.length; i++) {
				if (this.contains(lifeArray[i])) {
					this.removeChild(lifeArray[i]);
				}
			}
			lifeArray.length=0;
			}
			for (var k=0; k<hitPoints; k++) {
				lifeArray[k]= new Heart();
				this.addChild(lifeArray[k]);
				lifeArray[k].x=(20*k)-(hitPoints*8)+(Math.abs(hitPoints-hitPointsOrig));
				lifeArray[k].y=60;
				//lifeArray[k].visible=false;
			}
			lifeReady=true;
		}

		public function lifeMeterHandler(event) {
			trace(lifeArray.length);
			if (lifeReady) {
				/*
				if (hitPoints<lifeArray.length) {
					if (this.contains(lifeArray[lifeArray.length])) {
						this.removeChild(lifeArray[lifeArray.length]);
						lifeArray.pop();
					}
				}*/
				for (var k=0; k<hitPoints; k++) {
					//lifeArray[k].visible=true;
					lifeArray[k].x=(20*k)-(hitPoints*8)+(Math.abs(hitPoints-hitPointsOrig));
					lifeArray[k].y=60;
					if (damageClock) {
						lifeArray[k].alpha=1.0;
					} else {
						if (lifeArray[k].alpha>0.0) {
							lifeArray[k].alpha-=0.01;
						} else if (lifeArray[k].alpha<0.0) {
							lifeArray[k].alpha=0.0;
						}
					}
				}
			}
		}
		/*
		public function lifeMeterHandler(event) {
		if(lifeMeterFirstRun){
		hitPoints=hitPointsOrig;
		for (var j=0; j<lifeArray.length; j++) {
		if(this.contains(lifeArray[j])){
		   this.removeChild(lifeArray[j]);
		   lifeArray.pop();
		}
		}
		for (var k=0;k<hitPoints;k++){
		lifeArray[k]= new Heart();
		this.addChild(lifeArray[k]);
		}
		lifeMeterFirstRun=false;
		}
		for (var i=0; i<lifeArray.length; i++) {
		lifeArray[i].x=(20*i)-(hitPoints*8)+(Math.abs(hitPoints-hitPointsOrig));
		lifeArray[i].y=60;
		if (damageClock) {
		lifeArray[i].alpha=1.0;
		} else {
		if (lifeArray[i].alpha>0.0) {
		lifeArray[i].alpha-=0.01;
		} else if (lifeArray[i].alpha<0.0) {
		lifeArray[i].alpha=0.0;
		}
		}
		}
		trace(lifeArray.length);
		}
		*/
	}
}