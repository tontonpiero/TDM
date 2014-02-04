package states 
{
	import org.flixel.FlxButton;
	import org.flixel.FlxG;
	import org.flixel.FlxState;
	
	/**
	 * ...
	 * @author Tontonpiero
	 */
	public class EditorState extends TDMState 
	{
		
		public function EditorState() 
		{
		}
		
		override public function create():void 
		{
			addBackButton(MenuState);
		}
		
	}

}