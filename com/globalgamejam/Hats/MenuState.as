package com.globalgamejam.Hats
{
	import org.flixel.*;

	public class MenuState extends FlxState
	{
		[Embed(source = "../../../data/cursor.png")] private var ImgCursor:Class;
		
		[Embed(source="../../../data/hats_gibs.png")] public static var ImgHats:Class;
		[Embed(source="../../../Sounds/Finals/Shoot/3.mp3")] private var SndHit:Class;
		[Embed(source="../../../Sounds/Finals/Shoot/3.mp3")] private var SndHit2:Class;
		
		private var _e:FlxEmitter;
		private var _b:FlxButton;
		private var _t1:FlxText;
		private var _t2:FlxText;
		private var _ok:Boolean;
		private var _ok2:Boolean;
		
		override public function MenuState():void
		{
			var i:uint;
			var s:FlxSprite;
			_e = new FlxEmitter(FlxG.width/2-50,FlxG.height/2-10,-10);
			_e.setSize(100,30);
			_e.setYVelocity( -2000, -100);
			
			_e.setRotation(-360, 360);
			_e.createSprites(ImgHats,100);
			add(_e);
				
			_t1 = new FlxText(FlxG.width,FlxG.height/3,80,"ha");
			_t1.size = 32;
			_t1.color = 0xffffff;
			_t1.antialiasing = true;
			add(_t1);

			_t2 = new FlxText(-60,FlxG.height/3,80,"ts");
			_t2.size = _t1.size;
			_t2.color = _t1.color;
			_t2.antialiasing = _t1.antialiasing;
			add(_t2);
			
			_ok = false;
			_ok2 = false;
			
			FlxG.showCursor(ImgCursor);
			
			//Simple use of flixel save game object
			var save:FlxSave = new FlxSave();
			if(save.bind("Mode"))
			{
				if(save.data.plays == null)
					save.data.plays = 0;
				else
					save.data.plays++;
				FlxG.log("Number of plays: "+save.data.plays);
			}
		}

		override public function update():void
		{
			//Slides the text ontot he screen
			var t1m:uint = FlxG.width/2-40;
			if(_t1.x > t1m)
			{
				_t1.x -= FlxG.elapsed*FlxG.width;
				if(_t1.x < t1m) _t1.x = t1m;
			}
			var t2m:uint = FlxG.width/2+10;
			if(_t2.x < t2m)
			{
				_t2.x += FlxG.elapsed*FlxG.width;
				if(_t2.x > t2m) _t2.x = t2m;
			}
			
			//Check to see if the text is in position
			if(!_ok && ((_t1.x == t1m) || (_t2.x == t2m)))
			{
				//explosion
				_ok = true;
				FlxG.play(SndHit);
				FlxG.flash(0xffffffff,0.5);
				FlxG.quake(0.035,0.5);
				_t1.color = 0xbbbbbb;
				_t2.color = 0xbbbbbb;
				_e.restart();
				_t1.angle = 0;
				_t2.angle = 0;
				
				var t1:FlxText;
				var t2:FlxText;
				var b:FlxButton;
				
				t1 = new FlxText(0,FlxG.height/3+39,320,"by Adam, ChrisA, ChrisB, Tom, and Sarah")
				t1.alignment = "center";
				t1.color = 0x8c2faa;
				add(t1);
				
				//flixel button
				this.add((new FlxSprite(104,FlxG.height/3+53)).createGraphic(126,19,0x77ffffff));
				b = new FlxButton(t1m-10,FlxG.height/3+54,onFlixel);
				b.loadGraphic((new FlxSprite()).createGraphic(114,15,0x77ffffff),(new FlxSprite()).createGraphic(114,15,0xff000000));
				t1 = new FlxText(2,1,130,"special thanks to flixel");
				t1.color = 0x77ffffff;
				t2 = new FlxText(t1.x,t1.y,t1.width,t1.text);
				t2.color = 0x77ffffff;
				b.loadText(t1,t2);
				add(b);
				
				
				//play button
				this.add((new FlxSprite(t1m+1,FlxG.height/3+137)).createGraphic(86,19,0x77ffffff));
				_b = new FlxButton(t1m+2,FlxG.height/3+138,onButton);
				_b.loadGraphic((new FlxSprite()).createGraphic(84,15,0xffffffff),(new FlxSprite()).createGraphic(84,15,0xff000000));
				t1 = new FlxText(25,1,100,"Play");
				t1.color = 0x77000000;
				t2 = new FlxText(t1.x,t1.y,t1.width,t1.text);
				t2.color = 0x77ffffff;
				_b.loadText(t1,t2);
				add(_b);
			}
			
			//X + C were pressed, fade out and change to play state
			if(_ok && !_ok2 && FlxG.keys.X && FlxG.keys.C)
			{
				_ok2 = true;
				FlxG.play(SndHit2);
				FlxG.flash(0xffd8eba2,0.5);
				FlxG.fade(0xff131c1b,1,onFade);
			}

			super.update();
		}
		
		private function onFlixel():void
		{
			FlxG.openURL("http://flixel.org");
		}
		
		private function onButton():void
		{
			FlxG.play(SndHit2);
			FlxG.fade(0xff131c1b,1,onFade);
		}
		
		private function onFade():void
		{
			//FlxG.switchState(PlayState);
			FlxG.switchState(PlayStateTiles);
		}
	}
}
