package com.adamatomic.Mode
{
	import org.flixel.*;

	public class Player extends FlxSprite
	{
		[Embed(source="../../../data/wizard.png")] private var ImgSpaceman:Class;
		[Embed(source="../../../data/wizard_gibs.png")] private var ImgGibs:Class;
		[Embed(source="../../../data/jump.mp3")] private var SndJump:Class;
		[Embed(source="../../../data/land.mp3")] private var SndLand:Class;
		[Embed(source="../../../data/asplode.mp3")] private var SndExplode:Class;
		[Embed(source="../../../data/menu_hit_2.mp3")] private var SndExplode2:Class;
		[Embed(source="../../../data/hurt.mp3")] private var SndHurt:Class;
		[Embed(source="../../../data/jam.mp3")] private var SndJam:Class;
		
		
		private var _jumpPower:int;
		private var _bullets:Array;
		private var _curBullet:uint;
		private var _bulletVel:int;
		private var _up:Boolean;
		private var _down:Boolean;
		public var _gibs:FlxEmitter;
		

		
		public var _hats_avail:Array; // strings
		public var _cur_hat:String;
		public var _hat:Hat;
		
		public function Player(X:int,Y:int,Bullets:Array)
		{
			super(X,Y);
			loadGraphic(ImgSpaceman,true,true,16,32);
			
			_hats_avail = new Array(Hat.CAMO_HAT); // start without any
			_cur_hat = Hat.NULL_HAT;
			_hat = new Hat(_cur_hat);
			
			//bounding box tweaks
			width = 13;
			height = 31;
			offset.x = 2;
			offset.y = 1;
			
			//basic player physics
			var runSpeed:uint = 80;
			drag.x = runSpeed*16;
			acceleration.y = 420;
			_jumpPower = 185;
			maxVelocity.x = runSpeed;
			maxVelocity.y = 200;
			
			//animations 
			addAnimation("idle", [0]);
			addAnimation("run", [1, 2, 3, 0], 12);
			addAnimation("jump", [4]);
			
			//bullet stuff
			_bullets = Bullets;
			_curBullet = 0;
			_bulletVel = 160;
			
		}
		
		
		private function placeHat():void {
			_hat.x = this.x - this.width/2 + _hat.width/;
		}
		
		
		
		override public function update():void
		{

			if(dead)
			{ return;}
			//MOVEMENT
			acceleration.x = 0;
			if(FlxG.keys.LEFT)
			{
				facing = LEFT;
				acceleration.x -= drag.x;
			}
			else if(FlxG.keys.RIGHT)
			{
				facing = RIGHT;
				acceleration.x += drag.x;
			}
			if(FlxG.keys.justPressed("X") && !velocity.y)
			{
				velocity.y = -_jumpPower;
				FlxG.play(SndJump);
			}
			
			//AIMING
			_up = false;
			_down = false;
			if(FlxG.keys.UP) _up = true;
			else if(FlxG.keys.DOWN && velocity.y) _down = true;
			
			
			// CHANGE HAT
			if (FlxG.keys.justReleased("Z")) {
				if (_hats_avail.length > 0) {
					_cur_hat = _hats_avail[(_hats_avail.indexOf(_cur_hat) + 1) % _hats_avail.length];
					
					_hat = new Hat(_cur_hat);
				}
			}
			
			//ANIMATION
			if(velocity.y != 0)
			{
				play("jump");
			}
			else if(velocity.x == 0)
			{
				play("idle");
				_hat.stop();
			}
			else
			{
				play("run");
				_hat.animate();
			}
			
			
			
			
			
			
			
			
			//ACTION
			if(!flickering() && FlxG.keys.justPressed("C"))
			{
				var bXVel:int = 0;
				var bYVel:int = 0;
				var bX:int = x;
				var bY:int = y;
				if(_up)
				{
					bY -= _bullets[_curBullet].height - 4;
					bYVel = -_bulletVel;
				}
				else if(_down)
				{
					bY += height - 4;
					bYVel = _bulletVel;
					velocity.y -= 96;
				}
				else if(facing == RIGHT)
				{
					bX += width - 4;
					bXVel = _bulletVel;
				}
				else
				{
					bX -= _bullets[_curBullet].width - 4;
					bXVel = -_bulletVel;
				}
				_bullets[_curBullet].shoot(bX,bY,bXVel,bYVel);
				if(++_curBullet >= _bullets.length)
					_curBullet = 0;
			}
				
			//UPDATE POSITION AND ANIMATION
			super.update();

			//Jammed, can't fire!
			if(flickering())
			{
				if(FlxG.keys.justPressed("C"))
					FlxG.play(SndJam);
			}
		}
		
		override public function hitFloor(Contact:FlxCore=null):Boolean
		{
			if(velocity.y > 50)
				FlxG.play(SndLand);
			return super.hitFloor();
		}
		
		override public function hurt(Damage:Number):void
		{
			Damage = 0;
			if(flickering())
				return;
			FlxG.play(SndHurt);
			flicker(1.3);
			if(FlxG.score > 1000) FlxG.score -= 1000;
			if(velocity.x > 0)
				velocity.x = -maxVelocity.x;
			else
				velocity.x = maxVelocity.x;
			super.hurt(Damage);
		}
		
		override public function kill():void
		{
			if(dead)
				return;
			super.kill();
			FlxG.play(SndExplode);
			FlxG.play(SndExplode2);
			
			//Gibs emitted upon death
			_gibs = new FlxEmitter(0,0,-1.5);
			_gibs.setXVelocity(-150,150);
			_gibs.setYVelocity(-200,0);
			_gibs.setRotation(-720,-720);
			_gibs.createSprites(ImgGibs,50);
			FlxG.state.add(_gibs);
			
			_gibs.x = this.x + width/2;
			_gibs.y = this.y + height/2;
			_gibs.restart();
			
			flicker(-1);
			exists = true;
			visible = false;
			FlxG.quake(0.005,0.35);
			FlxG.flash(0xff7777ff,0.35);

			
		}
	}
}