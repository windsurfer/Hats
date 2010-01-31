package com.adamatomic.Mode
{
	import org.flixel.*;

	public class VictoryState extends FlxState
	{
		[Embed(source="../../../data/menu_hit_2.mp3")] private var SndMenu:Class;
		
		private var _timer:Number;
		private var _fading:Boolean;

		public function VictoryState()
		{
			super();
			_timer = 0;
			_fading = false;
			FlxG.flash(0xffffffff);
			
			//Gibs emitted upon death
			var gibs:FlxEmitter = new FlxEmitter(0,-50,0.03);
			gibs.setSize(FlxG.width,0);
			gibs.setXVelocity();
			gibs.setYVelocity(0,100);
			gibs.setRotation(-360,-360);
			gibs.gravity = 80;
			gibs.createSprites(MenuState.ImgHats,120);
			add(gibs);
			
			var guy:FlxSprite = new FlxSprite(160, 180);
			guy.loadGraphic(Player.ImgSpaceman, true, true, 16, 32);
			guy.addAnimation("yay", [5, 5, 0], 2, true);
			guy.play("yay");
			add(guy);
			
			add((new FlxText(0,FlxG.height/2-35,FlxG.width,"VICTORY")).setFormat(null,16,0xffffff,"center"));
		}

		override public function update():void
		{
			super.update();
			if(!_fading)
			{
				_timer += FlxG.elapsed;
				if(FlxG.keys.justPressed("X") || FlxG.keys.justPressed("C"))
				{
					_fading = true;
					FlxG.play(SndMenu);
					FlxG.fade(0xffffffff,2,onPlay);
				}
			}
		}
		
		private function onPlay():void { FlxG.switchState(PlayStateTiles); }
	}
}