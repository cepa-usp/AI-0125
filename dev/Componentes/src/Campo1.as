package  
{
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Arthur Tofani
	 */
	public class Campo1 implements ICampo
	{
		public function Campo1() 
		{
			
		}
		
		/* INTERFACE ICampo */
		
		public function xcomp(x:Number, y:Number):Number 
		{
			return Math.sin(y);
		}
		
		public function ycomp(x:Number, y:Number):Number 
		{
			return Math.cos(x);
		}
		
		public function rot(x:Number, y:Number):Number 
		{
			return -(Math.sin(x) + Math.cos(y));
		}
		
		/* INTERFACE ICampo */
		
		public function rot_min():Number 
		{
			return -2
		}
		
		public function rot_max():Number 
		{
			return 2;
		}
		
		/* INTERFACE ICampo */
		
		public function textXcomp():String 
		{
			return "sen(x)"
		}
		
		public function textYcomp():String 
		{
			return "cos(x)"
		}
		
		public function textRot():String 
		{
			return "-(sen(x) + cos(y))"
		}
		
		public function textRotMin():String 
		{
			return "-2"
		}
		
		public function textRotMax():String 
		{
			return "-2"
		}

		
		
		
	}
	
}