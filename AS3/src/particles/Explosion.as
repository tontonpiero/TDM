package particles 
{
	import org.flixel.FlxEmitter;
	import org.flixel.FlxParticle;
	
	/**
	 * ...
	 * @author Tontonpiero
	 */
	public class Explosion extends FlxEmitter 
	{
		
		public function Explosion(X:Number=0, Y:Number=0, size:Number = 1) 
		{
			super(X, Y, 20 * size);
			init(size);
		}
		
		public function init(size:Number):void 
		{
			setXSpeed( -100 * size, 100 * size);
			setYSpeed( -100 * size, 100 * size);
			for (var i:int = 0; i < 20 * size; i++) {
				var part:FlxParticle = new FlxParticle();
				part.makeGraphic(1, 1);
				add(part);
			}
			
			start(true, 0.5 * size);
		}
		
		override public function update():void 
		{
			super.update();
			if ( !getFirstAlive() ) {
				clear();
				exists = false;
			}
		}
		
	}

}