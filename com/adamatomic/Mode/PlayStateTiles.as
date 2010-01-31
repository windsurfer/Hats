package com.adamatomic.Mode
{
	import org.flixel.*;

	public class PlayStateTiles extends FlxState
	{
		[Embed(source="../../../data/mode.mp3")] private var SndMode:Class;
		[Embed(source="../../../data/Marps/TestLevel.txt",mimeType="application/octet-stream")] private var TxtMap:Class;
		[Embed(source = "../../../data/map2.txt", mimeType = "application/octet-stream")] private var TxtMap2:Class;
		[Embed(source = "../../../data/map3.txt", mimeType = "application/octet-stream")] private var TxtMap3:Class;
		[Embed(source = "../../../data/map4.txt", mimeType = "application/octet-stream")] private var TxtMap4:Class;
		[Embed(source="../../../data/tiles_all.png")] private var ImgTiles:Class;
		
		//major game objects
		private var _tilemap:FlxTilemap;
		private var _backmap:FlxTilemap;
		private var _spikes:Array;
		private var _bullets:Array;
		private var _player:Player;
		private var _sm_soldiers:Array;
		private var _restart:Number;
		
		function PlayStateTiles():void
		{
			super();
			_restart = 0;
			
			//create player and bullets
			_spikes = new Array();
			_bullets = new Array();
			_sm_soldiers = new Array();
			_player = new Player(0,0,_bullets);
			for(var i:uint = 0; i < 8; i++)
				_bullets.push(new Bullet());
			
			//add player and set up camera
			FlxG.follow(_player,2.5);
			FlxG.followAdjust(0.5, 0.0);
			
			//create tilemap

			changeLevel(0);
			
			//The music in this mode is positional - it fades out toward the edges of the level
			var s:FlxSound = FlxG.play(SndMode,1,true);
			s.proximity(320,320,_player,160);
		}

		override public function update():void
		{
			
			if(_player.dead)
			{
				_restart += FlxG.elapsed;
				if(_restart > 2){
					changeLevel(0);
					_restart = 0; 
				}
					
			}
			
			super.update();
			//game restart timer
			_tilemap.collideArray(_bullets);
			_tilemap.collide(_player);
			_tilemap.collideArray(_sm_soldiers);
			
			for each (var soldier:SmallSoldier in _sm_soldiers){
				if (soldier.overlaps(_player)) {
					_player.kill();
				}
			}
			for each (var spike:FlxSprite in _spikes){
				if (spike.overlaps(_player)) {
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
			
			
			if(FlxG.keys.justPressed("M"))
			{
				changeLevel(1);
				
			}
		}
		
		private function animationCallbackTest(Name:String, Frame:uint, FrameIndex:uint):void
		{
			FlxG.log("ANIMATION NAME: "+Name+", FRAME: "+Frame+", FRAME INDEX: "+FrameIndex);
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
			}else {
				trace("That map doesn't exist");
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
					var spike:FlxSprite = new FlxSprite(x_pos, y_pos - 1);
					spike.createGraphic(16, 16);
					
					_spikes.push(spike);
				}else if (tile > 18&& tile <= 23) {
					
					
					switch (tile) {
						
						case 21:
							//spawn small soldier
							_sm_soldiers.push(new SmallSoldier(x_pos, y_pos - 32, _player, _tilemap));
							break;	
						case 22:
							//spawn small soldier
							_sm_soldiers.push(new SmallSoldier(x_pos, y_pos - 32, _player, _tilemap));
							break;
						case 23:
							player_spawn_x = x_pos;
							player_spawn_y = y_pos - 32;
							break;
						case 24:
							//TODO: make an exit
							break;
						default:
							trace("Shouldn't be here");
							break;
					}
					// reset the tile to nothing
					_tilemap.setTileByIndex(i, 0);
					_backmap.setTileByIndex(i, 0);
				}else if (tile > 23) {
					
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
			
			FlxG.follow(_player,2.5);
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
			this.add(_player._gibs);
			this.add(_tilemap);
		}
		
		private function killObjects():void {
			
			while (_spikes.pop() != null) { }
			while (_sm_soldiers.pop() != null) {}
			
			this._layer.destroy();
			
			_player = new Player(0,0,_bullets);
			
		}
	}
}
