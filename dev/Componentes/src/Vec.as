package  
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.text.TextField;
	import graph.Coord;
	
	/**
	 * ...
	 * @author Arthur Tofani
	 */
	public class Vec extends ObjMoveable
	{
		public var head:Sprite;
		private var base:Sprite;
		private var body:Sprite;
		private var _autoCalculateDelta:Boolean = false;
		private var _dX:Number = 0;
		private var _dY:Number = 0;
		private var cor:uint = 0x000000;
		
		private var txt_position:TextField;
		private var txt_dX:TextField;
		private var txt_dY:TextField;
		private var sprite_deltas:Sprite;
		
		public function Vec(campo:ICampo, graph:Coord) 
		{
			super(graph, campo);
			draw();
			createLabels();
			addListeners();
			unlock();
		}
		
		
		override public function set selected(value:Boolean):void 
		{
			if (locked) return;
			super.selected = value
			this.filters = [];
			if (value) {
				this.head.filters = [glowSelect]
				this.base.filters= [glowSelect]
				this.body.filters = [glowSelect]
			} else {
				this.head.filters = []
				this.base.filters= []
				this.body.filters = []

			}
			
			
		}		
		
		private function draw():void {
			createBody();
			createBase();
			createHead();
			
		}
		
		private function createLabels():void 
		{
			sprite_deltas = new Sprite();
			addChild(sprite_deltas);
			setChildIndex(sprite_deltas, 0);
			
			txt_position = new TextField();
			txt_position.selectable = false;
			txt_position.width = 70;
			txt_position.height = 17;
			addChild(txt_position);
			setChildIndex(txt_position, 0);
			
			txt_dX = new TextField();
			txt_dX.selectable = false;
			txt_dX.width = 35;
			txt_dX.height = 17;
			addChild(txt_dX);
			setChildIndex(txt_dX, 0);
			
			txt_dY = new TextField();
			txt_dY.selectable = false;
			txt_dY.width = 35;
			txt_dY.height = 17;
			addChild(txt_dY);
			setChildIndex(txt_dY, 0);
			
			txt_position.visible = false;
			txt_dX.visible = false;
			txt_dY.visible = false;
			sprite_deltas.visible = false;
			
			refreshLabels();
		}
		
		private function refreshLabels():void 
		{
			if (head.y >= body.y) {
				txt_position.x = -30;
				txt_position.y = - (txt_position.height + 2);
			}else {
				if (head.x >= body.x) {
					txt_position.x = -65;
					txt_position.y = - (txt_position.height + 2);
				}else {
					txt_position.x = 2;
					txt_position.y = - (txt_position.height + 2);
				}
			}
			
			txt_position.text = "(" + mover.position.x.toFixed(2) + ", " + mover.position.y.toFixed(2) + ")";
			
			sprite_deltas.graphics.clear();
			sprite_deltas.graphics.lineStyle(1, 0xC0C0C0);
			sprite_deltas.graphics.moveTo(body.x, body.y);
			sprite_deltas.graphics.lineTo(head.x, body.y);
			sprite_deltas.graphics.lineTo(head.x, head.y);
			
			if (head.x >= body.x) txt_dX.x = (head.x - body.x) / 2 - 10;
			else txt_dX.x = (head.x - body.x) / 2 - 10;
			if (head.y <= body.y) txt_dX.y = 2;
			else txt_dX.y = - (txt_dX.height + 2);
			
			if (head.y <= body.y) txt_dY.y = (head.y - body.y) / 2 - 5;
			else txt_dY.y = (head.y - body.y) / 2 - 5;
			if (head.x >= body.x) txt_dY.x = head.x + 2;
			else txt_dY.x = head.x - (txt_dY.width);;
			
			txt_dX.text = dX.toFixed(2);
			txt_dY.text = dY.toFixed(2);
		}
		
		public function changeColor(color:uint):void {
			this.cor = color;
			createHead();
			refreshBody()
			
		}
		
		private var locked:Boolean = true;
		public function lock():void {
			base.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandlerBase);
			head.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandlerHead);
			locked = true;
		}
		public function unlock():void {
			if(locked){
				base.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandlerBase);
				head.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandlerHead);
				locked = false;
			}
		}		
		
		private function addListeners():void 
		{
			base.addEventListener(MouseEvent.MOUSE_OVER, showPosition);
			base.addEventListener(MouseEvent.MOUSE_OUT, hidePosition);
			
			head.addEventListener(MouseEvent.MOUSE_OVER, showDeltas);
			head.addEventListener(MouseEvent.MOUSE_OUT, hideDeltas);
		}
		
		public function removeListeners():void
		{
			base.removeEventListener(MouseEvent.MOUSE_OVER, showPosition);
			base.removeEventListener(MouseEvent.MOUSE_OUT, hidePosition);
			
			head.removeEventListener(MouseEvent.MOUSE_OVER, showDeltas);
			head.removeEventListener(MouseEvent.MOUSE_OUT, hideDeltas);
		}
		
		public function addOverOutListeners():void
		{
			head.addEventListener(MouseEvent.MOUSE_OVER, showDeltas);
			head.addEventListener(MouseEvent.MOUSE_OUT, hideDeltas);
		}
		
		public function removeOverOutListeners():void
		{
			head.removeEventListener(MouseEvent.MOUSE_OVER, showDeltas);
			head.removeEventListener(MouseEvent.MOUSE_OUT, hideDeltas);
		}
		
		private function showPosition(e:MouseEvent):void 
		{
			txt_position.visible = true;
		}
		
		private function hidePosition(e:MouseEvent):void 
		{
			txt_position.visible = false;
		}
		
		private function showDeltas(e:MouseEvent):void 
		{
			//if(!locked) {
				txt_dX.visible = true;
				txt_dY.visible = true;
				sprite_deltas.visible = true;
			//}
		}
		
		private function hideDeltas(e:MouseEvent):void 
		{
			txt_dX.visible = false;
			txt_dY.visible = false;
			sprite_deltas.visible = false;
		}
		
		private function mouseDownHandlerHead(e:MouseEvent):void 
		{
			if (autoCalculateDelta) return;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandlerHead);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandlerHead);
		}
		
		private function mouseMoveHandlerHead(e:MouseEvent):void 
		{
			var dp:Point = mover.returnPositionFromPixels(new Point(stage.mouseX, stage.mouseY));
			if(!e.shiftKey){
				var newdX:Number = dp.x - mover.position.x;
				var rounddX:Number = Math.round(newdX);
				if (Math.abs(Math.abs(rounddX) - Math.abs(newdX)) < 0.1) {
					newdX = rounddX;
				}
				dX = newdX;
				
				var newdY:Number = dp.y - mover.position.y;
				var rounddY:Number = Math.round(newdY);
				if (Math.abs(Math.abs(rounddY) - Math.abs(newdY)) < 0.1) {
					newdY = rounddY;
				}
				dY = newdY;
				
			}else{
				dX = dp.x - mover.position.x;
				dY = dp.y - mover.position.y;
			}
		}
		
		private function updateHead():void {
			var pt:Point = this.globalToLocal(mover.returnPixelsFromPosition(new Point(dX + mover.position.x, dY + mover.position.y)));			
			head.x = pt.x;
			head.y = pt.y;
			
			head.rotation = Math.atan2(head.y, head.x) * 180 / Math.PI;
			refreshBody();
			refreshLabels();
		}
		
		private function refreshBody():void 
		{
			body.graphics.clear();
			body.graphics.lineStyle(2, cor);
			body.graphics.moveTo(0, 0);
			body.graphics.lineTo(head.x, head.y);
		}
		
		private function mouseUpHandlerHead(e:MouseEvent):void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandlerHead);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandlerHead);
		}
		
		private function mouseDownHandlerBase(e:MouseEvent):void 
		{
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandlerBase);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandlerBase);
		}
		
		public function followMouse():void
		{
			this.autoCalculateDelta = true;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandlerBase);
		}
		
		public function stopfollowingMouse():void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandlerBase);
			this.autoCalculateDelta = false;
		}
		
		private function mouseMoveHandlerBase(e:MouseEvent):void 
		{
			this.mover.shiftKeyPressed = e.shiftKey;
			
			var mousePosition:Point = mover.returnPositionFromPixels(new Point(stage.mouseX, stage.mouseY));
			var newPosition:Point = new Point();
			newPosition.x = Math.max(mover.coord.xmin, Math.min(mover.coord.xmax, mousePosition.x));
			newPosition.y = Math.max(mover.coord.ymin, Math.min(mover.coord.ymax, mousePosition.y));
			
			//this.mover.setPositionByPixels(new Point(stage.mouseX, stage.mouseY));
			this.mover.position = new Point(newPosition.x, newPosition.y);
			
			if (autoCalculateDelta) calculateDelta();
			else refreshLabels();
		}
		
		private function mouseUpHandlerBase(e:MouseEvent):void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandlerBase);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandlerBase);
		}
		
		private function createHead():void 
		{
			if (head != null) {
				head.graphics.clear();
				head.graphics.beginFill(0xFF0000, 0);
				head.graphics.drawCircle(0, 0, 8);
				head.graphics.endFill();
				
				head.graphics.lineStyle(1, cor);
				head.graphics.beginFill(cor);
				head.graphics.moveTo(0, 0);
				head.graphics.lineTo(-8, 3);
				head.graphics.lineTo(-8, -3);
				head.graphics.lineTo(0, 0);
			}else{
				head = new Sprite();
				
				head.graphics.beginFill(0xFF0000, 0);
				head.graphics.drawCircle(0, 0, 8);
				head.graphics.endFill();
				
				head.graphics.lineStyle(1, cor);
				head.graphics.beginFill(cor);
				head.graphics.moveTo(0, 0);
				head.graphics.lineTo(-8, 3);
				head.graphics.lineTo(-8, -3);
				head.graphics.lineTo(0, 0);
				
				addChild(head);
			}
			
		}
		
		private function createBase():void 
		{
			base = new Sprite();
			
			base.graphics.beginFill(0xFF0000, 0);
			base.graphics.drawCircle(0, 0, 6);
			base.graphics.endFill();
			
			//base.graphics.lineStyle(1, 0x000000);
			//base.graphics.beginFill(0x000000);
			//base.graphics.drawCircle(0, 0, 2);
			
			addChild(base);
		}
		
		private function createBody():void 
		{
			body = new Sprite();
			body.graphics.lineStyle(2, cor);
			body.graphics.moveTo(0, 0);
			body.graphics.lineTo(20, 0);
			
			addChild(body);
		}
		
		public function calculateDelta():void
		{
			dX = campo.xcomp(mover.position.x, mover.position.y);
			dY = campo.ycomp(mover.position.x, mover.position.y);
		}
		
		public function highlight(value:Boolean):void
		{
			if (value) {
				this.filters = [new GlowFilter(0xFF0000)];
			}else {
				this.filters = [];
			}
		}
		

		public function get headPosition():Point
		{
			//Retorna o ponto da ponta da flecha em coordenadas locais.
			return new Point(head.x, head.y);
			
			//Retorna o ponto da ponta da flecha em coordenadas do pai desse objeto.
			//return new Point(this.x + head.x, this.y + head.y);
		}
		
		public function get dX():Number 
		{
			return _dX;
		}
		
		public function set dX(value:Number):void 
		{
			_dX = value;
			updateHead()
		}
		
		public function get dY():Number 
		{
			return _dY;
		}
		
		public function set dY(value:Number):void 
		{
			_dY = value;
			updateHead()
		}
		
		public function get autoCalculateDelta():Boolean 
		{
			return _autoCalculateDelta;
		}
		
		public function set autoCalculateDelta(value:Boolean):void 
		{
			_autoCalculateDelta = value;
			if(value) calculateDelta();
		}
		
		override public function update():void
		{
			super.update();
			updateHead();
		}
	}
	
}

