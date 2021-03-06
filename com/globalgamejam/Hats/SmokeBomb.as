package com.globalgamejam.Hats 
{
	import org.flixel.*;
	/**
	 * ...
	 * @author Adam
	 */
	public class SmokeBomb extends FlxSprite
	{
		
		[Embed(source = "../../../Sounds/Finals/Smoke/Smoke1.mp3")] private var SmokeLand:Class;
		
		protected var timer:Number;
		protected const max_timer:Number = 4;
		
		public function SmokeBomb()
		{
			super();
			acceleration.y = 420;
			kill();
			timer = 0;
			
		}
		
		public function shoot(X:Number, Y:Number, x_vel:Number):void {
			this.x = X;
			this.y = Y;
			revive();
			velocity.x = x_vel;
			velocity.y = -50;
			visible = false;
		}
		
		override public function update():void {
			if (dead) { return; }
			if (timer < max_timer) {
				timer += FlxG.elapsed;
			}else {
				kill();
			}
			
			var _gibs:FlxEmitter = new FlxEmitter(0,0,-0.2);
			_gibs.setXVelocity(-90,90);
			_gibs.setYVelocity( -90, 90);
			_gibs.gravity = -100;
			_gibs.setRotation(-180,-180);
			_gibs.createSprites(Player.ImgSmoke,1);
			FlxG.state.add(_gibs);
			_gibs.x = this.x + width/2;
			_gibs.y = this.y + height/2;
			_gibs.restart();
			super.update();
		}
		
		
		
		public function explode():void {
			if (dead) { return; }
			FlxG.play(SmokeLand);
			//Gibs emitted upon explosion
			var _gibs:FlxEmitter = new FlxEmitter(0,0,-1.5);
			_gibs.setXVelocity(-90,90);
			_gibs.setYVelocity( -90, 90);
			_gibs.gravity = -100;
			_gibs.setRotation(-180,-180);
			_gibs.createSprites(Player.ImgSmoke,50);
			FlxG.state.add(_gibs);
			_gibs.x = this.x + width/2;
			_gibs.y = this.y + height/2;
			_gibs.restart();
			
			this.kill();
		}
		
		public function revive():void {
			exists = true;
			dead = false;
			timer = 0;
		}
	}
}

