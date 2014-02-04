package game.towers 
{
	import game.Enemy;
	import game.Level;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxTimer;
	import org.flixel.FlxU;
	import org.flixel.plugin.FlxGroupXY;
	
	/**
	 * ...
	 * @author Tontonpiero
	 */
	public class Tower extends FlxGroupXY 
	{
		public var view:FlxSprite;
		
		public var range:Number;
		public var strength:Number;
		public var fireRate:Number;
		public var inRange:Array;
		
		private var nextFire:Number;
		
		public function Tower() 
		{
			super();
			nextFire = 0;
		}
		
		public function fire():void {
			nextFire = fireRate;
		}
		
		override public function update():void 
		{
			updateFireRate();
			updateInRange();
			
			if ( FlxG.mouse.justPressed() ) {
				if ( view.overlapsPoint(FlxG.mouse.getScreenPosition()) ) {
					Level.instance.HUD.towerHUD.target = this;
				}
			}
		}
		
		private function updateFireRate():void {
			if ( nextFire > 0 ) nextFire -= FlxG.elapsed;
		}
		
		private function canFire():Boolean { return nextFire <= 0; };
		
		private function updateInRange():void {
			inRange = Level.instance.spawner.getEnemies(view.getScreenXY(), range);
			if( inRange.length > 0 ) {
				if ( canFire() ) fire();
				updateDirection(FlxU.getAngle(view.getScreenXY(), inRange[0].enemy.getScreenXY()));
			}
		}
		
		public function updateDirection(angle:Number):void { };
		
		public function hitFirst(damage:Number = NaN):void 
		{
			var data:* = getFirst();
			if( data ) data.enemy.hurt(!isNaN(damage) ? damage : strength);
		}
		
		public function getFirst():* 
		{
			return inRange.length > 0 ? inRange[0] : null;
		}
		
		public function hitAll(damage:Number = NaN):void 
		{
			if ( inRange.length > 0 ) {
				for each (var data:* in inRange) 
				{
					data.enemy.hurt(!isNaN(damage) ? damage : strength);
				}
			}
		}
		
	}

}