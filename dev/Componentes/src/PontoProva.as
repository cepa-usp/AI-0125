package  
{
	import cmds.CommandFactory;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import graph.Coord;
	
	/**
	 * ...
	 * @author Arthur Tofani
	 */
	public class PontoProva extends ObjMoveable
	{
		private var sprPontoProva:SprPontoProva = new SprPontoProva();
		
		public function PontoProva(campo:ICampo, graph:Coord) 
		{
			super(graph, campo);
			addChild(sprPontoProva);
			addListeners()
			commands = [CommandFactory.DELETE, CommandFactory.MARCAR_PONTO]
		}
		public function lock():void {
			removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown)
		}
		public function unlock():void {
			addListeners()
		}		
		public function addListeners():void  {
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown)
		}
		public function onMouseDown(e:MouseEvent):void  {
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp)
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove)
		}
		public function onMouseUp(e:MouseEvent):void  {
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp)
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove)			
		}
		private var minimumDistance:Number = 8;
		public function onMouseMove(e:MouseEvent):void  {
			this.mover.shiftKeyPressed = e.shiftKey;
			
			var posMouse:Point = new Point(stage.mouseX, stage.mouseY);
			var mousePosition:Point = mover.returnPositionFromPixels(new Point(stage.mouseX, stage.mouseY));
			
			if (this.mover.coord.hasCurves) {
				
				for (var i:int = 0; i < mover.coord.cs.length; i++) 
				{
					var posXonGraph:Number;
					var posYonGraph:Number;
					
					if (Math.abs(mousePosition.x) > Math.abs(mousePosition.y)) {
						posXonGraph = mousePosition.x;
						posYonGraph = levelCurve(mover.coord.cs[i], posXonGraph);
					}else {
						posYonGraph = mousePosition.y;
						posXonGraph = newFx(mover.coord.cs[i], posYonGraph);
					}
					
					var pointGraphOnStage:Point = mover.returnPixelsFromPosition(new Point(posXonGraph, posYonGraph));
					if (Point.distance(posMouse, pointGraphOnStage) < minimumDistance) {
						this.mover.position = new Point(posXonGraph, posYonGraph);
						return;
					}
				}
			}
			
			//var mousePosition:Point = mover.returnPositionFromPixels(new Point(stage.mouseX, stage.mouseY));
			var newPosition:Point = new Point();
			newPosition.x = Math.max(mover.coord.xmin, Math.min(mover.coord.xmax, mousePosition.x));
			newPosition.y = Math.max(mover.coord.ymin, Math.min(mover.coord.ymax, mousePosition.y));
			
			//this.mover.setPositionByPixels(new Point(stage.mouseX, stage.mouseY));
			this.mover.position = new Point(newPosition.x, newPosition.y);
			rotate();
		}
		
		private function levelCurve(cte:Number, x:Number):Number {
			return cte / x;
		}
		
		private function newFx(cte:Number, posY:Number):Number {
			return cte / posY;
		}
		
		public function rotate():void {
			//trace(this.mover.position)
			this.rotation = (-(Math.atan2(campo.ycomp(this.mover.position.x, this.mover.position.y), campo.xcomp(this.mover.position.x, this.mover.position.y))) + (3 * Math.PI)/2)* (180/Math.PI)
		}
		
		
	}
	
}