package com.adamatomic.Mode
{
	import org.flixel.*;

	public class Player extends FlxSprite
	{
		[Embed(source="../../../data/wizard.png")] public static var ImgSpaceman:Class;
		[Embed(source = "../../../data/wizard_gibs.png")] private var ImgGibs:Class;
		[Embed(source="../../../data/smoke_gibs.png")] public static var ImgSmoke:Class;
		
		
		[Embed(source="../../../Sounds/Finals/Shoot/3.mp3")] private var SndJump:Class;
		[Embed(source="../../../Sounds/Finals/Shoot/3.mp3")] private var SndLand:Class;
		[Embed(source ="../../../Sounds/Finals/Shoot/3.mp3")] private var SndExplode:Class;
		
		[Embed(source="../../../Sounds/Finals/NeatShit.mp3")] private var SndShot:Class;
		[Embed(source = "../../../Sounds/Finals/Smoke/Smoke4.mp3")] private var SmokeShot:Class;
		[Embed(source = "../../../Sounds/Finals/Smoke/Smoke2.mp3")] private var Cloak:Class;
		
		[Embed(source = "../../../Sounds/Finals/Shoot/1.mp3")] private var SndSwitchHat:Class;
		
		
		private var _jumpPower:int;
		private var _bullets:Array;
		private var _curBullet:uint;
		private var _bulletVel:int;
		private var _up:Boolean;
		private var _down:Boolean;
		public var _gibs:FlxEmitter;
		
		
		private var _smoke_bomb:SmokeBomb;
		private var _sound_bomb:SoundBomb;
		

		
		public var _hats_avail:Array; // strings
		public var _cur_hat:String;
		public var _hat:Hat;
		public var _invisible:Boolean;
		
		public var _shoot_timer:Number;
		
		private const runSpeed:uint = 80;
		
		public function Player(X:int,Y:int, Smoke:SmokeBomb, Sound:SoundBomb)
		{
			super(X,Y);
			loadGraphic(ImgSpaceman,true,true,16,32);
			
			_sound_bomb = Sound;
			_smoke_bomb = Smoke;
			
			_hats_avail = new Array(Hat.SPRING_HAT, Hat.CAMO_HAT, Hat.BUNNY_HAT, Hat.SMOKE_HAT, Hat.SOUND_HAT); // start without any
			_cur_hat = Hat.CAMO_HAT;
			_hat = new Hat(_cur_hat, this);
			
			_invisible = false;
			_shoot_timer = 0;
			
			//bounding box tweaks
			width = 13;
			height = 31;
			offset.x = 2;
			offset.y = 1;
			
			//basic player physics
			drag.x = runSpeed * 16;
			acceleration.y = 420;
			_jumpPower = 185;
			maxVelocity.x = runSpeed;
			maxVelocity.y = 300;
			
			//animations 
			addAnimation("idle", [0]);
			addAnimation("run", [1, 2, 3, 0], 12);
			addAnimation("jump", [4]);
			addAnimation("victory", [5]);
			
		}
		
		
		private function placeHat():void {
			_hat.x = this.x - 8 + (facing == RIGHT ? 1 :0);
			_hat.y = this.y - this.height / 2 + _hat.height / 2 - 11;
			_hat.facing = this.facing;
		}
		
		public function go_invisible():void {
			if (velocity.y != 0) {
				return;
			}
			
			FlxG.play(Cloak);
			
		 	velocity.x = 0;
			_invisible = true;
			this.alpha = 0.2;
			
			//Gibs emitted upon invisibility
			_gibs = new FlxEmitter(0,0,-1.5);
			_gibs.setXVelocity(-20,20);
			_gibs.setYVelocity( 30, 5);
			_gibs.gravity = -100;
			_gibs.setRotation(-180,-180);
			_gibs.createSprites(ImgSmoke,9);
			FlxG.state.add(_gibs);
			_gibs.x = this.x + width/2;
			_gibs.y = this.y + height/2;
			_gibs.restart();
		}
		
		public function please_jump_high():void {
		 	if (velocity.y == 0) {
				FlxG.play(SndJump);
				velocity.y -= 300;
			}
		}
		
		public function please_shoot_sound():void {
		 	if (_shoot_timer<=0){
				_sound_bomb.shoot(x, y, (facing == RIGHT ? 200 : -200));
				_shoot_timer = 1;
				FlxG.play(SndShot);
			}
		}
		public function please_shoot_smoke():void {
			if (_shoot_timer<=0){
				_smoke_bomb.shoot(x, y, (facing == RIGHT ? 400 : -400));
				_shoot_timer = 1;
				FlxG.play(SmokeShot);
			}
		}
		
		override public function update():void
		{
			
			if(dead)
			{ return; }
			
			if (_shoot_timer > 0) {
				_shoot_timer -= FlxG.elapsed;
			}
			
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
			if ((FlxG.keys.justPressed("X") || FlxG.keys.justPressed("UP")) && !velocity.y)
			{
				velocity.y = -_jumpPower;
				
			}
			
			// CHANGE HAT
			if (FlxG.keys.justReleased("Z")) {
				if (_hats_avail.length > 0) {
					FlxG.play(SndSwitchHat);
					_cur_hat = _hats_avail[(_hats_avail.indexOf(_cur_hat) + 1) % _hats_avail.length];
					_hat.kill();
					_hat.destroy();
					_hat = new Hat(_cur_hat, this);
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
			
			
			// conditional hat stuff
			if (_cur_hat == Hat.BUNNY_HAT) {
				maxVelocity.x = runSpeed*3;
			}else {
				maxVelocity.x = runSpeed;
			}
			
			
			if (_cur_hat == Hat.CAMO_HAT && velocity.x == 0 && velocity.y == 0) {
				//go_invisible();
				
				
			}else if (this.alpha != 1) {
				_invisible = false;
				this.alpha = 1;
			}
			
			
			
			
			
			
			
			if(FlxG.keys.justPressed("C"))
			{
				// Activate hat!
				_hat.run();
			}
				
			//UPDATE POSITION AND ANIMATION
			super.update();
			
			
			placeHat(); // DO IT LAST
		}
		
		override public function hitFloor(Contact:FlxCore=null):Boolean
		{
			if(velocity.y > 50)
				FlxG.play(SndLand);
			return super.hitFloor();
		}
		
		
		
		override public function kill():void
		{
			if(dead)
				return;
			super.kill();
			FlxG.play(SndExplode);
			
			_hat.kill();
			_hat.destroy();
			
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