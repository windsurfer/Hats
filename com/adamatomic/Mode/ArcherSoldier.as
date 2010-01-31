package com.adamatomic.Mode
{
	import flash.geom.Point;
	
	import org.flixel.*;

	public class ArcherSoldier extends SmallSoldier
	{
		[Embed(source = "../../../data/enemyArrow_with_arrow.png")] private var ImgSoldier:Class;
		[Embed(source="../../../data/arrow.png")] public static var ImgArrow:Class;
		
		[Embed(source = "../../../Sounds/Finals/Shoot/5.mp3")] private var Shot1:Class;
		
		private var _gibs:FlxEmitter;
		public var _arrow:FlxSprite;
		
		protected const cooldown:Number = 3;
		
		
		public function ArcherSoldier(xPos:int,yPos:int,ThePlayer:Player, TheWorld:FlxTilemap, Arrow:FlxSprite)
		{
			super(xPos,yPos,ThePlayer, TheWorld);
			loadGraphic(ImgSoldier,true, true,16,16);
			
			_arrow = Arrow;
			_timer = cooldown;
			
			_leaves_remains = false;
			_facing = LEFT;
			
			width = 16;
			height = 16;
			offset.x = 1;
			offset.y = 1;
			
			
			addAnimation("idle", [0]);
			addAnimation("shoot", [1, 2], 2);
		}
		
		override public function update():void 
		{
			//super.update();
			if (_blinded_timer > 0) {
				_blinded_timer -= FlxG.elapsed/2;
				
				var _gibs:FlxEmitter = new FlxEmitter(0,0,-0.6);
				_gibs.setXVelocity(-30,30);
				_gibs.setYVelocity( -30, 30);
				_gibs.gravity = -100;
				_gibs.setRotation(-180,-180);
				_gibs.createSprites(Player.ImgSmoke,1);
				FlxG.state.add(_gibs);
				_gibs.x = this.x + width/2;
				_gibs.y = this.y + height/4;
				_gibs.restart();
			}else if (_timer <= 0) {
				play("idle");
				// normal operation
				if (_player.x > this.x) {
					facing = RIGHT;
				}else {
					facing = LEFT;
				}
				if ((_player.y > this.y - 32) && (_player.y < this.y + 32)){
					var p:Point = new Point();
					if (!_world.ray(this.x, this.y, _player.x, _player.y, p)) {
						shoot();
						_timer = cooldown;
					}
					
				}
				
			}else {
				_timer -= FlxG.elapsed;
			}
			
			
		}
		
		
		public function shoot():void {
			play("shoot");
			FlxG.play(Shot1);
			var _gibs:FlxEmitter = new FlxEmitter(0,0,-0.6);
				_gibs.setXVelocity(-30,30);
				_gibs.setYVelocity( -30, 30);
				_gibs.gravity = -100;
				_gibs.setRotation(-180,-180);
				_gibs.createSprites(Player.ImgSmoke,1);
				FlxG.state.add(_gibs);
				_gibs.x = this.x + width/2;
				_gibs.y = this.y + height/4;
				_gibs.restart();
			
			_arrow.velocity.x = facing == RIGHT ? 100 : -100;
			_arrow.exists = true;
			_arrow.dead = false;
			_arrow.x = this.x;
			_arrow.y = this.y;
			_arrow.facing = this.facing;
			
		}
		
		
		override public function kill():void
		{
			if(dead)
				return;
				
			// this replaces the super.kill()
			exists = false;
			dead = true;
		}
	}
}
