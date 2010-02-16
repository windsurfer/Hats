package com.globalgamejam.Hats 
{
	import flash.geom.Point;
	import org.flixel.*;
	/**
	 * ...
	 * @author Adam
	 */
	public class DeadLargeSoldier extends FlxSprite
	{
		
		[Embed(source = "../../../data/enemy_large_block.png")] private var ImgBlock:Class;

		private var player_ref:Player;
		public static const _fall_rate:Number = 1.5;
		
		public function DeadLargeSoldier(x_pos:Number, y_pos:Number, _player:Player) 
		{
			super(x_pos, y_pos + 24);
			player_ref = _player;
			loadGraphic(ImgBlock, true, true, 48, 15);
			height = 2;
			
			FlxG.state.add(this);
			fixed = true;
			//acceleration.y = 480;
		}
		
		
		override public function collide(Core:FlxCore):Boolean {
			if (super.collide(Core)){
				y += _fall_rate * FlxG.elapsed;
				return true;
			}else {
				return false;
			}
		}
	}

}