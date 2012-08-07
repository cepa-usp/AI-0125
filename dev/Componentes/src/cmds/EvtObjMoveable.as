package cmds 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Arthur Tofani
	 */
	public class EvtObjMoveable extends Event 
	{
		
		public function EvtObjMoveable(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new EvtObjMoveable(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("EvtObjMoveable", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}