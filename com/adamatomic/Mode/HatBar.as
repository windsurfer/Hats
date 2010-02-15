package com.adamatomic.Mode 
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author ...
	 */
	public class HatBar extends FlxSprite
	{
		
		protected var _player:Player;
		
		public var hats:Array; // array of real hats
		
		public function HatBar(ThePlayer:Player) 
		{
			x = 0;
			y = 12;
			_player = ThePlayer;
			createGraphic(320, 8, 0x44777777);
			scrollFactor.x = 0;
			scrollFactor.y = 0;
			hats = new Array();
		}
		
		public function add_view():void {
			FlxG.state.add(this);
			for each (var _hat:Hat in hats) {
				FlxG.state.add(_hat);
			}
		}
		
		public function chose_hat(num:Number):void {
			if (num < 0 || num >= hats.length) {
				return;
			}
			
			for each (var _hat:Hat in hats) {
				_hat.scale.x = _hat.scale.y = 0.6;
			}
			
			hats[num].scale.x = hats[num].scale.y = 1;
		}
		
		public function show_hats(new_hats:Array):void { // takes an array of strings
			for each (var _hat:String in new_hats) {
				
				var found_one:Boolean = false;
				
				for each (var __hat:Hat in hats) {
					if (__hat.isa(_hat)) {
						found_one = true;
						break;
					}
				}
				if (found_one == false) {
					
					var gui_hat:Hat = new Hat(_hat);
					gui_hat.scrollFactor.x = 0;
					gui_hat.scrollFactor.y = 0;
					
					gui_hat.y = 0;
					gui_hat.x = hats.length * 24 +8;
					
					
					hats.push(gui_hat);
					
				}
			}
		}
		
		
	}

}