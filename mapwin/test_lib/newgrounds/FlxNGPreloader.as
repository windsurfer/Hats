package 
{
	import com.newgrounds.API;
	import com.newgrounds.APIEvent;
	import com.newgrounds.components.FlashAd;
	import com.newgrounds.components.MedalPopup;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import org.flixel.FlxPreloader;
	
	/**
	 * ...
	 * @author Newgrounds.com, Inc.
	 */
	public class FlxNGPreloader extends FlxPreloader 
	{
		
		public var NewgroundsAPIMovieId:String;
		public var NewgroundsAPIEncryptionKey:String;
		public var NewgroundsAPIShowAds:Boolean = true;

		private var _adContainer:Sprite;
		private var _overlay:Shape;
		
		public function FlxNGPreloader():void
		{
			super();
		}
		
		protected function createMedalPopup(x:Number, y:Number):void
		{
			var popup:MedalPopup = new MedalPopup();
			popup.x = x;
			popup.y = y;
			addChild(popup);
		}
		
		override protected function create():void
		{
			if (NewgroundsAPIShowAds)
				API.addEventListener(APIEvent.ADS_APPROVED, adsApprovedHandler, false, 0, true);
			
			if(NewgroundsAPIMovieId && NewgroundsAPIEncryptionKey)
				API.connectMovie(loaderInfo, NewgroundsAPIMovieId, NewgroundsAPIEncryptionKey);
			else
				trace("[Newgrounds API] :: Movie ID and encryption key not set! Please set NewgroundsAPIMovieId in preloader.");
				
			_buffer = new Sprite();
			_buffer.scaleX = 2;
			_buffer.scaleY = 2;
			addChild(_buffer);
			_width = stage.stageWidth/_buffer.scaleX;
			_height = stage.stageHeight/_buffer.scaleY;
			_buffer.addChild(new Bitmap(new BitmapData(_width,_height,false,0x00345e)));
			var b:Bitmap = new ImgLogoLight();
			b.smoothing = true;
			b.width = b.height = _height;
			b.x = (_width-b.width)/2;
			_buffer.addChild(b);
			_bmpBar = new Bitmap(new BitmapData(1,7,false,0x5f6aff));
			_bmpBar.x = 4;
			_bmpBar.y = _height-11;
			_buffer.addChild(_bmpBar);
			_text = new TextField();
			_text.defaultTextFormat = new TextFormat("system",8,0x5f6aff);
			_text.embedFonts = true;
			_text.selectable = false;
			_text.multiline = false;
			_text.x = 2;
			_text.y = _bmpBar.y - 11;
			_text.width = 80;
			_buffer.addChild(_text);
			_logo = new ImgLogo();
			_buffer.addChild(_logo);
			_logoGlow = new ImgLogo();
			_logoGlow.smoothing = true;
			_logoGlow.blendMode = "screen";
			_buffer.addChild(_logoGlow);
			
			if (NewgroundsAPIShowAds)
			{
				var adHeight:Number = Math.min(125, _height / 2);
				var vMargin:Number = (_height - adHeight - 3 * _height / 10 - 20) / 3;
				
				_adContainer = new Sprite();
				_adContainer.graphics.beginFill(0);
				_adContainer.graphics.moveTo(-2, -2);
				_adContainer.graphics.lineTo(152, -2);
				_adContainer.graphics.lineTo(152, 127);
				_adContainer.graphics.lineTo(-2, 127);
				_adContainer.graphics.lineTo(-2, -2);
				_adContainer.graphics.endFill();
				_adContainer.height = adHeight;
				_adContainer.scaleX = _adContainer.scaleY;
				_adContainer.x = (_width - _adContainer.width) / 2;
				_adContainer.y = vMargin * 2 + 3 * _height / 10;
				_logo.scaleX = _logo.scaleY = _height / 20;
				_logo.x = (_width-_logo.width)/2;
				_logo.y = vMargin;
				_logoGlow.scaleX = _logoGlow.scaleY = _height / 20;
				_logoGlow.x = (_width -_logoGlow.width) / 2;
				_logoGlow.y = vMargin;
			}
			else
			{
				_logo.scaleX = _logo.scaleY = _height / 8;
				_logo.x = (_width-_logo.width)/2;
				_logo.y = (_height - _logo.height) / 2;
				_logoGlow.scaleX = _logoGlow.scaleY = _height/8;
				_logoGlow.x = (_width-_logoGlow.width)/2;
				_logoGlow.y = (_height - _logoGlow.height) / 2;
			}
			
			b = new ImgLogoCorners();
			b.smoothing = true;
			b.width = _width;
			b.height = _height;
			_buffer.addChild(b);
			b = new Bitmap(new BitmapData(_width,_height,false,0xffffff));
			for(var i:uint = 0; i < _height; i+=2)
				for(var j:uint = 0; j < _width; j++)
					b.bitmapData.setPixel(j,i,0);
			b.blendMode = "overlay";
			b.alpha = 0.25;
			_buffer.addChild(b);
			
			_buffer.addChild(_adContainer);
			
			_overlay = new Shape();
			_buffer.addChild(_overlay);
			_overlay.graphics.beginFill(0);
			_overlay.graphics.lineTo(_width, 0);
			_overlay.graphics.lineTo(_width, _height);
			_overlay.graphics.lineTo(0, _height);
			_overlay.graphics.lineTo(0, 0);
			_overlay.graphics.endFill();
			_overlay.alpha = 0;
		}
		
		override protected function update(Percent:Number):void
		{
			super.update(Percent);
			if (Percent > 0.9)
			{
				_buffer.alpha = 1;
				_overlay.alpha = (Percent-0.9)/0.1;
			}
		}
		
		protected function adsApprovedHandler(event:APIEvent):void
		{
			API.removeEventListener(APIEvent.ADS_APPROVED, adsApprovedHandler);
			
			if (_adContainer)
			{
				var ad:FlashAd = new FlashAd(false);
				_adContainer.addChild(ad);
				ad.scaleX = ad.scaleY = .5;
			}
		}
		
	}
	
}