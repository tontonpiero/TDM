package states 
{
	import com.tontonpiero.CallManager;
	import org.flixel.FlxButton;
	import org.flixel.FlxG;
	import org.flixel.FlxState;
	
	/**
	 * ...
	 * @author Tontonpiero
	 */
	public class SettingsState extends TDMState 
	{
		
		public function SettingsState() 
		{
		}
		
		override public function create():void 
		{
			addBackButton(MenuState);
			
			add(new FlxButton(0, 100, "auth", function():void {
				CallManager.httpGet("auth", { id:"xxx" }, onAuthComplete, onAuthError);
			}));
			
			add(new FlxButton(0, 150, "me", function():void {
				CallManager.httpGet("me", null, onMeComplete, onMeError);
			}));
			
			add(new FlxButton(0, 200, "levels", function():void {
				CallManager.httpGet("levels", null, onLevelsComplete, onLevelsError);
			}));
		}
		
		private function onAuthError(error:*):void 
		{
			FlxG.log("Auth error : " + error.msg + " (" + error.code + ")");
		}
		
		private function onAuthComplete(data:*):void 
		{
			FlxG.log("Auth complete : " + data.playerId);
			CallManager.addHeader("authKey", data.authKey);
		}
		
		private function onMeError(error:*):void 
		{
			FlxG.log("Me error : " + error.msg + " (" + error.code + ")");
		}
		
		private function onMeComplete(data:*):void 
		{
			FlxG.log("Me complete : " + JSON.stringify(data));
		}
		
		private function onLevelsError(error:*):void 
		{
			FlxG.log("Levels error : " + error.msg + " (" + error.code + ")");
		}
		
		private function onLevelsComplete(data:*):void 
		{
			FlxG.log("Levels complete : " + JSON.stringify(data));
		}
		
	}

}