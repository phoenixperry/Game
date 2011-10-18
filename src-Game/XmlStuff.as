package {
	
	import flash.display.*;
	import flash.events.*;
	import flash.external.*;
	import flash.geom.*;
	import flash.text.*;
	import flash.net.*;
	import flash.ui.*;
	import flash.media.*;
	import flash.xml.*;
	//import flash.filesystem.*;
	
	public class XmlStuff {		
		//---   GLOBALS   ---
		public var scoreNum, scoreNumLast, scoreNumHi;
		public var readFileName="nmkSave.xml";
		public var writeFileName="nmkSave.xml";
		public var writeFilePath="";
		public var counter=0;
		public var counterMax=10;
		public var xmlLoader = new URLLoader();

		public function XmlStuff(){
			super();
			scoreNum = 0;
			xmlLoader.addEventListener(Event.COMPLETE, parseXML);
			xmlLoader.load(new URLRequest(readFileName));
		}
		
		
		//---   READ XML   -----------------------------------
		
		public function parseXML(event) {
			XML.ignoreWhitespace=true;
			var nmkSaveData=new XML(event.target.data);
			//for (var i=0; i < nmkSaveData.scoreData.length(); i++) {
				scoreNumLast=nmkSaveData.scoreData.scoreValLast;
				scoreNumHi=nmkSaveData.scoreData.scoreValHi;
			//}
		}
		
		
		//---   WRITE XML   -----------------------------------
		
		public var myLoader;
		public var nmkSaveData = new XML(<nmkSaveData/>);
		
		public function xmlAdd() {
			//first
			var scoreData = <scoreData/>;
			//--
			scoreData.appendChild(<scoreVal/>);
			scoreData.appendChild(scoreNum);
			scoreData.appendChild(<scoreValHi/>);
			scoreData.appendChild(scoreNumHi);
			//--
			//last
			nmkSaveData.appendChild(scoreData);
		}
		
		public function xmlSaveToDisk() {
			var saveStr=nmkSaveData.toXMLString();
			//var file = new File(writeFilePath + writeFileName);
			//var fs = new FileStream();
			//fs.open(file, FileMode.WRITE);
			//fs.writeUTFBytes(saveStr);
			//fs.close();
			//stop();
		}
				
	
		//---   END   ---
	}
	
}