package  
{
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Arthur Tofani
	 */
	public class Campo3 implements ICampo
	{
		public function Campo3() 
		{
			
		}
		
		/* INTERFACE ICampo */
		
		public function xcomp(x:Number, y:Number):Number 
		{
			return y;
		}
		
		public function ycomp(x:Number, y:Number):Number 
		{
			return x;
		}
		
		public function rot(x:Number, y:Number):Number 
		{
			return 0;
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
			return "y"
		}
		
		public function textYcomp():String 
		{
			return "x"
		}
		
		public function textRot():String 
		{
			return "0"
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