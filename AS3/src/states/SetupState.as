package states
{
	import com.tontonpiero.CallManager;
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
			CallManager.setup("http://tdm.tontonpiero.fr/api");
			CallManager.httpGet("", null, onServiceInitiated, onServiceError);
		}
		
		private function onServiceError(error:*):void 
		{
			FlxG.log("API error : " + error.msg + " (" + error.code + ")");
			FlxG.switchState(new MenuState());
		}
		
		private function onServiceInitiated(data:*):void 
		{
			FlxG.log("API status : " + data.status);
			FlxG.switchState(new MenuState());
		}
		
	}

}