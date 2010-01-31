package com.adamatomic.Mode 
{
	import org.flixel.*;
	/**
	 * ...
	 * @author Adam
	 */
	public class SoundBomb extends FlxSprite
	{
		
		
		[Embed(source="../../../data/music_gibs.png")] private var ImgSound:Class;
		
		protected var timer:Number;
		protected const max_timer:Number = 1.5;
		public var sound_alarm:Boolean;
		
		public function SoundBomb()
		{
			super();
			acceleration.y = 0;
			kill();
			timer = 0;
			sound_alarm = false;
		}
		
		public function shoot(X:Number, Y:Number, x_vel:Number):void {
			this.x = X;
			this.y = Y;
			revive();
			velocity.x = x_vel;
			velocity.y = 0;
			visible = false;
		}
		
		override public function update():void {
			if (dead) { return; }
			if (timer < max_timer) {
				timer += FlxG.elapsed;
			}else {
				explode();
			}
			var _gibs:FlxEmitter = new FlxEmitter(0,0,-0.2);
			_gibs.setXVelocity(-90,90);
			_gibs.setYVelocity( -90, 90);
			_gibs.gravity = -100;
			_gibs.setRotation(-180,-180);
			_gibs.createSprites(ImgSound,1);
			FlxG.state.add(_gibs);
			_gibs.x = this.x + width/2;
			_gibs.y = this.y + height/2;
			_gibs.restart();
			super.update();
		}
		
		override public function collide(Core:FlxCore):Boolean 
		{
			explode();
			return true;
		}
		
		override public function hitWall(Core:FlxCore = null):Boolean 
		{
			explode();
			return true;
		}
		
		override public function hitFloor(Core:FlxCore = null):Boolean 
		{
			explode();
			return true;
		}
		
		public function explode():void {
			if (dead) { return; }
			
			sound_alarm = true;
			
			//Gibs emitted upon explosion
			var _gibs:FlxEmitter = new FlxEmitter(0,0,-2.5);
			_gibs.setXVelocity(-90,90);
			_gibs.setYVelocity( -90, 90);
			_gibs.gravity = -100;
			_gibs.setRotation( -180, -180);
			_gibs.alpha = 0.5;
			_gibs.createSprites(ImgSound,50);
			FlxG.state.add(_gibs);
			_gibs.x = this.x + width/2;
			_gibs.y = this.y + height/2;
			_gibs.restart();
			
			this.kill();
		}
		
		public function revive():void {
			exists = true;
			dead = false;
			sound_alarm = false;
			timer = 0;
		}
	}
}