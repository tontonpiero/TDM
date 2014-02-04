package game.HUD 
{
	import game.Enemy;
	import org.flixel.FlxBasic;
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	import org.flixel.plugin.FlxGroupXY;
	
	/**
	 * ...
	 * @author Tontonpiero
	 */
	public class EnemyHUD extends FlxGroupXY 
	{
		private var _target:Enemy;
		private var _lifeBar:FlxSprite;
		private var _initHealth:Number;
		
		public function EnemyHUD() 
		{
			super(0);
			
			_lifeBar = new FlxSprite( -2, 8);
			_lifeBar.makeGraphic(10, 2, 0xFF00FF00);
			add(_lifeBar);
		}
		
		override public function recycle(ObjectClass:Class = null):FlxBasic 
		{
			FlxG.log("Enemy HUD recycled");
			return super.recycle(ObjectClass);
		}
		
		public function set target(value:Enemy):void {
			this._target = value;
			
			exists = true;
			_lifeBar.scale.x = 1;
			_initHealth = _target.health;
		}
		
		override public function update():void 
		{
			super.update();
			if ( _target && _target.alive ) {
				x = _target.x;
				y = _target.y;
				_lifeBar.scale.x = _target.health / _initHealth;
			}
			else {
				exists = false;
			}
		}
		
	}

}