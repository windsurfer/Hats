package com.globalgamejam.Hats
{
	import flash.geom.Point;
	
	import org.flixel.*;

	public class LargeSoldier extends SmallSoldier
	{
		[Embed(source="../../../data/enemy_large.png")] private var ImgSoldier:Class;
		[Embed(source = "../../../data/enemy_large_gibs.png")] private var ImgGibs:Class;
		
		[Embed(source = "../../../Sounds/Finals/LargeEnemy/Hurt1.mp3")] private var Hurt1:Class;
		[Embed(source="../../../Sounds/Finals/LargeEnemy/Hurt2.mp3")] private var Hurt2:Class;
		[Embed(source="../../../Sounds/Finals/LargeEnemy/Hurt3.mp3")] private var Hurt3:Class;

		
		private var _gibs:FlxEmitter;
		
		public function LargeSoldier(xPos:int,yPos:int,ThePlayer:Player, TheWorld:FlxTilemap)
		{
			super(xPos,yPos,ThePlayer, TheWorld);
			loadGraphic(ImgSoldier,true, true,32,48);
			
			_leaves_remains = true;
			_facing = RIGHT;
			
			width = 24;
			height = 40;
			offset.x = 5;
			offset.y = 8;
			
			acceleration.y = 420;
			slow_speed = 16;
			fast_speed = 64;
			
			_run_speed = slow_speed;
			drag.x = 120;
			drag.y = 80;
			maxVelocity.x = slow_speed;
			_feeler = new FlxSprite();
			
			addAnimation("idle", [0]);
			addAnimation("walking", [1, 2, 3, 0], 8, true);
			addAnimation("angry", [4, 5 , 6, 7], 18, true);
			
			
			reset(x,y);
		}
		
		private function make_snd():void {
			var rand:Number = FlxG.random();
			if (rand < 0.33) {
				FlxG.play(Hurt1);
			}else if (rand < 0.66) {
				FlxG.play(Hurt2);
			}else {
				FlxG.play(Hurt3);
			}
		}
		
		override public function blind():void 
		{
			super.blind();
			make_snd();
		}
		
		override public function kill():void
		{
			if(dead)
				return;
			
			make_snd();
			//Gibs emitted upon death
			_gibs = new FlxEmitter(0,0,-2.5);
			_gibs.setXVelocity(-150,150);
			_gibs.setYVelocity(-300,0);
			_gibs.setRotation(-320,-320);
			_gibs.createSprites(ImgGibs,80);
			FlxG.state.add(_gibs);
			
			_gibs.x = this.x + width/2;
			_gibs.y = this.y + height/2;
			_gibs.restart();
			
			// this replaces the super.kill()
			exists = false;
			dead = true;
		}
	}
}
