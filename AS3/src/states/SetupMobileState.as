package states
{
	import flash.display.StageDisplayState;
	import flash.system.Capabilities;
	import org.flixel.FlxCamera;
	import org.flixel.FlxG;
	import org.flixel.FlxState;
	
	/**
	 * ...
	 * @author Tontonpiero
	 */
	public class SetupMobileState extends TDMState 
	{
		
		public function SetupMobileState() 
		{
			FlxG.stage.displayState = StageDisplayState.FULL_SCREEN;
			FlxG.stage.stageHeight = Capabilities.screenResolutionY;
			FlxG.stage.stageWidth = Capabilities.screenResolutionX;
			FlxG.width = FlxG.stage.stageWidth / FlxCamera.defaultZoom;
			FlxG.height = FlxG.stage.stageHeight / FlxCamera.defaultZoom;
		}
		
	}

}