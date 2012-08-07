package cmds
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Arthur Tofani
	 */
	public class Cmd_Delete implements ICommand
	{
		private var _obj:ObjMoveable;
		private var model:Main;
		private var _parentLayer:Sprite;
			
		public function Cmd_Delete(model:Main,  obj:ObjMoveable) 
		{
			_obj = obj;
			_parentLayer = Sprite(obj.parent);
			this.model = model;
		}
		
		public function exec():void
		{
			_obj.prepareToRemove();
			_obj.selected = false;
			model.removeObject(_obj)
		}
		
		public function undo():void 
		{
			model.addToLayer(_parentLayer, _obj);
			_obj.init()
		}
		

		
		public function name():String 
		{
			return CommandFactory.DELETE
		}
		
		public function description():String 
		{
			return "Remover"
		}

	
		
		
		
	}
	
}