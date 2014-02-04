package 
{
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import org.flixel.FlxG;
	import org.flixel.FlxGame;
	import states.SetupState;
	
	/**
	 * ...
	 * @author Tontonpiero
	 */
	public class Main extends FlxGame 
	{
		public function Main():void 
		{
			super(240, 400, SetupState, 2, 60, 30, true);
			forceDebugger = true;
		}
		
	}
	
}