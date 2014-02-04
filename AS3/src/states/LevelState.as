package states
{
	import flash.display.BlendMode;
	import game.Level;
	import graphics.Background;
	import org.flixel.FlxButton;
	import org.flixel.FlxEmitter;
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxParticle;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import particles.Explosion;
	
	/**
	 * ...
	 * @author Tontonpiero
	 */
	public class LevelState extends TDMState 
	{
		private var levelData:*;
		public var level:Level;
		
		public var addTowerBtn:FlxButton;
		
		public function LevelState(levelData:* = null) 
		{
			this.levelData = levelData;
		}
		
		private function onBtnAddTowerClicked():void 
		{
			level.HUD.dummyTower.exists = true;
		}
		
		override public function create():void 
		{
			add(new Background("grass"));
			
			level = new Level();
			level.x = 0;
			level.y = 0;
			add(level);
			if ( levelData && levelData.id < 1000 ) level.loadOfficial(levelData.id);
			else level.randomize();
			add(new Background("clouds", true, BlendMode.SCREEN, 0.3));
			
			addBackButton(PlayState);
			
			addTowerBtn = new FlxButton(0, 240, "Add tower", onBtnAddTowerClicked);
			add(addTowerBtn);
		}
	}

}