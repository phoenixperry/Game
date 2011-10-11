package
{
	import flash.display.MovieClip;
	import flash.events.Event; 
	
	public class ParallaxMover extends MovieClip
	{
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
		
		public function ParallaxMover()
		{
			super();
			blackg = new Blackg; 
			tri = new Tri; 
			colorbg = new Colorbg; 
			whiteg = new Whiteg; 
			
			blackgC = new MovieClip(); 
			triC = new MovieClip(); 
			colorbgC = new MovieClip(); 
			whitegC = new MovieClip(); 
			
			blackg2 = new Blackg; 
			tri2 = new Tri; 
			colorbg2 = new Colorbg; 
			whiteg2 = new Whiteg; 
			
			blackg.x = 0; 
			blackg.y = 0; 
			blackg2.x = 2047; 
			blackg2.y = 0; 
			
			tri.x = 0; 
			tri.y = 0; 
			tri2.x = 2048; 
			tri2.y = 0; 
			
			colorbg.x = 0; 
			colorbg.y =0; 
			colorbg2.x = 2048; 
			colorbg2.y = 0; 
			
			whiteg.x = 0; 
			whiteg.y = 0;
			whiteg2.x = 2048; 
			whiteg2.y = 0; 
			
			
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
			
			
			myBreadth = 2047; 
			mover = 1; 
			addEventListener(Event.ENTER_FRAME, startUp); 
			
		}
		public function startUp(evt:Event):void {
			
			blackgC.x = blackgC.x - mover;
			if (blackg.x + myBreadth+ blackgC.x  < 0){
				blackg.x = blackg.x + (2*myBreadth); 
			}
			if ( blackg2.x + myBreadth + blackgC.x < 0 )
			{
				blackg2.x = blackg2.x + (2 * myBreadth);
			}
			
			
			
			whitegC.x = whitegC.x - mover/2;
			if (whiteg.x + myBreadth+ whitegC.x  < 0){
				whiteg.x = whiteg.x + (2*myBreadth); 
			}
			if ( whiteg2.x + myBreadth + whitegC.x < 0 )
			{
				whiteg2.x = whiteg2.x + (2 * myBreadth);
			}
			
			
			
			
			
			colorbgC.x = colorbgC.x - mover-2;
			if (colorbg.x + myBreadth+ colorbgC.x  < 0){
				colorbg.x = colorbg.x + (2*myBreadth); 
			}
			if ( colorbg2.x + myBreadth + colorbgC.x < 0 )
			{
				colorbg2.x = colorbg2.x + (2 * myBreadth);
			}
			
			
			
			
			triC.x = triC.x - 3;
			
			if (tri.x + myBreadth+ triC.x  <0){
				tri.x = tri.x + (2*myBreadth); 
			}
			if ( tri2.x + myBreadth + triC.x < 0)
			{
				tri2.x = tri2.x + (2 * myBreadth);
			}
			
			
			
			
			
		}
		
	}
}