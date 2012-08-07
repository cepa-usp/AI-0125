package  
{
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import learnmath.mathml.formula.latex.LatexConvertor;
	import learnmath.mathml.formula.MathML;
	import learnmath.mathml.formula.Style;
	
	/**
	 * ...
	 * @author Arthur Tofani
	 */
	public class Formula extends Sprite
	{
		
		public function Formula()
		{

		}
		
		public function fromLatex(str:String, li:LoaderInfo):void {
			var s:String = LatexConvertor.convertToMathML(str);
			//trace(loaderInfo)
			var m:MathML = new MathML(new XML(s), li.url);
			//trace(m.toLatexString())
			var style:Style = new Style();
			style.size= 24;
			style.mathvariant = "normal";
			style.color = "#000000";
			m.drawFormula(this , style, cbk);
		}
		
		private function cbk(r:Rectangle):void {
			
		}

		
	}
	
}