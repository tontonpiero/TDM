package game.weapons 
{
	import game.Enemy;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxU;
	
	/**
	 * ...
	 * @author Tontonpiero
	 */
	public class Missile extends FlxSprite 
	{
		private var target:Enemy;
		private var damage:Number;
		
		private var speed:Number;
		
		public function Missile() 
		{
			super();
			
			makeGraphic(6, 2, 0xFFFF0000);
			
			speed = 2;
		}
		
		public function init(startPoint:FlxPoint, target:Enemy, damage:Number):void {
			x = startPoint.x;
			y = startPoint.y
			this.damage = damage;
			this.target = target;
			exists = true;
		}
		
		override public function update():void 
		{
			super.update();
			if ( target && target.alive ) {
				if ( FlxU.getDistance(getMidpoint(), target.getMidpoint()) < 4 ) {
					target.hurt(damage);
					exists = false;
				}
				else {
					angle = FlxU.getAngle(getMidpoint(), target.getMidpoint()) - 90;
					var rotation:Number = angle * Math.PI / 180;
					x += Math.cos(rotation) * speed;
					y += Math.sin(rotation) * speed;
				}
			}
			else {
				exists = false;
			}
		}
		
	}

}