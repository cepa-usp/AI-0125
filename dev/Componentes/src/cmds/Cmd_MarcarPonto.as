package cmds 
{
	
	/**
	 * ...
	 * @author Arthur Tofani
	 */
	internal class Cmd_MarcarPonto implements ICommand
	{
		private var _obj:ObjMoveable;
		public function Cmd_MarcarPonto() 
		{
			
		}
		
		/* INTERFACE cmds.ICommand */
		
		public function exec():void 
		{
			
		}
		
		public function undo():void 
		{
			
		}
		
		public function name():String 
		{
			return CommandFactory.MARCAR_PONTO;
		}
		
		public function description():String 
		{
			return "Marcar ponto"
		}
		
		public function get obj():ObjMoveable 
		{
			return _obj;
		}
		
		public function set obj(value:ObjMoveable):void 
		{
			_obj = value;
		}
		
	}
	
}