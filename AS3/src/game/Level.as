package game 
{
	import game.HUD.LevelHUD;
	import game.HUD.TowerHUD;
	import game.towers.BasicTower;
	import game.towers.MissileTower;
	import game.towers.Tower;
	import graphics.Background;
	import org.flixel.FlxButton;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPath;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxU;
	import org.flixel.plugin.FlxGroupXY;
	import particles.Explosion;
	import states.MenuState;
	
	/**
	 * ...
	 * @author Tontonpiero
	 */
	public class Level extends FlxGroupXY 
	{
		[Embed(source="../../bin/data/json/levels.json", mimeType="application/octet-stream")]
		private static var officials_json:Class;
		
		private var wayPoints:Array;
		public static var instance:Level;
		public var ground:Ground;
		public var path:FlxPath;
		public var towers:FlxGroupXY;
		public var bullets:FlxGroupXY;
		public var HUD:LevelHUD;
		public var spawner:Spawner;
		
		public var width:int = 15;
		public var height:int = 15;
		
		public function Level() 
		{
			instance = this;
			super(0);
			init();
		}
		
		private function init():void {
			ground = new Ground(this);
			add(ground);
			spawner = new Spawner(this);
			add(spawner);
			towers = new FlxGroupXY();
			add(towers);
			bullets = new FlxGroupXY();
			add(bullets);
			HUD = new LevelHUD();
			add(HUD);
		}
		
		public function loadOfficial(id:int):void {
			var officials:String = new officials_json();
			var officialList:* = JSON.parse(officials);
			if ( officialList[id - 1] ) load(officialList[id - 1]);
			else randomize();
		}
		
		public function load(data:*):void {
			ground.load(data.ground);
			wayPoints = [];
			for (var i:int = 0; i < data.wp.length; i+= 2) wayPoints.push( { x:data.wp[i], y:data.wp[i + 1] } );
			buildPath(wayPoints);
			
			spawner.load(data.waves);
		}
		
		public function randomize():void {
			ground.randomize();
			
			var x1:int = 6 - Math.random() * 4;
			var x2:int = 8 + Math.random() * 4;
			
			var y1:int = 2 + Math.random() * 3;
			var y2:int = 6 + Math.random() * 4;
			var y3:int = 11 + Math.random() * 3;
			wayPoints = [];
			wayPoints.push( { x:0, 		y:y1 } );
			wayPoints.push( { x:x2, 		y:y1 } );
			wayPoints.push( { x:x2, 		y:y3 } );
			wayPoints.push( { x:x1, 		y:y3 } );
			wayPoints.push( { x:x1, 		y:y2 } );
			wayPoints.push( { x:width - 1, y:y2 } );
			buildPath(wayPoints);
			
			var waves:Array = [];
			//waves.push( { type:1, nb:1 } );
			//waves.push( { type:1, nb:1 } );
			waves.push( { type:1, nb:3 } );
			waves.push( { type:1, nb:7 } );
			waves.push( { type:1, nb:5 } );
			waves.push( { type:1, nb:8 } );
			waves.push( { type:1, nb:10 } );
			waves.push( { type:1, nb:10 } );
			waves.push( { type:1, nb:10 } );
			waves.push( { type:1, nb:10 } );
			waves.push( { type:1, nb:10 } );
			waves.push( { type:1, nb:10 } );
			waves.push( { type:1, nb:10 } );
			spawner.init(waves);
			
			
			trace(JSON.stringify(export()));
		}
		
		private function buildPath(wps:Array):void 
		{
			path = new FlxPath();
			var roads:Array = new Array();
			var len:int = wps.length;
			var offset:FlxPoint = new FlxPoint(x, y);
			for (var i:int = 0; i < len - 1; i++) 
			{
				var startPoint:FlxPoint = new FlxPoint(wps[i].x * Tile.SIZE + Tile.SIZE / 2, wps[i].y * Tile.SIZE + Tile.SIZE / 2).add(offset);
				var endPoint:FlxPoint = new FlxPoint(wps[i + 1].x * Tile.SIZE + Tile.SIZE / 2, wps[i + 1].y * Tile.SIZE + Tile.SIZE / 2).add(offset);
				if ( i == 0 ) path.addPoint(startPoint.add(new FlxPoint(Tile.SIZE / -2)));
				else path.addPoint(startPoint);
				if ( i == len - 2 ) path.addPoint(endPoint.add(new FlxPoint(Tile.SIZE / 2)));
				
				var miny:int = Math.min(wps[i].y, wps[i + 1].y);
				var maxy:int = Math.max(wps[i].y, wps[i + 1].y);
				if( miny != maxy ) {
					for (var ty:int = miny; ty <= maxy; ty++) 
					{
						roads.push( { x:wps[i].x, y:ty } );
					}
				}
				
				var minx:int = Math.min(wps[i].x, wps[i + 1].x);
				var maxx:int = Math.max(wps[i].x, wps[i + 1].x);
				if( minx != maxx ) {
					for (var tx:int = minx; tx <= maxx; tx++) 
					{
						roads.push( { x:tx, y:wps[i].y } );
					}
				}
			}
			ground.buildRoads(roads);
		}
		
		override public function update():void 
		{
			super.update();
			var tile:Tile = ground.getTileAt(FlxG.mouse.getScreenPosition());
			if ( tile ) {
				if ( HUD.dummyTower.exists ) {
					HUD.dummyTower.x = tile.x;
					HUD.dummyTower.y = tile.y;
					if ( tile.isFree ) HUD.dummyTower.view.color = 0xFFFFFF;
					else HUD.dummyTower.view.color = 0xFF0000;
				}
				if ( FlxG.mouse.justPressed() ) {
					// TODO : do it for mobile too
					if ( HUD.dummyTower.exists && tile.isFree ) {
						addTower(tile);
						tile.isFree = false;
						HUD.dummyTower.exists = false;
					}
				}
			}
		}
		
		private function addTower(tile:Tile):void 
		{
			var tower:BasicTower = new BasicTower();
			towers.add(tower);
			tower.x = tile.x;
			tower.y = tile.y;
			
			HUD.towerHUD.target = tower;
		}
		
		public function export():* {
			var result:* = { };
			result.id = 1;
			result.name = "Level 1";
			result.ground = ground.export();
			result.waves = spawner.export();
			result.wp = [];
			for (var i:int = 0; i < wayPoints.length; i++) 
			{
				result.wp.push(wayPoints[i].x);
				result.wp.push(wayPoints[i].y);
			}
			return result;
		}
	}

}