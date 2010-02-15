package com.adamatomic.Mode
{
	import org.flixel.*;

	public class Player extends FlxSprite
	{
		[Embed(source="../../../data/wizard.png")] public static var ImgSpaceman:Class;
		[Embed(source = "../../../data/wizard_gibs.png")] private var ImgGibs:Class;
		[Embed(source="../../../data/smoke_gibs.png")] public static var ImgSmoke:Class;
		
		
		[Embed(source="../../../Sounds/Finals/Shoot/3.mp3")] private var SndJump:Class;
		[Embed(source="../../../Sounds/Finals/Shoot/4.mp3")] private var SndLand:Class;
		[Embed(source ="../../../Sounds/Finals/Shoot/5.mp3")] private var SndExplode:Class;
		
		[Embed(source="../../../Sounds/Finals/NeatShit.mp3")] private var SndShot:Class;
		[Embed(source = "../../../Sounds/Finals/Smoke/Smoke4.mp3")] private var SmokeShot:Class;
		[Embed(source = "../../../Sounds/Finals/Smoke/Smoke2.mp3")] private var Cloak:Class;
		
		[Embed(source = "../../../Sounds/Finals/Smoke/Smoke3.mp3")] private var SndSwitchHat:Class;
		
		
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
		public var _on_floor:Boolean;
		
		private const runSpeed:uint = 80;
		
		public var _hat_bar:HatBar;
		
		public function Player(X:int,Y:int, Smoke:SmokeBomb, Sound:SoundBomb, Hats:Array = null)
		{
			super(X,Y);
			loadGraphic(ImgSpaceman,true,true,16,32);
			
			_sound_bomb = Sound;
			_smoke_bomb = Smoke;
			
			if (Hats != null) {
				_hats_avail = Hats;
			}else{
				_hats_avail = new Array(Hat.CAMO_HAT, Hat.SPRING_HAT,  Hat.BUNNY_HAT, Hat.SMOKE_HAT, Hat.SOUND_HAT); // start with all hats
			}
			_cur_hat = _hats_avail[0];
			_hat = new Hat(_cur_hat, this);
			
			_hat_bar = new HatBar(this);
			_hat_bar.show_hats(_hats_avail);
			
			
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
			_on_floor = false;
			
			//animations 
			addAnimation("idle", [0]);
			addAnimation("run", [1, 2, 3, 0], 12);
			addAnimation("jump", [4]);
			addAnimation("victory", [5]);
			change_hat(0);
			
		}
		
		
		public function add_gui():void {
			_hat_bar.add_view();
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
			if (_invisible == true) {
				return;
			}
			
			FlxG.play(Cloak);
			
		 	velocity.x = 0;
			acceleration.x = 0;
			
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
		
		public function go_visible():void {
			_invisible = false;
			this.alpha = 1;
			
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
		 	if (velocity.y == 0 && _on_floor) {
				FlxG.play(SndJump);
				velocity.y -= 300;
				_on_floor = false;
			}
		}
		public function please_jump():void {
		 	if (velocity.y == 0 && _on_floor) {
				FlxG.play(SndJump);
				velocity.y -= _jumpPower;
				_on_floor = false;
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
		
		
		public function change_hat(num:Number = -1):void {
			// will change hat if it's a valid number
			// if -1 it will advance to the next hat
			if (num <= -1 ) {
				num = (_hats_avail.indexOf(_cur_hat) + 1) % _hats_avail.length;
			}
			if (num > _hats_avail.length) {
				return;
			}
			
			FlxG.play(SndSwitchHat);
			_cur_hat = _hats_avail[num];
			
			//TODO: FIX. currently terribly inneffient
			_hat.kill();
			_hat.destroy();
			_hat = new Hat(_cur_hat, this);
			
			_hat_bar.chose_hat(num);
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
			
			if ((FlxG.keys.justPressed("LEFT") || FlxG.keys.justPressed("RIGHT")) && _invisible) {
				go_visible();
			}
			
			if(FlxG.keys.LEFT && !_invisible)
			{
				facing = LEFT;
				acceleration.x -= drag.x;
			}
			else if(FlxG.keys.RIGHT && !_invisible)
			{
				facing = RIGHT;
				acceleration.x += drag.x;
			}
			
			if (_cur_hat == Hat.CAMO_HAT && velocity.x == 0 && velocity.y == 0) {
				//go_invisible();
				
			}else if (this.alpha != 1) {
				go_visible();
			}
			
			
			// press the jump button on the ground
			if ((FlxG.keys.justPressed("X") || FlxG.keys.justPressed("UP")) )
			{
				if (_cur_hat == Hat.SPRING_HAT){
					please_jump_high();
				}else {
					please_jump();
				}
			}
			
			// holding the hat button
			if (( FlxG.keys.pressed("C")) && velocity.y != 0) {
				if (_cur_hat == Hat.BUNNY_HAT) {
					velocity.x = runSpeed*3 * (facing == RIGHT ? 1 : -1);
				}
			}
			
			
			// CHANGE HAT
			if (FlxG.keys.justPressed("ONE")) {
				change_hat(0);
			}	
			if (FlxG.keys.justPressed("TWO")) {
				change_hat(1);
			}			
			if (FlxG.keys.justPressed("THREE")) {
				change_hat(2);
			}			
			if (FlxG.keys.justPressed("FOUR")) {
				change_hat(3);
			}			
			if (FlxG.keys.justPressed("FIVE")) {
				change_hat(4);
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
			
			
			
			if (FlxG.keys.pressed("C") )
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
			if(velocity.y > 150)
				FlxG.play(SndLand);
			
			_on_floor = true;
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