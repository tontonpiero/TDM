package game.towers 
{
	import game.Enemy;
	import game.Level;
	import game.Tile;
	import game.weapons.Missile;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxU;
	/**
	 * ...
	 * @author Tontonpiero
	 */
	public class BasicTower extends Tower 
	{
		[Embed(source="../../../lib/data/images/missile_tower_gun.png")]
		private var gunClass:Class;
		
		private var gun:FlxSprite;
		
		public function BasicTower() 
		{
			super();
			
			range = 40;
			strength = 4;
			fireRate = 0.1;
			
			view = new FlxSprite();
			view.makeGraphic(Tile.SIZE, Tile.SIZE, 0xFF808080);
			add(view);
			var center:FlxPoint = view.getMidpoint();
			
			gun = new FlxSprite(view.x, view.y, gunClass);
			add(gun);
			gun.drawLine(center.x, center.y, center.x, center.y - 6, 0xFFFFFFFF);
		}
		
		override public function fire():void 
		{
			super.fire();
			//hitFirst(strength);
			var data:* = getFirst();
			if ( data ) {
				Level.instance.HUD.addBullet(view.getMidpoint(), gun.angle - 90, strength);
			}
		}
		
		override public function updateDirection(angle:Number):void 
		{
			gun.angle = angle;
		}
		
	}

}