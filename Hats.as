package {
	import org.flixel.*;
	import com.globalgamejam.Hats.MenuState;
	
	[SWF(width="640", height="480", backgroundColor="#000000")]
	[Frame(factoryClass = "Preloader")]


	public class Hats extends FlxGame
	{
		
		public function Hats():void
		{
			
			super(320,240,MenuState, 2);
			FlxState.bgColor = 0xff131c1b;
			setLogoFX(0xff729954);
			useDefaultHotKeys = true;
		}
	}
}
