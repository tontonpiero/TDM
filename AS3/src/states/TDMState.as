package states 
{
	import org.flixel.FlxButton;
	import org.flixel.FlxG;
	import org.flixel.FlxState;
	
	/**
	 * ...
	 * @author Tontonpiero
	 */
	public class TDMState extends FlxState 
	{
		private var _btnBack:FlxButton;
		private var _backStateClass:Class;
		
		public function TDMState() 
		{
			
		}
		
		public function addBackButton(backStateClass:Class):void {
			_backStateClass = backStateClass;
			_btnBack = new FlxButton(FlxG.width - 80, 0, "Back");
			_btnBack.onDown = onBtnBackClicked;
			add(_btnBack);
		}
		
		protected function onBtnBackClicked():void 
		{
			FlxG.switchState(new _backStateClass());
		}
		
		override public function update():void 
		{
			super.update();
			if ( _btnBack && FlxG.keys.justPressed("BACK") ) onBtnBackClicked();
		}
		
	}

}