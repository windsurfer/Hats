package com.adamatomic.Mode
{
	import org.flixel.*;

	public class PlayStateTiles extends FlxState
	{
		[Embed(source="../../../Sounds/Finals/Shoot/3.mp3")] private var SndMode:Class;
		[Embed(source="../../../data/Marps/CamoIntro.txt",mimeType="application/octet-stream")] private var TxtMap:Class;
		[Embed(source = "../../../data/Marps/HornIntro.txt", mimeType = "application/octet-stream")] private var TxtMap2:Class;
		[Embed(source = "../../../data/Marps/SpringIntro.txt", mimeType = "application/octet-stream")] private var TxtMap3:Class;
		[Embed(source = "../../../data/Marps/BunnyIntro.txt", mimeType = "application/octet-stream")] private var TxtMap4:Class;
		[Embed(source = "../../../data/Marps/SmokeIntro.txt", mimeType = "application/octet-stream")] private var TxtMap5:Class;
		
		[Embed(source = "../../../data/Marps/Smoke+Sound.txt", mimeType = "application/octet-stream")] private var TxtMap6:Class;
		[Embed(source = "../../../data/Marps/Sound+Camo.txt", mimeType = "application/octet-stream")] private var TxtMap7:Class;
		[Embed(source = "../../../data/Marps/SuperJump.txt", mimeType = "application/octet-stream")] private var TxtMap8:Class;
		[Embed(source = "../../../data/Marps/Sound_Camo_Smoke.txt", mimeType = "application/octet-stream")] private var TxtMap9:Class;
		[Embed(source = "../../../data/Marps/InsiviBlocks.txt", mimeType = "application/octet-stream")] private var TxtMap10:Class;
		[Embed(source = "../../../data/Marps/Smoke_Sound_Bunny.txt", mimeType = "application/octet-stream")] private var TxtMap11:Class;
		[Embed(source = "../../../data/Marps/MultiRooms.txt", mimeType = "application/octet-stream")] private var TxtMap12:Class;
		[Embed(source = "../../../data/Marps/Final_Countdown.txt", mimeType = "application/octet-stream")] private var TxtMap13:Class;
		
		
		
		[Embed(source="../../../data/MainTheme.mp3")] private var themeSong:Class;
		[Embed(source="../../../Sounds/Finals/Distract1.mp3")] private var SndVictory:Class;
		
		[Embed(source="../../../data/tiles_all.png")] private var ImgTiles:Class;
		
		//major game objects
		private var _tilemap:FlxTilemap;
		private var _backmap:FlxTilemap;
		private var _spikes:Array;
		private var _bullets:Array;
		
		private var _dead_blocks:Array;
		
		
		private var _player:Player;
		private var _sm_soldiers:Array;
		private var _sm_arrows:Array;
		private var _restart:Number;
		private var _smoke_bomb:SmokeBomb;
		private var _sound_bomb:SoundBomb;
		
		private var _boulder:Boulder;
		
		
		private var _finish_door:FlxSprite;
		private var _cur_level:Number;
		
		function PlayStateTiles():void
		{
			super();
			_restart = 0;
			
			//create player and bullets
			_spikes = new Array();
			_bullets = new Array();
			_sm_soldiers = new Array();
			_sm_arrows = new Array();
			_dead_blocks = new Array();
			_player = new Player(0,0, _smoke_bomb, _sound_bomb);
			for(var i:uint = 0; i < 8; i++)
				_bullets.push(new Bullet());
			
			
			_finish_door = new FlxSprite(0, 0);
			_finish_door.alpha = 0;
			_finish_door.width = 1;
			_finish_door.height = 1;
			_cur_level = 0;
			
			
			
			_boulder = new Boulder(0, 0);
			_boulder.kill();
			
			_sound_bomb = new SoundBomb();
			_smoke_bomb = new SmokeBomb();
			//add player and set up camera
			FlxG.follow(_player,2.5);
			FlxG.followAdjust(0.5, 0.0);
			
			

			changeLevel(_cur_level);
			
			//The music in this mode is positional - it fades out toward the edges of the level
			var s:FlxSound = FlxG.play(themeSong,1,true);
			s.play();
		}

		override public function update():void
		{
			
			if(_player.dead)
			{
				_restart += FlxG.elapsed;
				if(_restart > 2){
					changeProperLevel();
					_restart = 0; 
				}
					
			}
			
			super.update();
			//game restart timer
			_tilemap.collideArray(_bullets);
			_tilemap.collide(_player);
			_tilemap.collideArray(_sm_soldiers);
			_tilemap.collide(_smoke_bomb);
			_tilemap.collide(_sound_bomb);
			
			
			
			
			
			if (!_boulder.dead) {
				_tilemap.collide(_boulder);
				if (_boulder.overlaps(_player)) {
					_player.kill();
				}
			}
			
			for each (var dead_block:DeadLargeSoldier in _dead_blocks) {
				//_tilemap.collide(dead_block);
				dead_block.collide(_player);
			}
			
			
			for each (var soldier:SmallSoldier in _sm_soldiers){
				if (soldier.overlaps(_smoke_bomb) && !_smoke_bomb.dead && !soldier.dead) {
					soldier.blind();
					_smoke_bomb.explode();
				}
				if (soldier._leaves_remains && soldier.dead) {
					soldier._leaves_remains = false;
					_dead_blocks.push(new DeadLargeSoldier(soldier.x, soldier.y));
				}
			}
			
			if (!_player._invisible){
				for each ( soldier in _sm_soldiers){
					if (soldier.overlaps(_player) && !soldier.dead) {
						_player.kill();
					}
					if (soldier.overlaps(_smoke_bomb) && !_smoke_bomb.dead && !soldier.dead) {
						soldier.blind();
						_smoke_bomb.explode();
					}
				}
			}
			for each (var spike:FlxSprite in _spikes){
				if (spike.overlaps(_player)) {
					_player.kill();
				}
			}
			for each (var arrow:FlxSprite in _sm_arrows) {
				if (_tilemap.collide(arrow)){
					arrow.kill();
					var _gibs:FlxEmitter = new FlxEmitter(0,0,-0.6);
					_gibs.setXVelocity(-30,30);
					_gibs.setYVelocity( -30, 30);
					_gibs.gravity = -100;
					_gibs.setRotation(-180,-180);
					_gibs.createSprites(Player.ImgSmoke,2);
					FlxG.state.add(_gibs);
					_gibs.x = arrow.x + width/2;
					_gibs.y = arrow.y + height/4;
					_gibs.restart();
					
					arrow.x = 0;
					arrow.y = 0;
				}
				if (arrow.overlaps(_player) && !_player._invisible) {
					_player.kill();
				}
			}
			
			for each (var spike2:FlxSprite in _spikes){
				for each (var soldier2:SmallSoldier in _sm_soldiers){
					if (soldier2.overlaps(spike2)) {
						soldier2.kill();
					}
				}
			}
			
			
			if (_sound_bomb.sound_alarm) {
				_sound_bomb.sound_alarm = false;
				for each ( soldier in _sm_soldiers) {
					soldier.alarm(_sound_bomb.x, _sound_bomb.y);
				}
			}
			
			if (_finish_door.collide(_player)) {
				for each ( soldier in _sm_soldiers) {
					soldier.kill();
				}
				for each (arrow in _sm_arrows){
					arrow.kill();
				}
				
				_boulder.kill();
				
				
				_cur_level++;
				
				FlxG.play(SndVictory);
				FlxG.fade(0xff000000, 2, changeProperLevel, true);
				_player.play("victory");
				_player.active = false;
			}
			
		}
		private function changeProperLevel():void {
			FlxG.fade(0x00000000, 1, null, true);
			changeLevel(_cur_level);
		}
		
		private function changeLevel(Level:int):void {
			
			killObjects();
			
			_tilemap = new FlxTilemap();
			_backmap = new FlxTilemap();
			_tilemap.collideIndex = 9;			
			
			var MapData:String;
			if (Level == 0){
				MapData = new TxtMap;
			}else if(Level== 1) {
				MapData = new TxtMap2;
			}else if (Level == 2) {
				MapData = new TxtMap3;
			}else if (Level == 3) {
				MapData = new TxtMap4;
				_boulder = new Boulder(64, 128);
				this.add(_boulder);
			}else if (Level == 4) {
				MapData = new TxtMap5;
			}else if (Level == 5) {
				MapData = new TxtMap6;
			}else if (Level == 6) {
				MapData = new TxtMap7;
			}else if (Level == 7) {
				MapData = new TxtMap8;
			}else if (Level == 8) {
				MapData = new TxtMap9;
			}else if (Level == 9) {
				MapData = new TxtMap10;
			}else if (Level == 10) {
				MapData = new TxtMap11;
			}else if (Level == 11) {
				MapData = new TxtMap12;
			}else if (Level == 12) {
				MapData = new TxtMap13;
			}else {
				FlxG.switchState(VictoryState);
				return;
			}
			_tilemap.loadMap(MapData, ImgTiles, 16); 
			_backmap.loadMap(MapData, ImgTiles, 16);
			
			
			var player_spawn_x:int = -1;
			var player_spawn_y:int = -1;
			
			for (var i:uint = 0; i < _tilemap.totalTiles; i++) {
				var tile:uint = _tilemap.getTileByIndex(i);
				var x_pos:int = i % _tilemap.widthInTiles * 16;
				var y_pos:int = Math.floor(i / _tilemap.widthInTiles) * 16;
				
				if (tile >= 16 && tile <= 18) {
					var spike:FlxSprite = new FlxSprite(x_pos, y_pos + 8);
					spike.createGraphic(16, 16);
					_tilemap.setTileByIndex(i, 0);
					_spikes.push(spike);
				}else if (tile > 18&& tile <= 25) {
					
					
					switch (tile) {
						case 19:
							
							//spawn small soldier
							_sm_soldiers.push(new SmallSoldier(x_pos, y_pos - 16, _player, _tilemap));
							
							break;
						case 20:
							//spawn small soldier
							_sm_soldiers.push(new LargeSoldier(x_pos, y_pos - 32, _player, _tilemap));
							break;
						case 21:
							//spawn archer soldier
							var arrow:FlxSprite = new FlxSprite(0, 0);
							arrow.loadGraphic(ArcherSoldier.ImgArrow, false, true);
							arrow.kill();
							_sm_arrows.push(arrow);
							_sm_soldiers.push(new ArcherSoldier(x_pos, y_pos, _player, _tilemap, arrow));
							
							break;	
						case 22:
							// EXIT
							//_finish_door.x = x_pos;
							//_finish_door.y = y_pos;
							break;
						case 23:
							// SPAWN
							player_spawn_x = x_pos;
							player_spawn_y = y_pos - 16;
							break;
						case 24:
							// top of exit door
							
							break;
								
						case 25:
							// bottom of exit door
							
							_finish_door.x = x_pos + 8;
							_finish_door.y = y_pos + 8; // plus 8 to center it
							
							
							break;
						default:
							trace("Shouldn't be here");
							break;
					}
					// reset the tile to nothing
					_tilemap.setTileByIndex(i, 0);
					_backmap.setTileByIndex(i, 0);
				}
				
				if (tile > 23) {
					
					_backmap.setTileByIndex(i, tile);
					_tilemap.setTileByIndex(i, 0);
				}
			}
			
			
			
			if (player_spawn_y <= -1 && player_spawn_y <= -1){
				_player.x = _tilemap.width / 2;
				_player.y = _tilemap.height / 2;
			}else {
				_player.x = player_spawn_x;
				_player.y = player_spawn_y;
			}
			
			FlxG.flash(0xff131c1b);
			
			
			//center Map
			var fx:uint = _tilemap.width/2 - FlxG.width/2;
			var fy:uint = _tilemap.height/2 - FlxG.height/2;
			FlxG.followBounds(fx,fy,fx,fy);
			_tilemap.follow();
			
			FlxG.follow(_player, 2.5);
			if (Level == 1) {
			
				var _t1 :FlxText = new FlxText(FlxG.width/2,FlxG.height/3,80,"Z, X, C");
				_t1.size = 32;
				_t1.color = 0xffffff;
				_t1.antialiasing = true;
				this.add(_t1);	
			}
			addObjects();

		}
		
		private function addObjects():void {
			this.add(_backmap);
			for(var i:uint = 0; i < 8; i++)
				this.add(_bullets[i]);
			for each (var soldier:SmallSoldier in _sm_soldiers){
				this.add(soldier);
			}
			this.add(_player);
			this.add(_player._hat);
			this.add(_tilemap);
			this.add(_smoke_bomb);
			this.add(_sound_bomb);
			this.add(_finish_door);
			
			for each (var arrow:FlxSprite in _sm_arrows){
				this.add(arrow);
			}
			
			
			//always add last
			_player.add_gui();
		}
		
		private function killObjects():void {
			
			while (_spikes.pop() != null) { }
			while (_sm_soldiers.pop() != null) { }
			while (_sm_arrows.pop() != null) {}
			while (_dead_blocks.pop() != null) {}	
			
			this._layer.destroy();
			
			_player = new Player(0,0, _smoke_bomb, _sound_bomb);
			
		}
	}
}
