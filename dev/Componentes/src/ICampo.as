package  
{
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Arthur Tofani
	 */
	public interface ICampo 
	{
		function xcomp(x:Number, y:Number):Number 
		function ycomp(x:Number, y:Number):Number 
		function textXcomp():String
		function textYcomp():String
		function textRot():String
		function textRotMin():String
		function textRotMax():String
		function rot(x:Number, y:Number):Number
		function rot_min():Number
		function rot_max():Number
	
	}
	
}