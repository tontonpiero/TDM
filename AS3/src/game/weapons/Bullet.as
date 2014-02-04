package game.weapons 
{
	import game.Enemy;
	import game.Level;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxU;
	
	/**
	 * ...
	 * @author Tontonpiero
	 */
	public class Bullet extends FlxSprite 
	{
		public var TTL:Number;
		private var damage:Number;
		
		private var speed:Number;
		private var direction:Number;
		
		public function Bullet() 
		{
			super();
			
			makeGraphic(1, 1, 0xFFFFFFFF);
			
			speed = 3;
		}
		
		public function init(startPoint:FlxPoint, direction:Number, damage:Number):void {
			this.direction = direction * Math.PI / 180;;
			x = startPoint.x;
			y = startPoint.y
			this.damage = damage;
			this.angle = direction;
			exists = true;
			TTL = 0.5;
		}
		
		override public function update():void 
		{
			super.update();
			TTL -= FlxG.elapsed;
			if ( TTL > 0 ) {
				var target:Enemy = Level.instance.spawner.getNearestEnemy(getMidpoint(), 8);
				if ( target ) {
					target.hurt(damage);
					exists = false;
				}
				else {
					x += Math.cos(direction) * speed;
					y += Math.sin(direction) * speed;
				}
			}
			else {
				exists = false;
			}
		}
		
	}

}