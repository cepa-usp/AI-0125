package 
{
	import cepa.graph.SpritePoint;
	import cmds.Cmd_Delete;
	import cmds.ICommand;
	import com.adobe.serialization.json.JSONDecoder;
	import com.adobe.serialization.json.JSONEncoder;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import graph.Coord;
	import graph.CoordState;
	
	
	/**
	 * ...
	 * @author Arthur Tofani
	 */
	public class Main extends Sprite 
	{
		//Camadas
		private var vecsLayer:Sprite;
		private var graphLayer:Sprite;
		private var rodaLayer:Sprite;
		private var pontoProvaLayer:Sprite;
		private var markLayer:Sprite;
		private var pathLayer:Sprite;
		private var fieldLayer:Sprite;
		private var buttonsLayer:Sprite;
		private var particulaLayer:Sprite;
		private var vecBackgroundLayer:Sprite;
		private var answerVecLayer:Sprite;
		private var answerEx2Layer:Sprite;
		private var formula:Formula;
		
		//Eixo de coordenadas
		private var cartesianAxis:Coord;
		//Vetor com os objetos do tipo IMoveable.
		private var objectsMoveable:Vector.<ObjMoveable> = new Vector.<ObjMoveable>();
		private var marks:Vector.<Marker> = new Vector.<Marker>();
		private var answerVecs:Vector.<Vec> = new Vector.<Vec>();
		private var answerMarkers:Vector.<Marker> = new Vector.<Marker>();
		private var backgourndVecs:Vector.<Vec> = new Vector.<Vec>();
		
		//Botões
		private var vecButton:VecButton;
		private var rodaButton:RodaButton;
		private var pontoProvaButton:PontoProvaButton;
		private var particulaButton:ParticulaButton;
		private var markButton:MarkButton;
		private var delButton:GarbageButton;
		
		//Objeto roda
		private var roda:Roda;
		
		//Objeto POntoProva
		private var pontoProva:PontoProva;
		private var undolist:Vector.<ICommand> = new Vector.<ICommand>();
		
		//Campo atual
		private var campoAtual:ICampo;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			this.scrollRect = new Rectangle(0, 0, 640, 480);
			// entry point
			createLayers();
			createGraph();
			createButtons();
			setField("Campo2");
			createBackgroundVectors();
			showField(false);
			showFieldName(false);
			configExternalInterface();
			stage.addEventListener(KeyboardEvent.KEY_UP, bindKeys)
			//stage.addEventListener(MouseEvent.CLICK, testMark);
			//setMouseVec(true);
		}
		
		private function configExternalInterface():void 
		{
			if (ExternalInterface.available) {
				ExternalInterface.addCallback("showField", showField);
				ExternalInterface.addCallback("showFieldName", showFieldName);
				ExternalInterface.addCallback("setMouseVec", setMouseVec);
				ExternalInterface.addCallback("setAllButtonsInteractive", setAllButtonsInteractive);
				ExternalInterface.addCallback("setButtonInteractive", setButtonInteractive);
				ExternalInterface.addCallback("getUserCount", getUserCount);
				ExternalInterface.addCallback("getMinimunDistanceBetweenVecs", getMinimunDistanceBetweenVecs);
				ExternalInterface.addCallback("addAnswerEx1", addAnswerEx1);
				ExternalInterface.addCallback("reset", reset);
				ExternalInterface.addCallback("addCurves", addCurves);
				
				ExternalInterface.addCallback("removeCurves", removeCurves);
				ExternalInterface.addCallback("addAnswerEx2", addAnswerEx2);
				ExternalInterface.addCallback("changeBounds", changeBounds);
				ExternalInterface.addCallback("setMaxVecs", setMaxVecs);
				ExternalInterface.addCallback("setMaxMarkers", setMaxMarkers);
				ExternalInterface.addCallback("getScoreEx1", getScoreEx1);
				ExternalInterface.addCallback("getMinimunDistanceBetweenMarkers", getMinimunDistanceBetweenMarkers);
				ExternalInterface.addCallback("setField", setField);
				ExternalInterface.addCallback("getPositionX", getPositionX);
				ExternalInterface.addCallback("getPositionY", getPositionY);
				ExternalInterface.addCallback("doNothing", doNothing);
				ExternalInterface.addCallback("addVec", addVec);
				ExternalInterface.addCallback("marshalObjects", marshalObjects);
				ExternalInterface.addCallback("unmarshalObjects", unmarshalObjects);
				
			}
		}
		
		public function reset():void
		{
			for each(var obj:ObjMoveable in objectsMoveable) {
				obj.prepareToRemove();
				obj.parent.removeChild(obj);
				obj = null;
			}
			objectsMoveable.splice(0, objectsMoveable.length);
			undolist.splice(0, undolist.length);
			for each(var mk:Marker in answerMarkers) {
				mk.prepareToRemove();
				mk.parent.removeChild(mk);
				mk = null;
			}
			answerMarkers.splice(0, answerMarkers.length);
			answerEx2Layer.graphics.clear();
			marks.splice(0, marks.length);
			
			for each(var vec:Vec in answerVecs) {
				answerVecLayer.removeChild(vec);
				vec = null;
			}
			
			answerVecs.splice(0, answerVecs.length);
			
			var xmin:Number = -5;
			var xmax:Number = 5;
			var ymin:Number = -5;
			var ymax:Number = 5;
			
			cartesianAxis.changeBounds(xmin, xmax, ymin, ymax);
			setAllButtonsInteractive(true);
			
			pathLayer.graphics.clear();
			ex1Done = false;
			ex1Score = 0;
			ex2Done = false;
			ex2Score = 0;
			
			mouseVec = null;
			
			removeCurves();
		}
		
		private var tmpString:String = "";
		private function bindKeys(e:KeyboardEvent):void {
			//trace("code: " + e.charCode);
			switch(e.charCode) {
				case 127: // delete
					deleteObjects();
					break;
				//case 122: //ctrl+z
					//if (e.ctrlKey) {
						//undo();
					//}
					//break;
				case 109: //m
				case 77:  //M
					addMark(null);
					break;
				//case 65:
				//case 97:
					//addAnswerEx1();
					//break;
				//case 82: //R
				//case 114://r
					//reset();
					//break;
				//case 83: //S
				//case 115://s
					//unmarshalObjects(tmpString)
					//addCurves();
					//break;
				//case 87: //W
				//case 119://w
					//removeCurves();
					//tmpString = marshalObjects()
					//trace(tmpString)
					//reset();
					//break;
				//case 50: //2
				//
					//addAnswerEx2();
					//break;
				
			}
		}
		
	public function marshalObjects():String {
		var a:Array = new Array();
		
		var json:JSONEncoder;
		for each(var obj:ObjMoveable in objectsMoveable) {
			
			var o:Object = new Object();
			var tipo:String = "";
			o.posx = obj.mover.position.x;
			o.posy = obj.mover.position.y;
			o.parentName = obj.parent.name;
			if (obj is Vec) {
				tipo = "Vec"
				o.dx = Vec(obj).dX;
				o.dy = Vec(obj).dY;		
			}
			if (obj is Roda) {
				tipo = "Roda"
			}
			if (obj is PontoProva) {
				tipo = "PontoProva"
			}			
			if (obj is Marker) {
				tipo = "Marker"
			}			
			if (obj is Particula) {
				tipo = "Particula"
			}			
			o.tipo = tipo;
			a.push(o);		
		}
		json = new JSONEncoder(a);
		return json.getString();
	}

	
	
	public function unmarshalObjects(str:String):void {
		if (str == "") return;
		var a:Array;
		var json:JSONDecoder = new JSONDecoder(str);
		a = json.getValue();
		
		for each(var o:Object in a) {
			var obj:ObjMoveable;
			if (o.tipo == "Vec") {
				obj = new Vec(campoAtual, cartesianAxis);
			}
			if (o.tipo == "Roda") {
				obj = new Roda(campoAtual, cartesianAxis);
			}
			if (o.tipo == "PontoProva") {
				obj = new PontoProva(campoAtual, cartesianAxis);
			}			
			if (o.tipo == "Marker") {
				obj = new Marker(cartesianAxis, campoAtual);
			}			
			if (o.tipo == "Particula") {
				obj = new Particula(cartesianAxis, campoAtual);
			}
			
			obj.mover.position = new Point(o.posx, o.posy);
			if (o.tipo == "Vec") {
				Vec(obj).dX = o.dx;
				Vec(obj).dY = o.dy;
			
			}
			
			//obj.mover.position.x = o.posx;
			//obj.mover.position.y = o.posy;
			
			addToLayer(Sprite(getChildByName(o.parentName)), obj)
			
		}
	}
	
	
		public function setField(campo:String):void
		{
			switch(campo) {
				case "Campo1":
					campoAtual = new Campo1();
					break;
				case "Campo2":
					campoAtual = new Campo2();
					break;
				case "Campo3":
					campoAtual = new Campo3();
					break;

				case "":
					//campoAtual = new ICampo();
					break;
				case "":
					//campoAtual = new ICampo();
					break;
				default:
					campoAtual = new Campo1();
			}
			
			if (formula != null) {
				fieldLayer.removeChild(formula);
			}
			formula = new Formula()
			formula.fromLatex("$F(x, y) = (" + campoAtual.textXcomp() + ", " + campoAtual.textYcomp() +  ")$", this.loaderInfo);
			fieldLayer.addChild(formula);
			fieldLayer.x = 40;
			fieldLayer.y = 450;
			createBackgroundVectors();
		}
		
		private function createBackgroundVectors():void {
			if (backgourndVecs.length > 0) {
				for each(var vector:Vec in backgourndVecs) {
					vecBackgroundLayer.removeChild(vector);
					vector = null;
				}
				backgourndVecs.splice(0, backgourndVecs.length);
			}
			
			//for (var i:Number = -5; i <= 5; i+=0.5) 
			for (var i:Number = Math.floor(cartesianAxis.xmin); i <= Math.ceil(cartesianAxis.xmax); i+=0.5) 
			{
				//for (var j:Number = -5; j <= 5; j+=0.5) 
				for (var j:Number = Math.floor(cartesianAxis.ymin); j <= Math.ceil(cartesianAxis.ymax); j+=0.5) 
				{
					var vec:Vec = new Vec(campoAtual, cartesianAxis);
					//addToLayer(vecBackgroundLayer, vec);
					vecBackgroundLayer.addChild(vec);
					vec.mover.position = new Point(i, j);
					vec.calculateDelta();
					vec.lock();
					vec.removeListeners();
					//vec.addOverOutListeners();
					vec.changeColor(0xC0C0C0);
					vec.alpha = 0.5;
					backgourndVecs.push(vec);
				}				
			}
		}
		
		private function deleteObjects():void {
			var v:Vector.<ICommand> = new Vector.<ICommand>();
			var hasMarks:Boolean = false;
			for each (var o:ObjMoveable in objectsMoveable) 
			{
				if (o.selected) {
					var cmd:Cmd_Delete = new Cmd_Delete(this, o)
					v.push(cmd)
					if (o is Marker) {
						marks.splice(marks.indexOf(o), 1);
						hasMarks = true;
					}
				}
			}
			for each (var c:ICommand in v) 
			{
					c.exec();
					undolist.push(c);
			}
			if (hasMarks) redrawPath();
		}
		
		
		private function undo():void {
			if (undolist.length > 0) {
				var cmd:ICommand = undolist.pop();			
				cmd.undo();
				
			}
		}


		private var pathColor:uint = 0x800000;
		private var maxMarkers:int = -1;
		private function addMark(e:MouseEvent):void 
		{
			if(pontoProva != null && !ex2Done && (getUserCount("MARKER") < maxMarkers || maxMarkers == -1)){
				if(stage.contains(pontoProva)){
					for each (var marca:Marker in marks) {
						marca.showDirection(false);
					}
					
					var mark:Marker = new Marker(cartesianAxis, campoAtual);
					addToLayer(markLayer, mark);
					marks.push(mark);
					
					//mark.mover.setPositionByPixels(new Point(mouseX, mouseY));
					mark.mover.position = pontoProva.mover.position;
					mark.rotate();
					
					if (marks.length > 1) {
						pathLayer.graphics.lineStyle(2, pathColor);
						pathLayer.graphics.moveTo(marks[marks.length - 2].x, marks[marks.length - 2].y);
						pathLayer.graphics.lineTo(marks[marks.length - 1].x, marks[marks.length - 1].y);
					}
				}
			}
		}
		
		/**
		 * Cria as camadas e as adiciona de acordo com a ordem necessária para os elementos.
		 */
		private function createLayers():void 
		{
			vecBackgroundLayer = new Sprite();
			vecBackgroundLayer.name = "vecBackgroundLayer";
			addChild(vecBackgroundLayer);
			graphLayer = new Sprite();
			graphLayer.name = "graphLayer";
			addChild(graphLayer);
			answerVecLayer = new Sprite();
			answerVecLayer.name = "answerVecLayer";
			addChild(answerVecLayer);
			answerEx2Layer = new Sprite();
			answerEx2Layer.name = "answerEx2Layer";
			addChild(answerEx2Layer);
			pathLayer = new Sprite();
			pathLayer.name = "pathLayer";
			addChild(pathLayer);
			rodaLayer = new Sprite();
			rodaLayer.name = "rodaLayer";
			addChild(rodaLayer);
			particulaLayer = new Sprite();
			particulaLayer.name = "particulaLayer";
			addChild(particulaLayer);
			markLayer = new Sprite();
			markLayer.name = "markLayer";
			addChild(markLayer);
			pontoProvaLayer = new Sprite();
			pontoProvaLayer.name = "pontoProvaLayer";
			addChild(pontoProvaLayer);
			vecsLayer = new Sprite();
			vecsLayer.name = "vecsLayer";
			addChild(vecsLayer);
			/*var mask:Sprite = new Sprite();
			mask.graphics.beginFill(0x000000, 0);
			mask.graphics.drawRect(0, 0, 600, 430);
			mask.x = 40;
			addChild(mask);
			vecsLayer.mask = mask;*/
			buttonsLayer = new Sprite;
			buttonsLayer.name = "buttonsLayer";
			addChild(buttonsLayer);
			fieldLayer = new Sprite();
			fieldLayer.name = "fieldLayer";
			addChild(fieldLayer);
		}
		
		/**
		 * Cria e adiciona o gráfico.
		 */
		private function createGraph():void 
		{
			var xmin:Number = -5;
			var xmax:Number = 5;
			var ymin:Number = -5;
			var ymax:Number = 5;
			var xWidth:Number = 600;
			var yHeight:Number = 430;
			
			//cartesianAxis = new Coord(xmin, xmax, xWidth, ymin, ymax, yHeight);
			cartesianAxis = new Coord(xmin, xmax, xWidth, ymin, ymax, yHeight);
			graphLayer.addChild(cartesianAxis);
			cartesianAxis.x = 40;
			cartesianAxis.addEventListener(Event.CHANGE, updateObjects);
			cartesianAxis.addEventListener(SelectionEvent.SELECT, selectObjects);
			cartesianAxis.changeState(CoordState.SELECT);
		}
		
		private function selectObjects(e:SelectionEvent):void 
		{
			removeSelection_All();
			
			for each (var obj:ObjMoveable in objectsMoveable) 
			{
				if (e.globalRect.containsPoint(obj.localToGlobal(new Point(0, 0)))) {
					obj.selected = true;
				}
			}
		}
		
		private function updateObjects(e:Event):void 
		{
			for each(var obj:IMoveable in objectsMoveable) {
				obj.update();
			}
			
			for each(var marker:Marker in answerMarkers) {
				marker.update();
			}
			
			for each(var vec:Vec in answerVecs) {
				vec.update();
			}
			
			//for each(var vecAnswer:Vec in backgourndVecs) {
				//vecAnswer.update();
			//}
			
			createBackgroundVectors();
			
			redrawPath();
		}
		
		
		/**
		 * Cria e adiciona os botões para interação com o usuário.
		 */
		private function createButtons():void 
		{
			vecButton = new VecButton();
			buttonsLayer.addChild(vecButton);
			vecButton.x = 615;
			vecButton.y = 455;			
			vecButton.addEventListener(MouseEvent.MOUSE_DOWN, grabObj);
			
			rodaButton = new RodaButton();
			buttonsLayer.addChild(rodaButton);
			rodaButton.x = 575;
			rodaButton.y = 455;
			rodaButton.addEventListener(MouseEvent.MOUSE_DOWN, grabObj);
			
			pontoProvaButton = new PontoProvaButton();
			buttonsLayer.addChild(pontoProvaButton);
			pontoProvaButton.x = 535;
			pontoProvaButton.y = 455;
			pontoProvaButton.addEventListener(MouseEvent.MOUSE_DOWN, grabObj);
			
			particulaButton = new ParticulaButton();
			buttonsLayer.addChild(particulaButton);
			particulaButton.x = 495;
			particulaButton.y = 455;
			particulaButton.addEventListener(MouseEvent.MOUSE_DOWN, grabObj);
			
			markButton = new MarkButton();
			buttonsLayer.addChild(markButton);
			markButton.x = 455;
			markButton.y = 455;
			markButton.addEventListener(MouseEvent.MOUSE_DOWN, addMark);
			
			delButton = new GarbageButton();
			buttonsLayer.addChild(delButton);
			delButton.x = 415;
			delButton.y = 455;
			delButton.addEventListener(MouseEvent.CLICK, onDelButton_Click);
		}
		
		private function setAllButtonsInteractive(value:Boolean):void
		{
			vecButton.removeEventListener(MouseEvent.MOUSE_DOWN, grabObj);
			rodaButton.removeEventListener(MouseEvent.MOUSE_DOWN, grabObj);
			pontoProvaButton.removeEventListener(MouseEvent.MOUSE_DOWN, grabObj);
			particulaButton.removeEventListener(MouseEvent.MOUSE_DOWN, grabObj);
			markButton.removeEventListener(MouseEvent.MOUSE_DOWN, addMark);
			delButton.removeEventListener(MouseEvent.CLICK, onDelButton_Click);
			
			if(value){
				vecButton.addEventListener(MouseEvent.MOUSE_DOWN, grabObj);
				rodaButton.addEventListener(MouseEvent.MOUSE_DOWN, grabObj);
				pontoProvaButton.addEventListener(MouseEvent.MOUSE_DOWN, grabObj);
				particulaButton.addEventListener(MouseEvent.MOUSE_DOWN, grabObj);
				markButton.addEventListener(MouseEvent.MOUSE_DOWN, addMark);
				delButton.addEventListener(MouseEvent.CLICK, onDelButton_Click);
				
				vecButton.alpha = 1;
				rodaButton.alpha = 1;
				pontoProvaButton.alpha = 1;
				particulaButton.alpha = 1;
				markButton.alpha = 1;
				delButton.alpha = 1;
				
				vecButton.mouseEnabled = true;
				rodaButton.mouseEnabled = true;
				pontoProvaButton.mouseEnabled = true;
				particulaButton.mouseEnabled = true;
				markButton.mouseEnabled = true;
				delButton.mouseEnabled = true;
			}else {
				vecButton.alpha = 0.5;
				rodaButton.alpha = 0.5;
				pontoProvaButton.alpha = 0.5;
				particulaButton.alpha = 0.5;
				markButton.alpha = 0.5;
				delButton.alpha = 0.5;
				
				vecButton.mouseEnabled = false;
				rodaButton.mouseEnabled = false;
				pontoProvaButton.mouseEnabled = false;
				particulaButton.mouseEnabled = false;
				markButton.mouseEnabled = false;
				delButton.mouseEnabled = false;
			}
		}
		
		private function onDelButton_Click(e:MouseEvent):void {
			deleteObjects();
		}
		
		
		private var objGhost:DisplayObject;
		private var mouseDownPosition:Point;
		
		private function grabObj(e:MouseEvent):void 
		{
			if (e.target is VecButton) {
				if (getUserCount("VEC") < maxVecs || maxVecs == -1){
					objGhost = new VecGhost();
					stage.addEventListener(MouseEvent.MOUSE_UP, stopMovingGhostVec);
				}else {
					return;
				}
			}
			if (e.target is RodaButton) {
				if (roda != null) {
					if (objectsMoveable.indexOf(roda) != -1) return;
				}
				
				objGhost = new RodaGhost();
				stage.addEventListener(MouseEvent.MOUSE_UP, stopMovingGhostRoda);
			}
			if (e.target is PontoProvaButton) {
				if (pontoProva != null) {
					if (objectsMoveable.indexOf(pontoProva) != -1) return;
				}
				objGhost = new PontoProvaGhost();
				stage.addEventListener(MouseEvent.MOUSE_UP, stopMovingGhostPontoProva);
			}
			if (e.target is ParticulaButton) {
				objGhost = new ParticulaGhost();
				stage.addEventListener(MouseEvent.MOUSE_UP, stopMovingGhostParticula);
			}
			
			buttonsLayer.addChild(objGhost);
			objGhost.x = mouseX;
			objGhost.y = mouseY;
			mouseDownPosition = new Point(mouseX, mouseY);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, movingGhost);
		}
		
		private function movingGhost(e:MouseEvent):void 
		{
			objGhost.x = mouseX;
			objGhost.y = mouseY;
		}
		
		private var maxVecs:int = -1;
		private function stopMovingGhostVec(e:MouseEvent):void 
		{
			if(cartesianAxis.hitTestPoint(mouseX, mouseY, true)){
				var vec:Vec = new Vec(campoAtual, cartesianAxis);
				addToLayer(vecsLayer, vec);
				vec.mover.setPositionByPixels(new Point(objGhost.x, objGhost.y));
				vec.dX = 1;
				vec.dY = 1;
				//vec.followMouse();
				//vec.lock();
				
				stopMoving();
			}else if(!vecButton.hitTestPoint(mouseX, mouseY)){
				stopMoving();
			}
		}
		
		private function stopMovingGhostRoda(e:MouseEvent):void 
		{
			if(cartesianAxis.hitTestPoint(mouseX, mouseY, true)){
				roda = new Roda(campoAtual, cartesianAxis);
				addToLayer(rodaLayer, roda);
				roda.mover.setPositionByPixels(new Point(objGhost.x, objGhost.y));
				stopMoving();
			}else if(!rodaButton.hitTestPoint(mouseX, mouseY)){
				stopMoving();
			}
		}
		
		private function stopMovingGhostPontoProva(e:MouseEvent):void 
		{
			if(cartesianAxis.hitTestPoint(mouseX, mouseY, true)){
				pontoProva = new PontoProva(campoAtual, cartesianAxis);
				addToLayer(pontoProvaLayer, pontoProva);
				pontoProva.mover.setPositionByPixels(new Point(objGhost.x, objGhost.y));
				pontoProva.rotate();
				stopMoving();
			}else if(!pontoProvaButton.hitTestPoint(mouseX, mouseY)){
				stopMoving();
			}
		}
		
		private function stopMovingGhostParticula(e:MouseEvent):void 
		{
			if(cartesianAxis.hitTestPoint(mouseX, mouseY, true)){
				var particula:Particula = new Particula(cartesianAxis, campoAtual);
				addToLayer(particulaLayer, particula);
				particula.mover.setPositionByPixels(new Point(objGhost.x, objGhost.y));
				particula.startMoving();
				stopMoving();
			}else if(!particulaButton.hitTestPoint(mouseX, mouseY)){
				stopMoving();
			}
		}
		
		private function stopMoving():void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, movingGhost);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopMovingGhostVec);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopMovingGhostRoda);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopMovingGhostPontoProva);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopMovingGhostParticula);
			
			buttonsLayer.removeChild(objGhost);
			objGhost = null;
			mouseDownPosition = null;
		}
		
		/**
		 * Adiciona o objeto passado à camada (layer) e registra o objeto no Vetor de objetos.
		 * @param	layer Camada onde será adicionado o objeto.
		 * @param	obj Objeto que será adicionado à camada.
		 */
		public function addToLayer(layer:Sprite, obj:ObjMoveable):void
		{				
			layer.addChild(obj);
			register(obj);
		}
		
		public function removeObject(obj:ObjMoveable):void {
			objectsMoveable.splice(objectsMoveable.indexOf(obj), 1);
			obj.parent.removeChild(obj);
			if (obj is Marker) redrawPath();
			//obj = null;
		}
		
		
		
		/**
		 * Registra o objeto no Vetor de objetos para futuras atualizações.
		 * @param	obj Objeto que será registrado no Vetor.
		 */
		private function register(obj:ObjMoveable):void
		{			
			obj.addEventListener(MouseEvent.CLICK, onObjClicked)
			objectsMoveable.push(obj);
		}
		private function removeSelection_All():void {
			for each (var obj:ObjMoveable in objectsMoveable) 
			{
				obj.selected  = false;
			}
		}
		
		private function onObjClicked(e:MouseEvent):void {
			removeSelection_All();
			ObjMoveable(e.currentTarget).selected = true
			//e.stopImmediatePropagation();
		}
		
		//---------------------------------------------------------------------------------------------
		//Funções do external interface.
		
		public function addVec(posX:Number, posY:Number, dX:Number, dY:Number, lock:Boolean = false, autoCalcDelt:Boolean = false ):void
		{
			var vec:Vec = new Vec(campoAtual, cartesianAxis);
			addToLayer(vecsLayer, vec);
			vec.mover.position = new Point(posX, posY);
			vec.dX = dX;
			vec.dY = dY;
			
			vec.autoCalculateDelta = autoCalcDelt;
			
			if (lock) vec.lock();
			else vec.unlock();
		}
		
		/**
		 * Adiciona ou remove o eventListener do botão indicado, conforme o parâmetyro passado.,
		 * @param	button Nome do botão que será modificada a ação.
		 * @param	value Caso true ativa o botão, caso false desativa.
		 */
		public function setButtonInteractive(button:String, value:Boolean):void
		{
			switch(button.toUpperCase()) {
				case "VEC":
					if (value) {
						vecButton.removeEventListener(MouseEvent.MOUSE_DOWN, grabObj);
						vecButton.addEventListener(MouseEvent.MOUSE_DOWN, grabObj);
						vecButton.alpha = 1;
						vecButton.mouseEnabled = true;
					}else {
						vecButton.removeEventListener(MouseEvent.MOUSE_DOWN, grabObj);
						vecButton.alpha = 0.5;
						vecButton.mouseEnabled = false;
					}
					
					break;
				case "RODA":
					if (value) {
						rodaButton.removeEventListener(MouseEvent.MOUSE_DOWN, grabObj);
						rodaButton.addEventListener(MouseEvent.MOUSE_DOWN, grabObj);
						rodaButton.alpha = 1;
						rodaButton.mouseEnabled = true;
					}else {
						rodaButton.removeEventListener(MouseEvent.MOUSE_DOWN, grabObj);
						rodaButton.alpha = 0.5;
						rodaButton.mouseEnabled = false;
					}
					
					break;
				case "PONTO_PROVA":
					if (value) {
						pontoProvaButton.removeEventListener(MouseEvent.MOUSE_DOWN, grabObj);
						pontoProvaButton.addEventListener(MouseEvent.MOUSE_DOWN, grabObj);
						pontoProvaButton.alpha = 1;
						pontoProvaButton.mouseEnabled = true;
					}else {
						pontoProvaButton.removeEventListener(MouseEvent.MOUSE_DOWN, grabObj);
						pontoProvaButton.alpha = 0.5;
						pontoProvaButton.mouseEnabled = false;
					}
					
					break;
				case "PARTICULA":
					if (value) {
						particulaButton.removeEventListener(MouseEvent.MOUSE_DOWN, grabObj);
						particulaButton.addEventListener(MouseEvent.MOUSE_DOWN, grabObj);
						particulaButton.alpha = 1;
						particulaButton.mouseEnabled = true;
					}else {
						particulaButton.removeEventListener(MouseEvent.MOUSE_DOWN, grabObj);
						particulaButton.alpha = 0.5;
						particulaButton.mouseEnabled = false;
					}
					
					break;
				case "MARKER":
					if (value) {
						markButton.removeEventListener(MouseEvent.MOUSE_DOWN, addMark);
						markButton.addEventListener(MouseEvent.MOUSE_DOWN, addMark);
						markButton.alpha = 1;
						markButton.mouseEnabled = true;
					}else {
						markButton.removeEventListener(MouseEvent.MOUSE_DOWN, addMark);
						markButton.alpha = 0.5;
						markButton.mouseEnabled = false;
					}
					
					break;
				case "DEL":
					if (value) {
						delButton.removeEventListener(MouseEvent.CLICK, onDelButton_Click);
						delButton.addEventListener(MouseEvent.CLICK, onDelButton_Click);
						delButton.alpha = 1;
						delButton.mouseEnabled = true;
					}else {
						delButton.removeEventListener(MouseEvent.CLICK, onDelButton_Click);
						delButton.alpha = 0.5;
						delButton.mouseEnabled = false;
					}
					break;
				
			}
		}
		
		public function showField(value:Boolean):void
		{
			var al:int = 0;
			if (value) al = 1;
			vecBackgroundLayer.alpha = al;
		}
		
		
		public function showFieldName(value:Boolean):void {
			var al:int = 0;
			if (value) al = 1;
			fieldLayer.alpha = al;	
		}
		
		
		//---------------------------------------------------------------------------------------------
		//Exercício 1:
		
		private var ex1Done:Boolean = false;
		private var ex1Score:Number = 0;
		private var nStudentVecs:int = 0;
		
		/**
		 * Calcula a pontuação do primeiro exercício.
		 * Pega cada ObjMoveable no vetor objectsMoveable, verifica se é um Vec, caso seja é adicionado
		 * um novo vec (que não é registrado no vetor objectsMoveable) com as coordenadas corretas e é
		 * feita a verificação da resposta.
		 */
		public function addAnswerEx1():Number
		{
			if (!ex1Done) {
				ex1Score = 0;
				nStudentVecs = 0;
				for each(var vec:ObjMoveable in objectsMoveable) {
					if (vec is Vec) {
						nStudentVecs++;
						var vecAnswer:Vec = new Vec(vec.campo, cartesianAxis);
						Vec(vec).lock();
						vecAnswer.mover.position = vec.mover.position;
						vecAnswer.calculateDelta();
						vecAnswer.lock();
						vecAnswer.changeColor(0xFF0000);
						answerVecLayer.addChild(vecAnswer);
						answerVecs.push(vecAnswer);
						ex1Score += compareVecs(Vec(vec), vecAnswer);
					}
				}
				
				//ex1Score = (ex1Score) / nStudentVecs;
				ex1Score = Math.round((100 / nStudentVecs) * ex1Score);
				trace(ex1Score);
				ex1Done = true;
				return ex1Score;
			}else {
				return NaN;
			}
		}
		
		/**
		 * Calcula a pontuação do aluno sem adicionar as respostas no palco.
		 * @return Pontuação.
		 */
		public function getScoreEx1():Number
		{
				var scoreEx1:Number = 0;
				var studentVecsNumber:int = 0;
				for each(var vec:ObjMoveable in objectsMoveable) {
					if (vec is Vec) {
						studentVecsNumber++;
						var vecAnswer:Vec = new Vec(vec.campo, cartesianAxis);
						vecAnswer.mover.position = vec.mover.position;
						vecAnswer.calculateDelta();
						scoreEx1 += compareVecs(Vec(vec), vecAnswer);
						vecAnswer = null;
					}
				}
				
				scoreEx1 = Math.round((100 / studentVecsNumber) * scoreEx1);
				trace(scoreEx1);
				return scoreEx1;
		}
		
		/**
		 * Função só funciona quando existir apenas 1 vetor no palco.
		 * @return Posição x do vetor.
		 */
		public function getPositionX():Number {
			if (getUserCount("VEC") == 1) {
				for each(var vec:ObjMoveable in objectsMoveable) {
					if (vec is Vec) {
						return vec.mover.position.x;
					}
				}
			}
			return NaN;
		}
		
		/**
		 * Função só funciona quando existir apenas 1 vetor no palco.
		 * @return Posição y do vetor.
		 */
		public function getPositionY():Number {
			if (getUserCount("VEC") == 1) {
				for each(var vec:ObjMoveable in objectsMoveable) {
					if (vec is Vec) {
						return vec.mover.position.y;
					}
				}
			}
			return NaN;
		}
		
		private var rMax:Number = 15;
		private function compareVecs(userVec:Vec, answerVec:Vec):Number
		{
			var score:Number = 0;
			
			var anguloCorreto:Number = Math.atan2(answerVec.dY, answerVec.dX);
			var anguloUsuario:Number = Math.atan2(userVec.dY, userVec.dX);
			
			var comprimentoCorreto:Number = Math.sqrt(Math.pow(answerVec.dX,2) + Math.pow(answerVec.dY,2));
			var comprimentoUsuario:Number = Math.sqrt(Math.pow(userVec.dX, 2) + Math.pow(userVec.dY, 2));
			
			var dR:Number = 0.2 * comprimentoCorreto;
			
			var erroGraus:Number = 30;
			var erroRad:Number = erroGraus * (Math.PI / 180);
			
			var notaAngulo:Number = Math.max(0, 1 - Math.pow(Math.abs(anguloCorreto - anguloUsuario) / erroRad, 2));
			
			if (Math.abs(dR) < 0.0000000001) {
				dR = 0.001;
			}
			var notaComp:Number = Math.max(0, 1 - Math.pow(Math.abs(comprimentoCorreto - comprimentoUsuario) / dR, 2));
			
			score = notaAngulo * notaComp;
			trace(notaAngulo, notaComp, score);
			
			//var distance:Number = Point.distance(new Point(userVec.head.x, userVec.head.y), new Point(answerVec.head.x, answerVec.head.y));
			//score = Math.max(0, 100 - ((100 * distance) / rMax));
			
			//var denominador:Number = Math.pow(answerVec.dX, 2) + Math.pow(answerVec.dY, 2);
			//if (denominador != 0) {
				//score = ((((userVec.dX * answerVec.dX) + (userVec.dY * answerVec.dY)) / denominador) + 1 ) / 2;
			//}else {
				//var difToZero:Number = 0.1;
				//score = (Math.pow(userVec.dX, 2) + Math.pow(userVec.dY, 2)) < difToZero ? 1:0;
			//}
			return score;
		}
		
		private var hasCurves:Boolean = false;
		public function addCurves():void
		{
			if(!hasCurves){
				cartesianAxis.addCurves();
				hasCurves = true;
			}
		}
		
		public function removeCurves():void
		{
			if(hasCurves){
				cartesianAxis.removeCurves();
				hasCurves = false;
			}
		}
		
		private var mouseVec:Vec;
		public function setMouseVec(value:Boolean):void
		{
			if (value) {
				if(mouseVec == null){
					mouseVec = new Vec(campoAtual, cartesianAxis);
					mouseVec.mover.position = new Point(1, 1);
					mouseVec.calculateDelta();
					addToLayer(vecsLayer, mouseVec);
					mouseVec.lock();
					mouseVec.followMouse();
				}
			}else {
				if (mouseVec != null) {
					mouseVec.stopfollowingMouse();
					vecsLayer.removeChild(mouseVec);
					objectsMoveable.splice(objectsMoveable.indexOf(mouseVec), 1);
					mouseVec = null;
				}
			}
		}
		
		public function getUserCount(classe:String):int
		{
			switch(classe.toUpperCase()) {
				case "VEC":
					var nVecs:int = 0;
					for each (var obj:ObjMoveable in objectsMoveable) {
						if (obj is Vec) nVecs++;
					}
					return nVecs;
					break;
				case "MARKER":
					return marks.length;
					break;
			}
			return -1;
		}
		
		public function getMinimunDistanceBetweenVecs():Number 
		{
			var minimumDistance:Number = 0;
			for (var i:int = 0; i < objectsMoveable.length; i++) {
				if (objectsMoveable[i] is Vec && i < objectsMoveable.length - 1) {
					for (var j:int = i + 1; j < objectsMoveable.length; j++) 
					{
						if (objectsMoveable[j] is Vec) {
							var distance:Number = Point.distance(objectsMoveable[i].mover.position, objectsMoveable[j].mover.position);
							if (distance < minimumDistance || minimumDistance == 0) minimumDistance = distance;
						}
					}
				}
			}
			return minimumDistance;
		}
		
		public function changeBounds(xmin:Number, xmax:Number, ymin:Number, ymax:Number):void
		{
			cartesianAxis.changeBounds(xmin, xmax, ymin, ymax);
		}
		
		//---------------------------------------------------------------------------------------------
		//Exercício 2:
		private var ex2Done:Boolean = false;
		private var ex2Score:Number = 0;
		private var nStudentMarkers:int = 0;
		private var answerPathColor:uint = 0x808000;
		
		/**
		 * Calcula a pontuação do segundo exercício.
		 */
		public function addAnswerEx2():Number
		{
			if (!ex2Done) {
				marks[marks.length - 1].showDirection(false);
				var positionMarker:Point;
				
				for (var i:int = 0; i < marks.length; i++) 
				{
					if (i == 0) {
						positionMarker = new Point(marks[i].mover.position.x, marks[i].mover.position.y);
						answerEx2Layer.graphics.lineStyle(1, answerPathColor);
						answerEx2Layer.graphics.moveTo(marks[i].x, marks[i].y);
					}else {
						//var distanceBetweenMarkers:Number = Point.distance(new Point(marks[i].x, marks[i].y), new Point(marks[i - 1].x, marks[i - 1].y));
						var distanceBetweenMarkers:Number = Point.distance(marks[i].mover.position, marks[i - 1].mover.position);
						var step:Number = 0.02;
						
						for (var j:Number = 0; j < distanceBetweenMarkers; j += step) 
						{
							var angle:Number = -Math.atan2(campoAtual.ycomp(positionMarker.x, positionMarker.y), campoAtual.xcomp(positionMarker.x, positionMarker.y));
							
							var xMove:Number = step * Math.cos(angle);
							var yMove:Number = step * Math.sin(angle);
							
							//var positionPixels:Point = marks[i].mover.returnPixelsFromPosition(positionMarker);
							//var newPositionPixel:Point = new Point(positionPixels.x + xMove, positionPixels.y + yMove);
							//positionMarker = marks[i].mover.returnPositionFromPixels(newPositionPixel);
							//
							//answerEx2Layer.graphics.lineTo(newPositionPixel.x, newPositionPixel.y);
							
							positionMarker = new Point(positionMarker.x + xMove, positionMarker.y - yMove);
								
							var positionPixels:Point = marks[i].mover.returnPixelsFromPosition(positionMarker);
							//var newPositionPixel:Point = new Point(positionPixels.x + xMove, positionPixels.y + yMove);
							//positionMarker = marks[j].mover.returnPositionFromPixels(newPositionPixel);
							
							//answerEx2Layer.graphics.lineTo(newPositionPixel.x, newPositionPixel.y);
							answerEx2Layer.graphics.lineTo(positionPixels.x, positionPixels.y);
						}
						
						var marker:Marker = new Marker(cartesianAxis, campoAtual);
						marker.mover.position = new Point(positionMarker.x, positionMarker.y);
						marker.showDirection(false);
						//addToLayer(answerEx2Layer,marker);
						answerEx2Layer.addChild(marker);
						answerMarkers.push(marker);
					}
				}
				
				for (var k:int = 1; k < marks.length; k++) 
				{
					var dist:Number = Point.distance(new Point(marks[k].x, marks[k].y), new Point(answerMarkers[k-1].x, answerMarkers[k-1].y));
					ex2Score += Math.max(0, 1 - Math.pow((dist / rMax), 2));
					
				}
				
				ex2Score = Math.round(100 * (ex2Score / (marks.length - 1)));
				trace(ex2Score);
				ex2Done = true;
				return ex2Score;
			}else {
				return -1;
			}
		}
		
		private function redrawPath():void
		{
			if(marks.length > 1){
				pathLayer.graphics.clear();
				pathLayer.graphics.lineStyle(2, pathColor);
				pathLayer.graphics.moveTo(marks[0].x, marks[0].y);
				for (var i:int = 1; i < marks.length; i++) 
				{
					pathLayer.graphics.lineTo(marks[i].x, marks[i].y);
				}
				
				if (ex2Done) {
					answerEx2Layer.graphics.clear();
					var positionMarker:Point;
					
					for (var j:int = 0; j < marks.length; j++) 
					{
						//answerEx2Layer.graphics.lineTo(answerMarkers[j].x, answerMarkers[j].y);
						if (j == 0) {
							positionMarker = new Point(marks[j].mover.position.x, marks[j].mover.position.y);
							answerEx2Layer.graphics.lineStyle(1, answerPathColor);
							answerEx2Layer.graphics.moveTo(marks[j].x, marks[j].y);
						}else {
							//var distanceBetweenMarkers:Number = Point.distance(new Point(marks[j].x, marks[j].y), new Point(marks[j - 1].x, marks[j - 1].y));
							var distanceBetweenMarkers:Number = Point.distance(marks[j].mover.position, marks[j - 1].mover.position);
							var step:Number = 0.02;
						
							for (var k:Number = 0; k <= distanceBetweenMarkers; k += step) 
							{
								var angle:Number = -Math.atan2(campoAtual.ycomp(positionMarker.x, positionMarker.y), campoAtual.xcomp(positionMarker.x, positionMarker.y));
							
								var xMove:Number = step * Math.cos(angle);
								var yMove:Number = step * Math.sin(angle);
								
								positionMarker = new Point(positionMarker.x + xMove, positionMarker.y - yMove);
								
								var positionPixels:Point = marks[j].mover.returnPixelsFromPosition(positionMarker);
								//var newPositionPixel:Point = new Point(positionPixels.x + xMove, positionPixels.y + yMove);
								//positionMarker = marks[j].mover.returnPositionFromPixels(newPositionPixel);
								
								//answerEx2Layer.graphics.lineTo(newPositionPixel.x, newPositionPixel.y);
								answerEx2Layer.graphics.lineTo(positionPixels.x, positionPixels.y);
							}
						}
					}
				}
			} else {
				pathLayer.graphics.clear();
			}
		}
		
		public function getMinimunDistanceBetweenMarkers():Number 
		{
			if(getUserCount("MARKER") > 1){
				var minimumDistance:Number = 0;
				for (var i:int = 0; i < marks.length; i++) {
					for (var j:int = i + 1; j < marks.length; j++) 
					{
						var distance:Number = Point.distance(new Point(marks[i].x, marks[i].y), new Point(marks[j].x, marks[j].y));
						if (distance < minimumDistance || minimumDistance == 0) minimumDistance = distance;
					}
				}
				return minimumDistance;
			}else {
				return NaN;
			}
		}
		
		//---------------------------------------------------------------------------------------------
		//Exercício 3:
		
		//---------------------------------------------------------------------------------------------
		
		public function doNothing():void
		{
			
		}
		
		//public function get maxVecs():int 
		//{
			//return _maxVecs;
		//}
		
		public function setMaxVecs(value:int):void 
		{
			maxVecs = value;
		}
		
		//public function get maxMarkers():int 
		//{
			//return _maxMarkers;
		//}
		
		public function setMaxMarkers(value:int):void 
		{
			maxMarkers = value;
		}
	}
	
}