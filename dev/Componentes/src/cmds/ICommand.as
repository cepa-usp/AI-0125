package cmds
{
	
	/**
	 * ...
	 * @author Arthur Tofani
	 */
	public interface ICommand 
	{
		function exec():void;
		function undo():void;
		function name():String;
		function description():String;
			
	}
	
}