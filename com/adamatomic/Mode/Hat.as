package com.adamatomic.Mode 
{
	/**
	 * ...
	 * @author Adam
	 */
	
	import org.flixel.*;
	
	
	
	public class Hat extends FlxSprite
	{
		
		[Embed(source="../../../data/hat1.png")] private var ImgCamo:Class;
		
		public static const NULL_HAT:String = "NULL_HAT";
		public static const BUNNY_HAT:String = "BUNNY_HAT";
		public static const SPRING_HAT:String = "SPRING_HAT";
		public static const SMOKE_HAT:String = "SMOKE_HAT";
		public static const CAMO_HAT:String = "CAMO_HAT";
		public static const SOUND_HAT:String = "SOUND_HAT";
		
		public function Hat(WhichHat:String)
		{
			if (WhichHat == CAMO_HAT){
				loadGraphic(ImgCamo, true, true, 23, 23);
				addAnimation("idle", [0]);
				addAnimation("move", [1, 0], 12);
			}else {
				createGraphic(23, 23);
			}
			
			FlxG.state.add(this);
		}
		
		
		public function animate():void {
			play("move");
		}
		public function stop():void {
			play("idle");
		}
		
	}

}