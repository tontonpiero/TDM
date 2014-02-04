package states 
{
	import com.greensock.TweenMax;
	import flash.display.BlendMode;
	import game.HUD.LevelThumbnail;
	import graphics.Background;
	import org.flixel.FlxButton;
	import org.flixel.FlxG;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	/**
	 * ...
	 * @author Tontonpiero
	 */
	public class PlayState extends TDMState
	{
		public function PlayState() 
		{
		}
		
		override public function create():void 
		{
			add(new Background());
			add(new Background("clouds", true, BlendMode.OVERLAY));
			
			addBackButton(MenuState);
			
			for (var i:int = 0; i < 20; i++) 
			{
				var posX:Number = (i % 4) * 50;
				var posY:Number = ((i / 4) | 0) * 50;
				var thumb:LevelThumbnail = new LevelThumbnail();
				thumb.init( { id:(i + 1) }, true );
				thumb.x = FlxG.width / 2 + posX - 90;
				thumb.y = 50 + posY;
				add(thumb);
				
			}
		}
		
	}

}