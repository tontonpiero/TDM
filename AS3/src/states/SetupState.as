package states
{
	import com.tontonpiero.CallManager;
	import com.tontonpiero.TDM;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.system.Capabilities;
	import org.flixel.FlxCamera;
	import org.flixel.FlxG;
	import org.flixel.FlxState;
	import org.flixel.FlxU;
	
	/**
	 * ...
	 * @author Tontonpiero
	 */
	public class SetupState extends TDMState 
	{
		
		public function SetupState() 
		{
			FlxG.stage.scaleMode = StageScaleMode.NO_SCALE;
			FlxG.stage.align = StageAlign.TOP_LEFT;
		}
		
		override public function create():void 
		{
			CallManager.setup("http://tdm.tontonpiero.fr/api", 2, 10000, FlxG.log, JSON.parse);
			TDM.setup("ANDROID", "xxx", function():void { FlxG.switchState(new MenuState()); } );
		}
		
	}

}