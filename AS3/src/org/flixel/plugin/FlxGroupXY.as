package org.flixel.plugin 
{
	import org.flixel.FlxBasic;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	
	public class FlxGroupXY extends FlxGroup 
	{
		private var _x:int = 0;
		private var _y:int = 0;
		private var _alpha:Number = 1;
			
		// added constructor function
		public function FlxGroupXY(MaxSize:uint=0)
		{
			super(MaxSize);
		}
		
		public function set x(nx:int):void
		{
			var offset:int = nx - _x;
			for each (var object:* in members) {
				if (object.hasOwnProperty("x")) object.x += offset;
			}
			_x = nx;
		}
		
		public function get x():int { return _x; }
		
		public function set y(ny:int):void
		{
			var offset:int = ny - _y;
			for each (var object:* in members) {
				if (object.hasOwnProperty("y")) object.y += offset;
			}
			_y = ny;
		}
		
		public function get y():int { return _y; }
		
		public function get alpha():Number { return _alpha; }
		
		public function set alpha(value:Number):void 
		{
			_alpha = value;
			for each (var object:* in members) {
				if (object.hasOwnProperty("alpha")) object.alpha *= _alpha;
			}
		}
		
		// override add so it works more like DisplayObject,
		// positioning all added objects relative to _x and _y offsets
		override public function add(Object:FlxBasic):FlxBasic{
			super.add(Object);
			if (Object.hasOwnProperty("x")) Object["x"] += _x;
			if (Object.hasOwnProperty("y")) Object["y"] += _y;
			return Object;
		}
	}
	
}