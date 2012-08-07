package  
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import graph.Coord;
	
	/**
	 * ...
	 * @author Arthur Tofani
	 */
	public class Roda extends ObjMoveable
	{
		private var sprBackground:Sprite;
		private var sprRoda:SprRoda = new SprRoda();
		private const VEL_ANG_MAX:Number = 360;
		private var stop:Boolean = false;
		public function Roda(campo:ICampo, graph:Coord) 
		{
			super(graph, campo);
			addChild(sprRoda);
			
			sprBackground = new Sprite();
			sprBackground.graphics.beginFill(0x000000, 0);
			sprBackground.graphics.drawCircle(0, 0, 12);
			addChild(sprBackground);
			
			//addFlechas(campo, graph);
			
			sprBackground.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			addEventListener(Event.ENTER_FRAME, updateRoda);
			stop = false;
		}
		
		private var flechas:Array = [];
		public function addFlechas(campo:ICampo, graph:Coord):void 
		{
			for (var i:int = 0; i < 8; i++) 
			{
				var flecha:Vec = new Vec(campo, graph);
				//flecha.x = 26 * Math.cos((45 * i) * (360 / Math.PI));
				//flecha.y = 26 * Math.sin((45 * i) * (360 / Math.PI));
				flecha.mover.position = new Point(1 * Math.cos((45 * i) * (360 / Math.PI)), 1 * Math.sin((45 * i) * (360 / Math.PI)));
				flechas.push(flecha);
				addChild(flecha);
				flecha.dX = 1;
				flecha.dY = 1;
			}
		}
		
		private function mouseDownHandler(e:MouseEvent):void 
		{
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}
		
		private function mouseMoveHandler(e:MouseEvent):void 
		{
			this.mover.shiftKeyPressed = e.shiftKey;
			
			var mousePosition:Point = mover.returnPositionFromPixels(new Point(stage.mouseX, stage.mouseY));
			var newPosition:Point = new Point();
			newPosition.x = Math.max(mover.coord.xmin, Math.min(mover.coord.xmax, mousePosition.x));
			newPosition.y = Math.max(mover.coord.ymin, Math.min(mover.coord.ymax, mousePosition.y));
			
			//this.mover.setPositionByPixels(new Point(stage.mouseX, stage.mouseY));
			this.mover.position = new Point(newPosition.x, newPosition.y);
		}
		
		private function mouseUpHandler(e:MouseEvent):void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}
		
		private function updateRoda(e:Event):void 
		{
			if (stop) return;
			this.rotation -= getTheta() / stage.frameRate;
			//udpadeFlechas();
		}
		
		
		override public function prepareToRemove():void {
			stop = true;
			removeEventListener(Event.ENTER_FRAME, updateRoda);
			
		}

		override public function init():void {
			stop = false;
			addEventListener(Event.ENTER_FRAME, updateRoda);
			
		}
		
		
		private function udpadeFlechas():void 
		{
			for each (var flecha:Vec in flechas) {
				flecha.calculateDelta();
			}
		}
		
		private function getTheta():Number
		{
			var theta:Number = (VEL_ANG_MAX / campo.rot_max()) * campo.rot(mover.position.x, mover.position.y);
			return theta;
		}
		
		
		
	}
	
}