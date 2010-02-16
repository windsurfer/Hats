package {
	import org.flixel.*;
	import com.globalgamejam.Hats.MenuState;
	
	[SWF(width="640", height="480", backgroundColor="#000000")]
	[Frame(factoryClass = "Preloader")]


	public class Hats extends FlxGame
	{
		
		public function Hats():void
		{
			super(320, 240, MenuState, 2.0);
			showLogo = false;
			FlxState.bgColor = 0xff000000;
			useDefaultHotKeys = true;
		}
	}
}
