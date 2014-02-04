package states 
{
	import org.flixel.FlxButton;
	import org.flixel.FlxG;
	import org.flixel.FlxState;
	
	/**
	 * ...
	 * @author Tontonpiero
	 */
	public class CommunityState extends TDMState 
	{
		
		public function CommunityState() 
		{
		}
		
		override public function create():void 
		{
			addBackButton(MenuState);
		}
		
	}

}