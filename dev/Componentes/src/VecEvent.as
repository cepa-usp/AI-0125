package  
{
	import flash.events.Event;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Alexandre
	 */
	public class VecEvent extends Event 
	{
		public static var POSITION_CHANGE:String = "POSITION_CHANGE";
		public static var DELTA_CHANGE:String = "DELTA_CHANGE";
		//public static var DELTA_CHANGE:String = "DELTA_CHANGE";
		
		private var _headPos:Point = new Point();
		private var _vecPos:Point = new Point();
		
		public function VecEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) 
		{
			super(type, bubbles, cancelable);
			
		}
		
		public function get headPos():Point 
		{
			return _headPos;
		}
		
		public function set headPos(value:Point):void 
		{
			_headPos.x = value.x;
			_headPos.y = value.y;
		}
		
		public function get vecPos():Point 
		{
			return _vecPos;
		}
		
		public function set vecPos(value:Point):void 
		{
			_vecPos.x = value.x;
			_vecPos.y = value.y;
		}
		
	}

}