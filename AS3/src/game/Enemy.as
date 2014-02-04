package game 
{
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxU;
	import particles.Explosion;
	
	/**
	 * ...
	 * @author Tontonpiero
	 */
	public class Enemy extends FlxSprite 
	{
		
		public function Enemy() 
		{
			super();
			makeGraphic(6, 6, 0xFFFF8040);
			
			health = 100;
		}
		
		override public function update():void 
		{
			if ( pathSpeed == 0 ) {
				kill();
			}
		}
		
		override public function kill():void 
		{
			super.kill();
			if( health <= 0 ) Level.instance.HUD.addExplosion(getMidpoint().x, getMidpoint().y, 1);
		}
		
		override public function hurt(Damage:Number):void 
		{
			super.hurt(Damage);
			Level.instance.HUD.addExplosion(getMidpoint().x, getMidpoint().y, 0.3);
		}
	}

}