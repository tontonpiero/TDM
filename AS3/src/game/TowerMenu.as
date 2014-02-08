package game 
{
	import game.towers.Tower;
	import org.flixel.FlxButton;
	import org.flixel.plugin.FlxGroupXY;
	import com.tontonpiero.Notifier;
	
	/**
	 * ...
	 * @author Tontonpiero
	 */
	public class TowerMenu extends FlxGroupXY 
	{
		private var btnUp0:FlxButton;
		private var btnUp1:FlxButton;
		private var btnUp2:FlxButton;
		
		private var _tower:Tower;
		
		public function TowerMenu() 
		{
			super(0);
			
			btnUp0 = new FlxButton(0, 0, "up 0", onBtnUp0Clicked);
			add(btnUp0);
			btnUp1 = new FlxButton(0, 40, "up 1", onBtnUp1Clicked);
			add(btnUp1);
			btnUp2 = new FlxButton(0, 80, "up 2", onBtnUp2Clicked);
			add(btnUp2);
			
			tower = null;
			
			Notifier.listen("tower_selected", onTowerSelected);
		}
		
		private function onTowerSelected(t:Tower):void 
		{
			tower = t;
		}
		
		private function onBtnUp0Clicked():void 
		{
			
		}
		
		private function onBtnUp1Clicked():void 
		{
			
		}
		
		private function onBtnUp2Clicked():void 
		{
			
		}
		
		public function get tower():Tower { return _tower;}
		public function set tower(value:Tower):void {
			_tower = value;
			
			if ( !_tower ) {
				exists = false;
			}
			else {
				exists = true;
			}
		}
		
		override public function destroy():void 
		{
			super.destroy();
			
			Notifier.remove(onTowerSelected);
		}
		
	}

}