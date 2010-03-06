package { 

	import com.newgrounds.components.FlxNGPreloader;

	public class Preloader extends FlxNGPreloader
	{
		public function Preloader() 
		{
			className = "Hats";
			NewgroundsAPIId = "11112";
			NewgroundsAPIEncryptionKey = "0175077c82144c46be87ebd64c4c36dd";
			NewgroundsAPIShowAds = true;
			super();
		}
	}
}
