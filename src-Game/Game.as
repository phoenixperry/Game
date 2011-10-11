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
	import flash.media.*;

	import com.hurlant.*;

	import com.omek.*;

	public class Game extends MovieClip {
		//---   BEGIN class Game  ---
		// learning git is so much fun. know this  - that should be ESC, then :wq!! OLD SCHOOL..
		public var constraintXKid = 550;;
		public var constraintXAdult = 750;
		public var constraintXIncrement = 20;
		public var constraintXNow = constraintXAdult;
		public var debugString_txt:TextField;
		public var introScreen, introCounterMax;
		public var levelMusic1, levelMusic2, levelMusic3, levelMusic4;
		public var levelMusicChannel:SoundChannel;
		public var balloon,cursor,bg,damage_flash;
		public var numBalloons;
		public var beckonTargetX,beckonTargetY,beckonTargetZ;
		public var debug,bossBattle,gameOver;
		public var objectArray,newObject,objectsDropped,objectCounter;
		public var levelMin,levelNow,levelMax;
		public var masterCounter,secondsMultiplier,fps;
		public var oddsOfFall,oddsOfKitty,oddsOfWeasel;
		public var jointArray,headFollower;

		/***** MOUSE AND JOINTS  
		  * scaling for the mouse. convert between the sensor width and height (160x120) to the screen width and height (1024x768)  */
		public const _screenScaleX:uint=11;
		public const _screenScaleY:uint=10;

		/***** Screen / Kinect correction 
		  * x,y correction for the mouses. set them by your camera. these work for Primesense and Panasonic */
		public const _correctionX:int =-100;
		public const _correctionY:int = 700;

		/* ssplayerLabel : index of the current skeleton
		  * jointX,y,z : x,y,z value of the joint between 0 to the sensor width. */

		///parallax vars
		public var blackg:Blackg;
		public var blackg2:Blackg;

		public var tri:Tri;
		public var tri2:Tri;

		public var colorbg:Colorbg;
		public var colorbg2:Colorbg;

		public var whiteg:Whiteg;
		public var whiteg2:Whiteg;

		public var blackgC:MovieClip;
		public var triC:MovieClip;
		public var colorbgC:MovieClip;
		public var whitegC:MovieClip;

		public var myBreadth:Number;
		public var mover:Number;

		public function Game() {
			super();
			Mouse.hide();
			levelMusic1=new Level1();
			levelMusic2=new Level2();
			levelMusic3=new Level3();
			levelMusic4=new Level4();
			levelMusicChannel = levelMusic3.play(0,int.MAX_VALUE);

			stage.addEventListener("enterFrame",doStuff);
			stage.addEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
			stage.addEventListener("mouseDown",mouseDownHandler);


			//Omek mandatory API - every application with OmekFlashWrapper MUST have these callbacks
			ExternalInterface.addCallback("OmekGesture", onOmekGesture);
			ExternalInterface.addCallback("OmekJointPosition", onOmekJointPosition);
			ExternalInterface.addCallback("OmekAlert", onOmekAlert);
			ExternalInterface.addCallback("OmekGetMaxPlayers", onOmekGetMaxPlayers);

			//Extra Omek API - use these callbacks to get answers on sensor queries ;
			//ExternalInterface.addCallback("OmekIsSensorConnected", onOmekIsSensorConnected);
			//wait for connecting to the sensor before querying it.
			addEventListener(Event.ENTER_FRAME,checkIfSensorReady);

			if (debug) {
				headFollower.graphics.beginFill(0);
				headFollower.graphics.drawCircle(20,20,30);
				addChild(headFollower);
			}

			/// add parallax to stage//parallax 
			blackg=new Blackg  ;
			tri=new Tri  ;
			colorbg=new Colorbg  ;
			whiteg=new Whiteg  ;

			blackgC = new MovieClip();
			triC = new MovieClip();
			colorbgC = new MovieClip();
			whitegC = new MovieClip();

			blackg2=new Blackg  ;
			tri2=new Tri  ;
			colorbg2=new Colorbg  ;
			whiteg2=new Whiteg  ;

			blackg.x=0;
			blackg.y=0;
			blackg2.x=2047;
			blackg2.y=0;

			tri.x=0;
			tri.y=0;
			tri2.x=2048;
			tri2.y=0;

			colorbg.x=0;
			colorbg.y=0;
			colorbg2.x=2048;
			colorbg2.y=0;

			whiteg.x=0;
			whiteg.y=0;
			whiteg2.x=2048;
			whiteg2.y=0;


			colorbgC.addChild(colorbg);
			blackgC.addChild(blackg);
			whitegC.addChild(whiteg);
			triC.addChild(tri);

			colorbgC.addChild(colorbg2);
			whitegC.addChild(whiteg2);
			blackgC.addChild(blackg2);
			triC.addChild(tri2);

			stage.addChild(colorbgC);
			stage.addChild(whitegC);
			stage.addChild(blackgC);
			stage.addChild(triC);
			myBreadth=2048;
			mover=1;
			addEventListener(Event.ENTER_FRAME, startUp);

			numBalloons=1;
			balloon=[];
			for (var j=0; j<numBalloons; j++) {
				balloon[j] = new Balloon();
				stage.addChild(balloon[j]);
			}
			cursor = new Cursor();
			stage.addChild(cursor);
			cursor.scaleX=0.5;
			cursor.scaleY=0.5;
			balloon.x=stage.stageWidth/2;
			balloon.y=stage.stageHeight/2;
			damage_flash = new Damage_flash();
			stage.addChild(damage_flash);
			damage_flash.x=stage.stageWidth/2;
			damage_flash.y=stage.stageHeight/2;
			damage_flash.blendMode=BlendMode.ADD;
			jointArray = new Array();
			headFollower = new MovieClip();
			objectArray=[];
			objectCounter=0;
			debug=false;
			if (debug) {
				cursor.visible=true;
			} else {
				cursor.visible=false;
			}
			fps=60;
			levelMin=1;
			levelNow=levelMin;
			levelMax=5;
			secondsMultiplier=60;//60 = 1 min.

			setup();

			// add some text
			debugString_txt=new TextField  ;
			var format:TextFormat=new TextFormat("Arial",16,0xFFFFFF, 1);
			debugString_txt.defaultTextFormat=format;
			debugString_txt.width=800;
			debugString_txt.height=150;
			debugString_txt.x=200;
			debugString_txt.y=200;

			debugString_txt.background=false;



		}

		public function setup() {
			introScreen=true;
			introCounterMax = 10*60;
			for (var j=0; j<balloon.length; j++) {
				balloon[j].init();
			}
			levelNow=levelMin;
			masterCounter=0;
			gameOver=false;
			bossBattle=false;
			if (objectsDropped) {
				for (var i=0; i<objectArray.length; i++) {
					if (stage.contains(objectArray[i])) {
						stage.removeChild(objectArray[i]);
					}
				}
			}
			objectsDropped=false;
			objectCounter=0;
			objectArray.length=0;
		}

		//---   BECKON   ---

		public function checkIfSensorReady(e:Event):void {
			ExternalInterface.call("OmekIsSensorConnected","");
		}

		public function onOmekIsSensorConnected(connected:String):void {
			if ( connected=="true" ) {
				removeEventListener(Event.ENTER_FRAME,checkIfSensorReady);
				sendQueriesToSensor();
			}
		}

		public function sendQueriesToSensor():void {//set the number of players the sensor tracks
			//set the number of players the sensor tracks
			ExternalInterface.call("OmekSetMaxPlayers","1");

			//ask for the tracked number of players. return a value to ExternalInterface.addCallback("OmekGetMaxPlayers", onOmekGetMaxPlayers);


			//set the sensor's tracking mode to either: "all", "basic", "upper", or "sitting";
			ExternalInterface.call("OmekSetTrackingMode","all");
			//adding+removing listeners for the sensor to specific gestures (see documentation for full list of gestures available);
			ExternalInterface.call("OmekAddGesture","leftPush");
			ExternalInterface.call("OmekAddGesture","rightClick");

		}

		//ExternalInterface.call("OmekRemoveGesture","leftPush");


		//ALL GESTURE DECTTION HERE connected : boolean (as a string) "true" or "false", marking if the sensor is ready
		public function onOmekGesture(gestureName:String, playerLabel:String):void {
			if (gestureName == "leftPush" || "rightClick") {
				debugString_txt.text=gestureName;
				stage.addChild(debugString_txt);
				debugString_txt.x=500;
				debugString_txt.y=500;
				setup();

			}
		}

		public function onOmekAlert(alertName:String, playerLabel:String):void {
		}


		public function onOmekJointPosition(jointName:String, playerLabel:String, jointX:String, jointY:String, jointZ:String, confidence:String):void {
			//give control on mouses to one specific player.


			if (playerLabel == "0") {


			}

			if (playerLabel == "1" ) {

			}

			if (jointName == "leftFingerTip") {
			}
			if (jointName == "rightFingerTip") {
			}
			if (jointName == "head") {
				//this scales x + y to screen width/height 
				beckonTargetX=stage.stageWidth-Number(jointX)*_screenScaleX+_correctionX;
				beckonTargetY=Number(jointY)*_screenScaleY+_correctionY;
				if (debug) {
					headFollower.x=beckonTargetX;
					headFollower.y=beckonTargetY;
				}
			}
		}

		//---   DRAW   ---

		public function doStuff(evt:Event) {
			debugDraw();
			if(introScreen) {
			debugString_txt.text="PLAY! Your head is the balloon. Move right to left to control it." 
			debugString_txt.x = stage.stageWidth/2-700; 
			debugString_txt.y = stage.stageHeight/2-400;
		
			stage.addChild(debugString_txt);
			debugString_txt.x=500;
			debugString_txt.y=400;
			introScreen=false;
			}
			if(masterCounter<introCounterMax){
				debugString_txt.alpha = 1.0; 
			}else{
				if(debugString_txt.alpha>0.0){
				   debugString_txt.alpha-=0.1;
				   if(debugString_txt.alpha<0.0){
					   debugString_txt.alpha = 0.0;
				   }
				   }
			}
			if (! bossBattle) {
				updateMaster();
				objectsMove();
				for (var i=0; i<balloon.length; i++) {
					balloonMove(balloon[i]);
					objectsDie(balloon[i]);
					balloonDie(balloon[i]);
				}
			} else {
				//boss battle public functions here
				/*
				balloonMove();
				balloonDie();
				*/
			}
		}

		//---   CONTROLS   ---
		public function keyDownHandler(event) {
			//if (objectsDropped && event.keyCode.toString() == 32) {
			if (event.keyCode.toString()==32) {//space
				setup();
				//ExternalInterface.call("OmekReset","")
			}
			if (event.keyCode.toString()==68) {//d
				debug=! debug;
				if (debug) {
					cursor.visible=true;
				} else {
					cursor.visible=false;
				}
			}
			if (event.keyCode.toString()==49) {//1
			levelMusicHandler(levelMusic1);
			}
			if (event.keyCode.toString()==50) {//2
			levelMusicHandler(levelMusic2);
			}
			if (event.keyCode.toString()==51) {//3
			levelMusicHandler(levelMusic3);
			}
			if (event.keyCode.toString()==52) {//4
			levelMusicHandler(levelMusic4);
			}
			if (event.keyCode.toString()==65) {//a
				constraintXNow = constraintXAdult;
				setConstraints(constraintXNow);
			}	
			if (event.keyCode.toString()==75) {//k
				constraintXNow = constraintXKid;
				setConstraints(constraintXNow);
			}
			if (event.keyCode.toString()==38) {//uparrow
				constraintXNow += constraintXIncrement;
				setConstraints(constraintXNow);
			}
			if (event.keyCode.toString()==40) {//downarrow
				constraintXNow -= constraintXIncrement;
				setConstraints(constraintXNow);
			}
						
		}

		//---

		public function mouseDownHandler(event) {
			dropObjects();
		}

		//~~~~~~~~~~~~~~~~~~~~~~~~~~     general level stuff    ~~~~~~~~~~~~~~~~~~~~~~~~~~ 
		public function levelSettings() {
			if (masterCounter == 0) {
				levelNow=1;
				trace(levelNow);
			} else if (masterCounter==1*secondsMultiplier*fps) {
				levelNow=2;
				trace(levelNow);
			} else if (masterCounter==2*secondsMultiplier*fps) {
				levelNow=3;
				trace(levelNow);
			} else if (masterCounter==3*secondsMultiplier*fps) {
				levelNow=4;
				trace(levelNow);
			} else if (masterCounter==4*secondsMultiplier*fps) {
				levelNow=5;
				trace(levelNow);
			}
			if (levelNow == 1) {
				oddsOfFall=0.992;
				oddsOfKitty=0.9;
				oddsOfWeasel=0.5;
			} else if (levelNow==2) {
				oddsOfFall=0.9915;
				oddsOfKitty=0.991;
				oddsOfWeasel=0.8;
			} else if (levelNow==3) {
				oddsOfFall=0.991;
				oddsOfKitty=0.3;
				oddsOfWeasel=1.0;
			} else if (levelNow==4) {
				oddsOfFall=0.99;
				oddsOfKitty=0.7;
				oddsOfWeasel=0.3;
			} else if (levelNow==5) {
				oddsOfFall=1.0;
				oddsOfKitty=0.6;
				oddsOfWeasel=1.0;
			}
		}

		//---
		
		public function levelMusicHandler(ls){
			levelMusicChannel.stop();
			levelMusicChannel = ls.play(0,int.MAX_VALUE);
		}
		
		//---
		
		public function setConstraints(q){
			//_correctionX = q;
		}
		
		//---

		public function updateMaster() {
			levelSettings();
			var rnd=Math.random();
			if (rnd > oddsOfFall) {
				dropObjects();
			}
			masterCounter++;
		}

		//---

		//~~~~~~~~~~~~~~~~~~~~~~~~~~     manage players    ~~~~~~~~~~~~~~~~~~~~~~~~~~ 
		public function balloonMove(theTarget) {
			if (! theTarget.hitBalloon) {
				theTarget.tweenXStart=theTarget.x;
				theTarget.tweenYStart=theTarget.y;
				if (debug) {
					theTarget.tweenXEnd = mouseX; 
					theTarget.tweenYEnd=mouseY;
				} else {
					theTarget.tweenXEnd=beckonTargetX;
					theTarget.tweenYEnd=beckonTargetY;
					if (beckonTargetX > stage.stageWidth) { theTarget.tweenXEnd = stage.stageWidth - theTarget.width;}
					if (beckonTargetY > stage.stageHeight) { theTarget.tweenYEnd = stage.stageHeight - theTarget.height;}
					if (beckonTargetX< 0) {theTarget.tweenXEnd = 0+theTarget.width/2; }
					if (beckonTargetY< 0){theTarget.tweenYEnd = 0+theTarget.height/2 ;}
				}
				theTarget.tweenX=new Tween(theTarget,'x',Elastic.easeOut,theTarget.tweenXStart,theTarget.tweenXEnd,theTarget.tweenTime,false);
				theTarget.tweenY=new Tween(theTarget,'y',Elastic.easeOut,theTarget.tweenYStart,theTarget.tweenYEnd,theTarget.tweenTime,false);
				theTarget.tweenX.start();
				theTarget.tweenY.start();
			}
		}

		//---;

		public function balloonDie(theTarget) {
			if (theTarget.damageClock) {
				if (theTarget.damageTimer<theTarget.damageTimerMax) {
					theTarget.hitBalloon=false;
					theTarget.damageTimer++;
				} else {
					theTarget.damageTimer=0;
					theTarget.damageClock=false;
				}
			}
			if (! theTarget.deadBalloon&&theTarget.hitBalloon) {
				damage_flash.gotoAndPlay("go");
				if (theTarget.hitPoints>1&&! theTarget.damageClock) {
					theTarget.gotoAndPlay("takehit");
					theTarget.hitPoints--;
					theTarget.removeChild(theTarget.lifeArray[theTarget.hitPoints]);
					theTarget.lifeArray.splice(theTarget.hitPoints,1);
					theTarget.damageClock=true;
				} else if (theTarget.hitPoints<=1 && !theTarget.damageClock) {
					theTarget.removeChild(theTarget.lifeArray[0]);
					theTarget.deadBalloon=true;
					theTarget.gotoAndPlay("pop");
				}
			}
		}

		//~~~~~~~~~~~~~~~~~~~~~~~~~~     manage enemies    ~~~~~~~~~~~~~~~~~~~~~~~~~~ 
		public function dropObjects() {
			objectsDropped=true;
			var rnd=Math.random();
			if (rnd < oddsOfKitty) {
				if (rnd < oddsOfWeasel) {
					newObject = new Weasel();
				} else {
					newObject = new Kitty();
				}
			}
			objectArray[objectCounter]=newObject;
			stage.addChild(objectArray[objectCounter]);
			objectCounter++;
		}

		//---

		public function objectsMove() {
			if (objectsDropped) {
				for (var i=0; i<objectArray.length; i++) {
					if (stage.contains(objectArray[i])) {
						objectArray[i].moveHandler();
						objectArray[i].targetX=balloon[0].x;//right now always chases first balloon
						objectArray[i].targetY=balloon[0].y;
					}
				}
			}
		}

		public function objectsDie(theTarget) {
			if (objectsDropped) {
				for (var i=0; i<objectArray.length; i++) {
					if (stage.contains(objectArray[i])) {
						if (! theTarget.deadBalloon&&hitDetect(theTarget.x,theTarget.y,theTarget.width-100,theTarget.height-100,objectArray[i].x,objectArray[i].y,objectArray[i].width,objectArray[i].height)) {
							if (theTarget.y>objectArray[i].y) {
								theTarget.hitBalloon=true;
								objectArray[i].lifeCounter=0;
							} else if (theTarget.y < objectArray[i].y-10&&theTarget.y>objectArray[i].y-50&&!theTarget.damageClock) {
								objectArray[i].lifeCounter=9999;
							}
						}
						if (objectArray[i].x<-100||objectArray[i].x>stage.stageWidth+100) {
							objectArray[i].iAmDead=true;
						}
						if (objectArray[i].lifeCounter>objectArray[i].lifeSpan) {
							if (objectArray[i].x>0&&objectArray[i].x<stage.stageWidth&&objectArray[i].y>0) {
								doPoof(objectArray[i].x,objectArray[i].y);
							}
							objectArray[i].iAmDead=true;
						}
						if (objectArray[i].iAmDead) {
							stage.removeChild(objectArray[i]);
							objectArray.splice(i,1);
							objectCounter--;
						}
					}
				}
			}
		}
		//--
		public function doPoof(xx,yy) {

			var poof = new Poof();
			stage.addChild(poof);
			poof.x=xx;
			poof.y=yy;
		}

		//~~~~~~~~~~~~~~~~~~~~~~~~~~     debug stuff    ~~~~~~~~~~~~~~~~~~~~~~~~~~ 
		public function debugDraw() {
			if (debug) {
				drawHitBox();
				drawCursor();
			}
		}

		//---

		public function drawHitBox() {
			this.graphics.clear();
			this.graphics.lineStyle(1, 0xff0000);
			this.graphics.moveTo(balloon.x-(balloon.width/2),balloon.y-(balloon.height/2));
			this.graphics.lineTo(balloon.x-(balloon.width/2),balloon.y+(balloon.height/2));
			//;
			this.graphics.lineTo(balloon.x+(balloon.width/2),balloon.y+(balloon.height/2));
			//;
			this.graphics.lineTo(balloon.x+(balloon.width/2),balloon.y-(balloon.height/2));
			//;
			this.graphics.lineTo(balloon.x-(balloon.width/2),balloon.y-(balloon.height/2));
		}

		//---;

		public function drawCursor() {
			cursor.visible=true;
			cursor.x=mouseX;
			cursor.y=mouseY;
		}

		//~~~~~~~~~~~~~~~~~~~~~~~~~~     behind-the-scenes stuff    ~~~~~~~~~~~~~~~~~~~~~~~~~~ 
		//2D Hit Detect.  Assumes center.  x,y,w,h of object 1, x,y,w,h, of object 2.
		public function hitDetect(x1, y1, w1, h1, x2, y2, w2, h2) {
			w1/=2;
			h1/=2;
			w2/=2;
			h2/=2;
			if (x1 + w1 >= x2 - w2 && x1 - w1 <= x2 + w2 && y1 + h1 >= y2 - h2 && y1 - h1 <= y2 + h2) {
				return true;
			} else {
				return false;
			}
		}
		//---   END class Game   ---
		public function startUp(evt:Event):void {

			blackgC.x=blackgC.x-mover;
			if (blackg.x+myBreadth+blackgC.x<0) {
				blackg.x=blackg.x+(2*myBreadth);
			}
			if (blackg2.x+myBreadth+blackgC.x<0) {
				blackg2.x=blackg2.x+(2*myBreadth);
			}



			whitegC.x=whitegC.x-mover/2;
			if (whiteg.x+myBreadth+whitegC.x<0) {
				whiteg.x=whiteg.x+(2*myBreadth);
			}
			if (whiteg2.x+myBreadth+whitegC.x<0) {
				whiteg2.x=whiteg2.x+(2*myBreadth);
			}





			colorbgC.x=colorbgC.x-mover-2;
			if (colorbg.x+myBreadth+colorbgC.x<0) {
				colorbg.x=colorbg.x+(2*myBreadth);
			}
			if (colorbg2.x+myBreadth+colorbgC.x<0) {
				colorbg2.x=colorbg2.x+(2*myBreadth);
			}




			triC.x=triC.x-3;

			if (tri.x+myBreadth+triC.x<0) {
				tri.x=tri.x+(2*myBreadth);
			}
			if (tri2.x+myBreadth+triC.x<0) {
				tri2.x=tri2.x+(2*myBreadth);
			}
		}


		function onOmekGetMaxPlayers(numPlayers:String):void {
			/*debugString_txt.text ="maz" + numPlayers;
			stage.addChild(debugString_txt); 
			debugString_txt.x = 500; */

		}


	}



	//---   END package   ---
}