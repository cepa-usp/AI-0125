package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.SharedObjectFlushStatus;
	import graph.Coord;
	import graph.CoordState;
	
	/**
	 * ...
	 * @author Arthur Tofani
	 */
	public class Main extends Sprite 
	{
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		private var objs:Vector.<IMoveable> = new Vector.<IMoveable>();

		private function register(obj:IMoveable):void {
			objs.push(obj)
		}
		private var c:Coord = new Coord(-7, 7, 600, -7, 7, 600)
		
		private var vecs:Array = [];
		private function test():void {
			c.x = 100;
			c.y = 0;
			addChild(c);			
			var cp:Campo1 = new Campo1();
			

			
			var v:Vec = new Vec(cp, c);		
			addChild(v)
			register(v)
			v.mover.position = new Point(2, 3)
			v.dX = 3;
			v.dY = 2;
			v.unlock();
			
			var s:PontoProva = new PontoProva(cp, c);
			addChild(s)			
			s.mover.position = new Point(2, 3)
			s.rotate();
			register(s)
			
			var ss:Roda = new Roda(cp, c);
			addChild(ss)
			register(ss)
			ss.mover.position = new Point( -3, 3)
			
			//c.changeState(CoordState.ZOOM_IN);
			c.addEventListener(Event.CHANGE, updateObjects)
		
			
			//v.dX = 3
		//	v.dY = -2;
			//v.dY = 3;
		}
		
		private function updateObjects(e:Event):void 
		{
			for each(var obj:IMoveable in objs) {
				obj.update();
			}
		}

		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			test();
			//test3();
			
			
			
			
		}
		
	}
	
}