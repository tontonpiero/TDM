package game 
{
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author Tontonpiero
	 */
	public class Tile extends FlxSprite 
	{
		[Embed(source="../../bin/data/images/theme_grass.png")]
		private var theme_grass:Class;
		
		public var type:String = null;
		public static const SIZE:Number = 16;
		private var typeFrames:* = { T:[0, 1, 2, 3], S:[4, 5, 6, 7], R:[8, 9, 10, 11], G:[12, 13, 14, 15] };
		public var isFree:Boolean = true;
		
		public function Tile(X:Number=0, Y:Number=0) 
		{
			super(X, Y, null);
			loadGraphic(theme_grass, true, false, Tile.SIZE, Tile.SIZE);
			
			active = false;
		}
		
		public function randomize():void {
			var rand:int = Math.random() * 10;
			
			switch (true) 
			{
				case rand == 1 : 	setType("T"); break;
				case rand == 2 : 	setType("S"); break;
				default: 			setType("G");
			}
		}
		
		public function setType(type:String, index:int = -1, rotation:Number = 0):void {
			this.type = type;
			
			switch (type) 
			{
				case "G": isFree = true; break;
				default: isFree = false;
			}
			
			var frames:Array = typeFrames[type];
			if( index == -1 ) index = (Math.random() * frames.length) | 0;
			frame = frames[index];
			this.angle = rotation;
		}
		
	}

}