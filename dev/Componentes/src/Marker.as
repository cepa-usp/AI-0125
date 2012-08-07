package  
{
	import graph.Coord;
	
	/**
	 * ...
	 * @author Alexandre
	 */
	public class Marker extends ObjMoveable 
	{
		private var sprMark:SprMark;
		
		public function Marker(coord:Coord, campo:ICampo) 
		{
			super(coord, campo);
			
			mover.shiftKeyPressed = true;
			sprMark = new SprMark();
			showDirection(true);
			addChild(sprMark);
		}
		
		public function rotate():void {
			//trace(this.mover.position)
			this.rotation = ( -(Math.atan2(campo.ycomp(this.mover.position.x, this.mover.position.y), campo.xcomp(this.mover.position.x, this.mover.position.y)))) * (180 / Math.PI);
		}
		
		public function showDirection(value:Boolean):void
		{
			if (value) sprMark.gotoAndStop(1);
			else sprMark.gotoAndStop(2);
		}
		
	}

}