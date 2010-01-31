package com.adamatomic.Mode 
{
	/**
	 * ...
	 * @author Adam
	 */
	
	import org.flixel.*;
	
	
	
	public class Hat extends FlxSprite
	{
		
		[Embed(source="../../../data/Camo_Hat.png")] private var ImgCamo:Class;
		[Embed(source = "../../../data/Bunny_Hat.png")] private var ImgBunny:Class;
		[Embed(source = "../../../data/Spring_Hat.png")] private var ImgSpring:Class;
		
		public static const NULL_HAT:String = "NULL_HAT";
		public static const BUNNY_HAT:String = "BUNNY_HAT";
		public static const SPRING_HAT:String = "SPRING_HAT";
		public static const SMOKE_HAT:String = "SMOKE_HAT";
		public static const CAMO_HAT:String = "CAMO_HAT";
		public static const SOUND_HAT:String = "SOUND_HAT";
		
		public function Hat(WhichHat:String)
		{
			if (WhichHat == CAMO_HAT){
				loadGraphic(ImgCamo, true, true, 28, 23);
				addAnimation("idle", [0]);
				addAnimation("move", [1, 0], 6);
			}else if (WhichHat == BUNNY_HAT){
				loadGraphic(ImgBunny, true, true, 28, 23);
				addAnimation("idle", [0]);
				addAnimation("move", [1, 0], 6);
			}else if (WhichHat == SPRING_HAT){
				loadGraphic(ImgSpring, true, true, 28, 23);
				addAnimation("idle", [0]);
				addAnimation("move", [1, 0], 6);
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