package game.HUD 
{
	import game.Enemy;
	import game.towers.BasicTower;
	import game.towers.MissileTower;
	import game.towers.Tower;
	import game.weapons.Bullet;
	import game.weapons.Missile;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxU;
	import org.flixel.plugin.FlxGroupXY;
	import particles.Explosion;
	
	/**
	 * ...
	 * @author Tontonpiero
	 */
	public class LevelHUD extends FlxGroupXY 
	{
		private var _enemies:FlxGroupXY;
		private var _explosions:FlxGroupXY;
		private var _bullets:FlxGroupXY;
		public var towerHUD:TowerHUD;
		public var dummyTower:Tower;
		
		public function LevelHUD() 
		{
			super(0);
			_enemies = new FlxGroupXY();
			add(_enemies);
			_bullets = new FlxGroupXY();
			add(_bullets);
			_explosions = new FlxGroupXY();
			add(_explosions);
			
			towerHUD = new TowerHUD();
			add(towerHUD);
			
			dummyTower = new BasicTower();
			add(dummyTower);
			dummyTower.active = false;
			dummyTower.alpha = 0.5;
			dummyTower.exists = false;
		}
		
		public function addEnemyHUD(enemy:Enemy):void {
			var item:EnemyHUD = _enemies.getFirstAvailable() as EnemyHUD;
			if ( !item ) {
				item = new EnemyHUD();
				_enemies.add(item);
			}
			item.target = enemy;
		}
		
		public function addExplosion(X:Number, Y:Number, size:Number = 1):void {
			var item:Explosion = _explosions.getFirstAvailable() as Explosion;
			if ( !item ) {
				item = new Explosion(X, Y, size);
				_explosions.add(item);
			}
			else {
				item.x = X;
				item.y = Y;
				item.maxSize = 20 * size;
				item.init(size);
			}
		}
		
		public function addMissile(startPoint:FlxPoint, target:Enemy, damage:Number):void {
			var item:Missile = _bullets.getFirstAvailable() as Missile;
			if ( !item ) {
				item = new Missile();
				_bullets.add(item);
			}
			item.init(startPoint, target, damage);
		}
		
		public function addBullet(startPoint:FlxPoint, direction:Number, damage:Number):void 
		{
			var item:Bullet = _bullets.getFirstAvailable() as Bullet;
			if ( !item ) {
				item = new Bullet();
				_bullets.add(item);
			}
			item.init(startPoint, direction, damage);
		}
		
	}

}