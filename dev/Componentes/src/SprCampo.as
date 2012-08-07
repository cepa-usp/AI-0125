package  
{
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Arthur Tofani
	 */
	public class SprCampo extends Sprite
	{
		private var _campo:ICampo;
		
		public function SprCampo(cp:ICampo) 
		{
			campo = cp;
		}
		
		public function get campo():ICampo 
		{
			return _campo;
		}
		
		public function set campo(value:ICampo):void 
		{
			_campo = value;
		}
		
		private function draw(li:LoaderInfo) {
			var str:String = "$(" + campo.textXcomp() + ", " + campo.textYcomp + ")$"
			var frm:Formula = new Formula()
			addChild(frm.fromLatex(str, li))
			
		}
		
	}
	
}