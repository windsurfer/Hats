package com.adamatomic.Mode
{
	import flash.geom.Point;
	
	import org.flixel.*;

	public class LargeSoldier extends SmallSoldier
	{
		[Embed(source="../../../data/enemy_large.png")] private var ImgSoldier:Class;
		
		
		public function LargeSoldier(xPos:int,yPos:int,ThePlayer:Player, TheWorld:FlxTilemap)
		{
			super(xPos,yPos,ThePlayer, TheWorld);
			loadGraphic(ImgSoldier,true, true,32,48);
			
			_facing = RIGHT;
			
			width = 32;
			height = 48;
			offset.x = 1;
			offset.y = -1;
			
			acceleration.y = 420;
			_run_speed = 24;
			drag.x = 120;
			drag.y = 80;
			maxVelocity.x = _run_speed;
			_feeler = new FlxSprite();
			
			addAnimation("idle", [0]);
			addAnimation("walking", [1, 2, 3, 0], 8, true);

			
			
			reset(x,y);
		}
		
	}
}
