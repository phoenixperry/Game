package com.omek 
{
	/**
	 * ...
	 * @author Shachar Oz Omek Interactive
	 */
	public class Activator extends Object
	{
		
		private var _id:uint;
		private var _rightHandPos:Array;
		private var _leftHandPos:Array;
		
		public function Activator($id:int=-1) 
		{
			if ($id > -1) _id = $id;
		}
		
		
		public function get id():uint { return _id; }
		
		public function set id(value:uint):void 
		{
			_id = value;
		}
		
		public function get leftHandPos():Array { return _leftHandPos; }
		
		public function set leftHandPos(value:Array):void 
		{
			_leftHandPos = value;
		}
		
		public function get rightHandPos():Array { return _rightHandPos; }
		
		public function set rightHandPos(value:Array):void 
		{
			_rightHandPos = value;
		}
		
	}

}