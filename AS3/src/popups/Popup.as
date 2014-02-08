package popups 
{
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	import org.flixel.plugin.FlxGroupXY;
	
	/**
	 * ...
	 * @author Tontonpiero
	 */
	public class Popup extends FlxGroupXY 
	{
		[Embed(source="../../lib/data/images/popup_bg.png")]
		private var bg_default:Class;
		
		private var bg:FlxSprite;
		private var txtTitle:FlxText;
		
		public function Popup() 
		{
			super();
			
			bg = new FlxSprite( -100, -100, bg_default);
			add(bg);
			
			txtTitle = new FlxText( -100, -95, 200, "title");
			add(txtTitle);
			txtTitle.alignment = "center";
			
			show();
		}
		
		public function show():void {
			x = FlxG.width / 2;
			y = FlxG.height / 2;
		}
		
	}

}