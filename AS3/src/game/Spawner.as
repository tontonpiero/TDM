package game 
{
	import game.HUD.EnemyHUD;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxTimer;
	import org.flixel.FlxU;
	
	/**
	 * ...
	 * @author Tontonpiero
	 */
	public class Spawner extends FlxGroup 
	{
		private var level:Level;
		private var waves:Array;
		private var currentWave:*;
		
		public function Spawner(level:Level) 
		{
			super(0);
			this.level = level;
		}
		
		public function init(waves:Array):void {
			this.waves = waves;
			start();
		}
		
		public function start():void {
			new FlxTimer().start(1, 1, function():void { nextWave(0.5); } );
		}
		
		public function nextWave(delay:Number = 5):void {
			if ( waves.length > 0 ) {
				currentWave = waves.shift();
				var nb:int = currentWave.nb;
				var timer:FlxTimer = new FlxTimer();
				
				new FlxTimer().start(delay, 1, function():void { timer.start(0.5, nb, onTimerTick); } );
			}
		}
		
		private function onTimerTick(timer:FlxTimer):void {
			spawn();
			
			if ( timer && timer.finished ) {
				currentWave = null;
				timer.destroy();
				nextWave();
			}
		}
		
		public function spawn():void {
			var e:Enemy = new Enemy();
			add(e);
			Level.instance.HUD.addEnemyHUD(e);
			
			e.x = level.path.nodes[0].x;
			e.y = level.path.nodes[0].y;
			e.followPath(level.path, 30 + Math.random() * 20, 0, true);
		}
		
		public function getEnemies(point:FlxPoint, range:Number = 0):Array 
		{
			var enemies:Array = [];
			for each (var enemy:Enemy in this.members) 
			{
				if( enemy && enemy.alive ) {
					var dist:Number = FlxU.getDistance(point, enemy.getScreenXY());
					if( dist <= range ) {
						enemies.push( { enemy:enemy, dist:dist } );
					}
				}
			}
			return enemies;
		}
		
		override public function update():void 
		{
			super.update();
			var enemy:Enemy = getFirstDead() as Enemy;
			while (enemy != null) {
				remove(enemy, true);
				enemy = getFirstDead() as Enemy;
			}
			members.sortOn("pathTotalDistance", Array.NUMERIC | Array.DESCENDING);
		}
		
		public function export():* 
		{
			var result:Array = [];
			for (var i:int = 0; i < waves.length; i++) 
			{
				result.push(waves[i].type + ":" + waves[i].nb);
			}
			return result.join("|");
		}
		
		public function load(data:String):void
		{
			var result:Array = [];
			var list:Array = data.split("|");
			var info:Array;
			for (var i:int = 0; i < list.length; i++) 
			{
				info = list[i].split(":");
				result.push( { type:info[0], nb:info[1] } );
			}
			init(result);
		}
		
		public function getNearestEnemy(point:FlxPoint, maxRange:Number):Enemy 
		{
			var enemyList:Array = getEnemies(point, maxRange);
			if ( !enemyList || enemyList.length == 0 ) return null;
			enemyList.sortOn("dist", Array.NUMERIC);
			return enemyList[0].enemy;
		}
		
	}

}