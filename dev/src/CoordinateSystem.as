package  
{
	import cepa.graph.rectangular.SimpleGraph;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Alexandre
	 */
	public class CoordinateSystem extends SimpleGraph implements iCoordinateSystem
	{
		private var zoomInBtn:ZoomIn;
		private var zoomOutBtn:ZoomOut;
		
		/**
		 * Cria um gráfico retangular bidimensional.
		 * @param	xmin - O limite inferior da variável dependente (x).
		 * @param	xmax - O limite superior da variável dependente (x).
		 * @param	xsize - O tamanho horizontal do gráfico, em pixels.
		 * @param	ymin - O limite inferior da variável dependente (y).
		 * @param	ymax - O limite superior da variável dependente (y).
		 * @param	ysize - O tamanho vertical do gráfico, em pixels.
		 */
		public function CoordinateSystem(xmin:Number, xmax:Number, xsize:Number, ymin:Number, ymax:Number, ysize:Number, limitLock:Boolean = true) {
			super(xmin, xmax, xsize, ymin, ymax, ysize);
			super.draw();
			
			this.limitLock = limitLock;
			if (limitLock) {
				inferiorLimitsForZoom = new Point(xmin, ymin);
				superiorLimitsForZoom = new Point(xmax, ymax);
			}
			
			addButtons();
			initVariables();
			addListeners();
		}
		
		private function addButtons():void 
		{
			zoomInBtn = new ZoomIn();
			addChild(zoomInBtn);
			zoomInBtn.x = 20;
			zoomInBtn.y = -20;
			zoomInBtn.gotoAndStop(1);
			
			zoomOutBtn = new ZoomOut();
			addChild(zoomOutBtn);
			zoomOutBtn.x = 60;
			zoomOutBtn.y = -20;
			zoomOutBtn.gotoAndStop(1);
		}
		
		private function initVariables():void 
		{
			
		}
		
		private function addListeners():void{
			zoomInBtn.addEventListener(MouseEvent.CLICK, setZoomInClick);
			zoomOutBtn.addEventListener(MouseEvent.CLICK, setZoomOutClick);
			this.addEventListener(MouseEvent.MOUSE_DOWN, initSelection);
		}
		
		private function refreshGraph():void {
			super.draw();
			//TO DO: disparar evento de atualização do gráfico.
		}
		
		//*******************************************************************************************//
		//------------------------------------ Funções de zoom --------------------------------------//
		
		private var zoomFactor:Number = 1;
		private var limitLock:Boolean;
		private var inferiorLimitsForZoom:Point;
		private var superiorLimitsForZoom:Point;
		private var posClick:Point;
		private var zoomCount:int = 0;
		private var zoomCountLimit:int = 30;
		
		private function setZoomInClick(e:MouseEvent):void 
		{
			this.removeEventListener(MouseEvent.CLICK, zoomInPos, true);
			this.removeEventListener(MouseEvent.CLICK, zoomOutPos, true);
			zoomOutBtn.gotoAndStop(1);
			
			if(zoomInBtn.currentFrame == 1){
				this.addEventListener(MouseEvent.CLICK, zoomInPos, true);
				zoomInBtn.gotoAndStop(2);
			}else {
				zoomInBtn.gotoAndStop(1);
			}
		}
		
		private function setZoomOutClick(e:MouseEvent):void 
		{
			this.removeEventListener(MouseEvent.CLICK, zoomInPos, true);
			this.removeEventListener(MouseEvent.CLICK, zoomOutPos, true);
			zoomInBtn.gotoAndStop(1);
			
			if(zoomOutBtn.currentFrame == 1){
				this.addEventListener(MouseEvent.CLICK, zoomOutPos, true);
				zoomOutBtn.gotoAndStop(2);
			}else {
				zoomOutBtn.gotoAndStop(1);
			}
		}
		
		private function zoomInPos(e:MouseEvent):void {
			posClick = new Point(e.localX, e.localY);
			trace(super.xmin, super.xmax);
			trace(super.pixel2x(posClick.x), super.pixel2y(posClick.y));
			if (super.pixel2x(posClick.x) >= super.xmin &&
			super.pixel2x(posClick.x) <= super.xmax &&
			super.pixel2y(posClick.y) >= super.ymin &&
			super.pixel2y(posClick.y) <= super.ymax){
				zoomIn();
			}
		}
		
		private function zoomOutPos(e:MouseEvent):void {
			posClick = new Point(e.localX, e.localY);
			trace(super.xmin, super.xmax);
			trace(super.pixel2x(posClick.x), super.pixel2y(posClick.y));
			if (super.pixel2x(posClick.x) >= super.xmin &&
			super.pixel2x(posClick.x) <= super.xmax &&
			super.pixel2y(posClick.y) >= super.ymin &&
			super.pixel2y(posClick.y) <= super.ymax){
				zoomOut();
			}
		}
		
		public function zoomIn():void {
			trace("in");
			if (zoomCount < zoomCountLimit || zoomCountLimit == -1) {
				zoomCount++;
				zoomFactor = Math.abs(zoomFactor);
				zoom();
			}
			posClick = null;
		}
		
		public function zoomOut():void {
			trace("out");
			if (zoomCount > 0 || zoomCountLimit == -1) {
				zoomCount--;
				zoomFactor = -Math.abs(zoomFactor);
				zoom();
			}
			posClick = null;
		}
		
		private function zoom():void{
			var new_xmin:Number;
			var new_xmax:Number;
			var new_ymin:Number;
			var new_ymax:Number;
				
			if (posClick != null) {
				var posMouseOnGraph:Point = new Point(super.pixel2x(posClick.x), super.pixel2y(posClick.y));
				var graphXRange:Number = super.xmax - super.xmin - zoomFactor;
				var graphYRange:Number = super.ymax - super.ymin - zoomFactor;
				
				new_xmin = posMouseOnGraph.x - graphXRange / 2;
				new_xmax = posMouseOnGraph.x + graphXRange / 2;
				new_ymin = posMouseOnGraph.y - graphYRange / 2;
				new_ymax = posMouseOnGraph.y + graphYRange / 2;
					
				if (limitLock) {
					if (new_xmin < inferiorLimitsForZoom.x) {
						new_xmax += Math.abs(new_xmin) - Math.abs(inferiorLimitsForZoom.x);
						new_xmin = inferiorLimitsForZoom.x;
					}else if (new_xmax > superiorLimitsForZoom.x) {
						new_xmin -= new_xmax - superiorLimitsForZoom.x;
						new_xmax = superiorLimitsForZoom.x;
					}
					
					if (new_ymin < inferiorLimitsForZoom.y) {
						new_ymax += Math.abs(new_ymin) - Math.abs(inferiorLimitsForZoom.y);
						new_ymin = inferiorLimitsForZoom.y;
					}else if (new_ymax > superiorLimitsForZoom.y) {
						new_ymin -= new_ymax - superiorLimitsForZoom.y;
						new_ymax = superiorLimitsForZoom.y;
					}
				}
			}else {
				new_xmin = super.xmin;
				new_xmax = super.xmax - zoomFactor;
				new_ymin = super.ymin;
				new_ymax = super.ymax - zoomFactor;
			}
			
			super.setRange(new_xmin, new_xmax, new_ymin, new_ymax);
			refreshGraph();
		}
		
		private function resetRange(xmin:Number, xmax:Number, ymin:Number, ymax:Number):void{
			super.xmin = xmin;
			super.xmax = xmax;
			super.ymin = ymin;
			super.ymax = ymax;
			
			refreshGraph();
		}
		
		//------------------------------------ Fim das funções de zoom ------------------------------//
		//*******************************************************************************************//
		//------------------------------------ Funções da grade --------------------------------------//
		
		public function viewGrade(value:Boolean):void{
			super.grid = value;
			refreshGraph();
		}
		
		//------------------------------------ Fim das funções da grade ------------------------------//
		//*******************************************************************************************//
		//------------------------------------ Funções de seleção --------------------------------------//
		
		private function initSelection(e:MouseEvent):void 
		{
			
		}
		
		//------------------------------------ Fim das funções de seleção ------------------------------//
		//*******************************************************************************************//
		//------------------------------------ Funções de seleção --------------------------------------//
		
		
		
		//------------------------------------ Fim das funções de seleção ------------------------------//
		//*******************************************************************************************//
		
	}

}