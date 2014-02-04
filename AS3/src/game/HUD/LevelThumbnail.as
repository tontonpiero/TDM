package game.HUD 
{
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	import org.flixel.FlxU;
	import org.flixel.plugin.FlxGroupXY;
	import states.LevelState;
	
	/**
	 * ...
	 * @author Tontonpiero
	 */
	public class LevelThumbnail extends FlxGroupXY 
	{
		[Embed(source="../../../bin/data/images/button.png")] protected var ImgBG:Class;
		private var _levelData:*;
		private var _playOnClick:Boolean;
		public var bg:FlxSprite;
		public var levelView:FlxSprite;
		public var txt:FlxText;
		
		public function LevelThumbnail() 
		{
			super();
			bg = new FlxSprite(0, 0, ImgBG);
			//bg.makeGraphic(30, 30, 0xAAFF8040);
			add(bg);
			
			txt = new FlxText(0, 12, 36, null, true);
			txt.color = 0xFF8040;
			txt.alignment = "center";
			txt.shadow = 0xFF000000;
			add(txt);
		}
		
		public function init(levelData:*, playOnClick:Boolean = true):void {
			this._playOnClick = playOnClick;
			this._levelData = levelData;
			
			txt.text = _levelData ? _levelData.id : null;
		}
		
		override public function update():void 
		{
			super.update();
			
			if ( _playOnClick && _levelData && FlxG.mouse.justPressed() && bg.overlapsPoint(FlxG.mouse.getScreenPosition()) ) {
				FlxG.switchState(new LevelState(_levelData));
			}
		}
		
	}

}