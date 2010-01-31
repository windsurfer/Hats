package com.adamatomic.Mode 
{
	import org.flixel.*;
	/**
	 * ...
	 * @author Adam
	 */
	public class Boulder extends FlxSprite
	{
		[Embed(source = "../../../data/boulder.png")] private var ImgBoulder:Class;
		
		
		protected const bounce:Number = 0.8;
		
		public function Boulder(x_pos:Number, y_pos:Number) 
		{
			super();
			
			x = x_pos;
			y = y_pos;
			
			loadGraphic(ImgBoulder,true);
			
			
			velocity.y = 0;
			velocity.x = 100;
			acceleration.y = 420;
		}
		
		
		override public function update():void
		{
			if (dead && finished) {
				exists = false;
				return;
			}
			
			angle = (x*2) % 360;
			
			super.update();
		}
		
		override public function hitFloor(Contact:FlxCore = null):Boolean {
			velocity.y = velocity.y * -bounce; 
			return true; 
		}
		
		override public function hitWall(Contact:FlxCore = null):Boolean { velocity.x = 0; return true; }
		
	}

}