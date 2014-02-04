package states 
{
	import com.greensock.TweenMax;
	import com.tontonpiero.CallManager;
	import flash.display.BlendMode;
	import graphics.Background;
	import org.flixel.FlxButton;
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	
	/**
	 * ...
	 * @author Tontonpiero
	 */
	public class MenuState extends TDMState 
	{
		public var btnPlay:FlxButton;
		public var btnCommunity:FlxButton;
		public var btnSettings:FlxButton;
		
		public function MenuState() 
		{
		}
		
		override public function create():void 
		{
			add(new Background());
			add(new Background("clouds", true, BlendMode.OVERLAY));
			
			btnPlay = new FlxButton(0, FlxG.height *.3, "Play");
			btnPlay.onDown = onBtnPlayClicked;
			btnPlay.scale.x = 1.5;
			btnPlay.scale.y = 1.5;
			add(btnPlay);
			
			var txtOfficials:FlxText = new FlxText(0, btnPlay.y  + btnPlay.height + 10, FlxG.width, "Play officials levels", true);
			txtOfficials.alignment = "center";
			txtOfficials.color = 0xFF8040;
			txtOfficials.shadow = 0xFF000000;
			add(txtOfficials);
			
			btnCommunity = new FlxButton(0, FlxG.height * .5, "Community");
			btnCommunity.onDown = onBtnCommunityClicked;
			btnCommunity.scale.x = 1.5;
			btnCommunity.scale.y = 1.5;
			add(btnCommunity);
			
			var txtCommunity:FlxText = new FlxText(0, btnCommunity.y  + btnCommunity.height + 10, FlxG.width, "Play community levels", true);
			txtCommunity.alignment = "center";
			txtCommunity.color = 0xFF8040;
			txtCommunity.shadow = 0xFF000000;
			add(txtCommunity);
			
			btnSettings = new FlxButton(0, FlxG.height *.7, "Settings");
			btnSettings.onDown = onBtnSettingsClicked;
			btnSettings.scale.x = 1.5;
			btnSettings.scale.y = 1.5;
			add(btnSettings);
			
			TweenMax.to(btnPlay, 0.3, { x:FlxG.width / 2 - btnPlay.width / 2, delay:0 } );
			TweenMax.to(btnCommunity, 0.3, { x:FlxG.width / 2 - btnCommunity.width / 2, delay:0.05 } );
			TweenMax.to(btnSettings, 0.3, { x:FlxG.width / 2 - btnSettings.width / 2, delay:0.1 } );
			
			//ServiceManager.setup("http://fqprodns01.gerwinsoftware.com");
			//ServiceManager.call("getConfig", { userId:108 }, onCallComplete);
			
			//FlxG.visualDebug = true;
			//FlxG.log("test");
		}
		
		//private function onCallComplete(data:*):void 
		//{
			//trace(JSON.stringify(data));
		//}
		
		private function onBtnPlayClicked():void 
		{
			FlxG.switchState(new PlayState());
		}
		
		private function onBtnCommunityClicked():void 
		{
			FlxG.switchState(new CommunityState());
		}
		
		private function onBtnSettingsClicked():void 
		{
			FlxG.switchState(new SettingsState());
		}
		
	}

}