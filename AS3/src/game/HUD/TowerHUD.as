package game.HUD 
{
	import game.Enemy;
	import game.towers.Tower;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	import org.flixel.plugin.FlxGroupXY;
	import com.tontonpiero.Notifier;
	
	/**
	 * ...
	 * @author Tontonpiero
	 */
	public class TowerHUD extends FlxGroupXY 
	{
		private var _target:Tower;
		private var range:FlxSprite;
		private var txtDebug:FlxText;
		
		public function TowerHUD() 
		{
			super(0);
			
			//txtDebug = new FlxText( -20, 12, 40);
			//txtDebug.alignment = "center";
			//add(txtDebug);
			
			target = null;
		}
		
		public function set target(value:Tower):void {
			this._target = value;
			
			if( _target ) {
				x = _target.view.getMidpoint().x;
				y = _target.view.getMidpoint().y;
				
				if ( range ) remove(range);
				
				range = new FlxSprite(-_target.range, -_target.range);
				range.makeGraphic(_target.range * 2, _target.range * 2, 0x00000000);
				range.clearPixels();
				range.drawCircle(new FlxPoint(_target.range, _target.range), _target.range, 0x66FF0000, 1, 0x11FF0000);
				add(range);
				
				exists = true;
				
				Notifier.notify("tower_selected", _target);
			}
			else {
				exists = false;
				Notifier.notify("tower_selected", null);
			}
		}
		
		override public function update():void 
		{
			super.update();
			if ( _target && _target.alive ) {
				//lifeBar.scale.x = target.health / initHealth;
				//txtDebug.text = Math.floor(target.pathTotalDistance / 100).toString();
			}
			else {
				target = null;
			}
		}
		
	}

}