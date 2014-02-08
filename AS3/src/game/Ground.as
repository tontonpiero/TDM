package game 
{
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.plugin.FlxGroupXY;
	
	/**
	 * ...
	 * @author Tontonpiero
	 */
	public class Ground extends FlxGroupXY 
	{
		[Embed(source="../../lib/data/images/start.png")]
		private var start_png:Class;
		
		private var level:Level;
		public var tiles:*;
		
		public function Ground(level:Level) 
		{
			super(0);
			this.level = level;
			
			var bg:FlxSprite = new FlxSprite();
			add(bg)
			bg.makeGraphic(level.width * Tile.SIZE, level.height * Tile.SIZE, 0x33000000);
			
			this.tiles = { };
			var tile:Tile;
			for (var i:int = 0; i < level.width; i++) 
			{
				for (var j:int = 0; j < level.height; j++) 
				{
					tile = new Tile(Tile.SIZE * i, Tile.SIZE * j);
					tiles[i + "x" + j] = tile;
					add(tile);
				}
			}
		}
		
		public function randomize():void {
			for each (var tile:Tile in tiles) 
			{
				tile.randomize();
			}
		}
		
		public function buildRoads(points:Array):void 
		{
			var len:int = points.length;
			var wp:*;
			points[0].isStart = true;
			points[len - 1].isEnd = true;
			for each (wp in points) 
			{
				tiles[wp.x + "x" + wp.y].setType("R", 0);
			}
			
			for (var i:int = 0; i < len; i++) 
			{
				wp = points[i];
				var rds:* = getRoadsAround(wp.x, wp.y, wp.isStart || wp.isEnd);
				var frame:int = 0;
				var rotation:int = 0;
				switch (true) 
				{
					case rds.h && !rds.v : frame = 0; break;
					case !rds.h && rds.v : frame = 1; break;
					case rds.h && rds.v : frame = 2; break;
					default :
						frame = 3;
						if( rds.top && rds.left ) rotation = 90;
						else if( rds.top && rds.right ) rotation = 180;
						else if( rds.bottom && rds.right ) rotation = 270;
						break;
				}
				
				var tile:Tile = tiles[wp.x + "x" + wp.y];
				tile.setType("R", frame, rotation);
				
				if ( wp.isStart ) {
					var startSprite:FlxSprite = new FlxSprite(wp.x * Tile.SIZE, wp.y * Tile.SIZE, null);
					startSprite.loadGraphic(start_png, true, false, Tile.SIZE, Tile.SIZE);
					startSprite.addAnimation("start", [0, 1, 2, 3], 3, true);
					startSprite.alpha = 0.5;
					add(startSprite);
					startSprite.play("start");
					//tiles[wp.x + "x" + wp.y]
				}
			}
		}
		
		public function getTileAt(point:FlxPoint):Tile 
		{
			for each (var tile:Tile in tiles) 
			{
				if ( tile.overlapsPoint(point) ) return tile;
			}
			return null;
		}
		
		private function getRoadsAround(x:int, y:int, includeBorders:Boolean = false):* {
			var res:* = { };
			res.left = x > 0 ? tiles[(x - 1) + "x" + y].type == "R" : includeBorders;
			res.right = x < level.width - 1 ? tiles[(x + 1) + "x" + y].type == "R" : includeBorders;
			res.top = y > 0 ? tiles[x + "x" + (y - 1)].type == "R" : includeBorders;
			res.bottom = y < level.height - 1 ? tiles[x + "x" + (y + 1)].type == "R" : includeBorders;
			res.h = res.left && res.right;
			res.v = res.top && res.bottom;
			return res;
		}
		
		public function export():* 
		{
			var result:String = "";
			for (var i:int = 0; i < level.width; i++) 
			{
				for (var j:int = 0; j < level.height; j++) 
				{
					result += tiles[i + "x" + j].type;
				}
			}
			return result;
		}
		
		public function load(data:String):void 
		{
			var type:String;
			for (var i:int = 0; i < level.width; i++) 
			{
				for (var j:int = 0; j < level.height; j++) 
				{
					type = data.charAt(j + i * level.width)
					if ( type == "R" ) type = "G";
					tiles[i + "x" + j].setType(type);
				}
			}
		}
		
	}

}