package {

import flash.display.*;
import flash.events.*;
import flash.external.*;
import flash.geom.*;
import flash.text.*;
import flash.net.*;
import flash.ui.*;

	public class Enemy extends MovieClip{

		public var speed,xDelta,bounceSwitch,bounceCounter,bounceCounterMin,bounceCounterMax,zoomer,zoomerDelay,chaser,chaseFriction,targetX,targetY,lifeSpan;
		//public var ground = stage.stageHeight - 100;
		//how do we get this to inherit from Main?
		public var ground = 668;
		public var startPoint = -100;
		public var iAmDead,lifeCounter;
		public var bounceFailSafeCount;
		public var bounceFailSafeCountMax = 3;//removes enemies that get stuck
		public var pointVal = 0;

		public function Enemy() {
			super(); 
			iAmDead = false;
			speed = 4;
			zoomer = false;
			zoomerDelay = 300;
			chaser = false;
			chaseFriction = 100;
			lifeCounter = 0;
			lifeSpan = 60 * 20;
			bounceFailSafeCount = 0;
			this.x = Math.random() * 1024;
			this.y = startPoint;
			xDelta = (Math.random() * 10) - 5;
			bounceSwitch = false;
			bounceCounter = 0;
			bounceCounterMin = 1;
			bounceCounterMax = int(bounceCounterMin+(Math.random() * 10));
			randomFace();
		}

		public function randomFace() {
			var q = Math.random();
			if (q > 0.5) {
				this.scaleX *=  -1;
			}
		}

		public function reverseFace() {
			this.scaleX *=  -1;
		}

		public function moveHandler() {
		if(zoomer&&lifeCounter>zoomerDelay){
		speed = 10;
		}
			this.y = this.y + speed;
			if (this.y > ground) {
				speed *=  -1;
				bounceSwitch = true;
				bounceCounter++;
				bounceFailSafeCount++;
				this.gotoAndPlay("bounce");
			} else {
				bounceFailSafeCount = 0;
			}
			if (bounceFailSafeCount > bounceFailSafeCountMax) {
				lifeCounter = 9999;
			}
			if (bounceSwitch && bounceCounter < bounceCounterMax) {
				var foo = Math.random();
				if (foo > 0.9) {
					speed++;
				}
				this.x +=  xDelta;
			}

			if (bounceCounter > bounceCounterMax) {
				speed *=  0.9;
			}
			if (chaser && bounceSwitch) {
				this.x +=  (targetX - this.x) / chaseFriction;
				if (this.x < targetX) {
					this.scaleX = -1.0;
				} else if (this.x>targetX) {
					this.scaleX = 1.0;
				}
			}
			lifeCounter++;
		}

		//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

		/*
		public function blurEffect(sharpness:int,quality:int) {
			var blurAmount = Math.abs(this.z / sharpness);
			var xBlur = blurAmount;//(speed * 2);
			var yBlur = blurAmount;//(speed * 2);
			var blur = new BlurFilter(xBlur,yBlur,quality);
			this.filters = [blur];
		}

		public function tintEffect(color:String) {
			var tint = this.transform.colorTransform;
			tint.color = color;
			this.transform.colorTransform = tint;
		}
		*/

	}
	
}