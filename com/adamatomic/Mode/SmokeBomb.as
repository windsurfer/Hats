package com.adamatomic.Mode 
{
	import org.flixel.*;
	/**
	 * ...
	 * @author Adam
	 */
	public class SmokeBomb extends FlxSprite
	{
		
		protected var timer:Number;
		
		public function SmokeBomb()
		{
			super();
			
		}
		
		override public function update():void {
			timer += FlxG.elapsed;
			if (timer >= 0.1) {
				timer = 0;
					// emit particles
			}
			super.update();
		}
	}

}