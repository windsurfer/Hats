package com.adamatomic.Mode 
{
	import org.flixel.*;
	/**
	 * ...
	 * @author Adam
	 */
	public class DeadLargeSoldier extends FlxSprite
	{
		
		[Embed(source = "../../../data/enemy_large_block.png")] private var ImgBlock:Class;

		
		public function DeadLargeSoldier(x_pos:Number, y_pos:Number) 
		{
			super(x_pos, y_pos+32);
			loadGraphic(ImgBlock, true, true, 48, 15);
			FlxG.state.add(this);
		}
		
	}

}