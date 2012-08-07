package  
{
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Arthur Tofani
	 */
	public class Campo2 implements ICampo
	{
		public function Campo2() 
		{
			
		}
		
		/* INTERFACE ICampo */
		
		public function xcomp(x:Number, y:Number):Number 
		{
			return x*y;
		}
		
		public function ycomp(x:Number, y:Number):Number 
		{
			return x+y;
		}
		
		public function rot(x:Number, y:Number):Number 
		{
			return (1-x);
		}
		
		/* INTERFACE ICampo */
		
		public function rot_min():Number 
		{
			return -4
		}
		
		public function rot_max():Number 
		{
			return 6;
		}
		
		/* INTERFACE ICampo */
		
		public function textXcomp():String 
		{
			return "xy"
		}
		
		public function textYcomp():String 
		{
			return "x+y"
		}
		
		public function textRot():String 
		{
			return "1-x"
		}
		
		public function textRotMin():String 
		{
			return "-4"
		}
		
		public function textRotMax():String 
		{
			return "6"
		}

		
		
		
	}
	
}