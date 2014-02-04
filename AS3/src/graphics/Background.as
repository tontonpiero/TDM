package graphics 
{
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author Tontonpiero
	 */
	public class Background extends FlxSprite 
	{
		[Embed(source="../../bin/data/images/bg.png")]
		private var bg_default:Class;
		[Embed(source="../../bin/data/images/clouds.png")]
		private var bg_clouds:Class;
		[Embed(source="../../bin/data/images/bg_grass.png")]
		private var bg_grass:Class;
		
		private var scroll:Boolean;
		static private var scrollX:Number = 0;
		
		public function Background(type:String = "default", scroll:Boolean = false, blendMode:String = null, Alpha:Number = 1) 
		{
			this.scroll = scroll;
			var bg:Class = null;
			switch (type) 
			{
				case "grass": bg = bg_grass; break;
				case "clouds": bg = bg_clouds; break;
				default: bg = bg_default;
			}
			super(0, 0, bg);
			
			if ( blendMode ) blend = blendMode;
			this.alpha = Alpha;
		}
		
		override public function update():void 
		{
			super.update();
			
			if( scroll ) {
				scrollX -= FlxG.elapsed * 20;
				if ( scrollX < -480 ) scrollX += 480;
				x = scrollX;
			}
		}
		
	}

}