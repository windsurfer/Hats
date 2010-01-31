package com.adamatomic.Mode
{
	import flash.geom.Point;
	
	import org.flixel.*;

	public class SmallSoldier extends FlxSprite
	{
		[Embed(source="../../../data/enemy_normal.png")] private var ImgSoldier:Class;
		[Embed(source="../../../data/enemy_normal_gibs.png")] private var ImgGibs:Class;
		[Embed(source="../../../data/asplode.mp3")] private var SndExplode:Class;
		[Embed(source="../../../data/hit.mp3")] private var SndHit:Class;
		
		private var _gibs:FlxEmitter;
		private var _player:Player;
		protected var _timer:Number;
		protected var _run_speed:Number;
		protected var _stand_timer:Number;
		protected var _world:FlxTilemap;
		public var _feeler:FlxSprite;
		static private var _cb:uint = 0;
		
		public function SmallSoldier(xPos:int,yPos:int,ThePlayer:Player, TheWorld:FlxTilemap)
		{
			super(xPos,yPos);
			loadGraphic(ImgSoldier,true, true,16,32);
			_player = ThePlayer;
			_world = TheWorld;
			
			_facing = RIGHT;
			_stand_timer = 0;
			
			width = 16;
			height = 32;
			offset.x = 1;
			offset.y = -1;
			
			acceleration.y = 420;
			_run_speed = 32;
			drag.x = 120;
			drag.y = 80;
			maxVelocity.x = _run_speed;
			_feeler = new FlxSprite();
			
			addAnimation("idle", [0]);
			addAnimation("walking", [1, 2, 3, 0], 12, true);

			
			
			reset(x,y);
		}
		
		override public function hitWall(Contact:FlxCore = null):Boolean
		{
			if (_facing == RIGHT) {
				_facing = LEFT;
			}else {
				_facing = RIGHT;
			}
			return super.hitWall();
		}
		
		override public function update():void
		{
			if(dead)
			{
				if (finished) 
					exists = false;
				else
					super.update();
				return;
			}
			
			
			
			
			
			
			if (velocity.y == 0) { // on ground
				
				acceleration.x = 0;
				
				// AI part
				
				if (_facing == RIGHT) {
					acceleration.x += _run_speed;
					_feeler.x = this.x + this.width;
				}else if (_facing == LEFT) {
					acceleration.x -= _run_speed;
					_feeler.x = this.x -this.width;
				}
				_feeler.y = this.y+this.height;
				
	
				
				if (!_world.collide(_feeler)) {
					acceleration.x = 0;
					play("idle");
					_timer += FlxG.elapsed;
				}else {
					_timer = 0;
					play("walking");
				}
				if (_timer > 2) {
					_timer = 0;
					if (_facing == RIGHT) {
						_facing = LEFT;
					}else {
						_facing = RIGHT;
					}
				}
				
			}
			
			super.update();
		}
		
		override public function hurt(Damage:Number):void
		{
			//TODO: What is hurt?
		}
		
		override public function kill():void
		{
			if(dead)
				return;
			
			//Gibs emitted upon death
			_gibs = new FlxEmitter(0,0,-1.5);
			_gibs.setXVelocity(-150,150);
			_gibs.setYVelocity(-200,0);
			_gibs.setRotation(-720,-720);
			_gibs.createSprites(ImgGibs,20);
			FlxG.state.add(_gibs);
			
			_gibs.x = this.x + width/2;
			_gibs.y = this.y + height/2;
			_gibs.restart();
			super.kill();
		}
		
		override public function reset(X:Number, Y:Number):void
		{
			super.reset(X,Y);
			velocity.x = 0;
			velocity.y = 0;
			health = 2;
			_timer = 0;
			play("idle");
		}
		
		private function shoot():void
		{
			
		}
		override public function hitFloor(Contact:FlxCore=null):Boolean
		{
			return super.hitFloor();
		}
	}
}
