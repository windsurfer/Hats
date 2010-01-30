package com.adamatomic.Mode
{
	import org.flixel.*;

	public class PlayStateTiles extends FlxState
	{
		[Embed(source="../../../data/mode.mp3")] private var SndMode:Class;
		[Embed(source="../../../data/map.txt",mimeType="application/octet-stream")] private var TxtMap:Class;
		[Embed(source = "../../../data/map2.txt", mimeType = "application/octet-stream")] private var TxtMap2:Class;
		[Embed(source = "../../../data/map3.txt", mimeType = "application/octet-stream")] private var TxtMap3:Class;
		[Embed(source = "../../../data/map4.txt", mimeType = "application/octet-stream")] private var TxtMap4:Class;
		[Embed(source="../../../data/tiles_all.png")] private var ImgTiles:Class;
		
		//major game objects
		private var _tilemap:FlxTilemap;
		private var _bullets:Array;
		private var _player:Player;
		private var _sm_soldiers:Array;
		
		function PlayStateTiles():void
		{
			super();

			
			//create player and bullets
			_bullets = new Array();
			_sm_soldiers = new Array();
			_player = new Player(0,0,_bullets);
			_player.addAnimationCallback(animationCallbackTest);
			for(var i:uint = 0; i < 8; i++)
				_bullets.push(new Bullet());
			
			//add player and set up camera
			FlxG.follow(_player,2.5);
			FlxG.followAdjust(0.5, 0.0);
			
			//create tilemap

			changeLevel(3);
			
			_tilemap.follow();	//Set the followBounds to the map dimensions
						
			//add tilemap last so it is in front, looks neat
			
			//The music in this mode is positional - it fades out toward the edges of the level
			var s:FlxSound = FlxG.play(SndMode,1,true);
			s.proximity(320,320,_player,160);
		}

		override public function update():void
		{
			super.update();
			_tilemap.collideArray(_bullets);
			_tilemap.collide(_player);
			_tilemap.collideArray(_sm_soldiers);
			
			for each (var soldier:SmallSoldier in _sm_soldiers){
				if (soldier.overlaps(_player)) {
					_player.kill();
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
		
		private function dig(Core:FlxCore,X:uint,Y:uint,Tile:uint):void
		{
			if(Core is Bullet)
				_tilemap.setTile(X,Y,0);
		}
		private function changeLevel(Level:int):void {	
			this._layer.destroy();
			//_sm_soldiers.destroy();
			
			_tilemap = new FlxTilemap();
			_tilemap.collideIndex = 3;			
			
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
			_tilemap.loadMap(MapData, ImgTiles, 16); //This is an alternate tiny map
			
			
			var player_spawn_x:int = -1;
			var player_spawn_y:int = -1;
			
			for (var i:uint = 0; i < _tilemap.totalTiles; i++) {
				var tile:uint = _tilemap.getTileByIndex(i);
				if (tile > 20) {
					
					var x_pos:int = i % _tilemap.widthInTiles * 16;
					var y_pos:int = i / _tilemap.widthInTiles * 16;
					
					switch (tile){
						case 21:
							//spawn small soldier
							_sm_soldiers.push(new SmallSoldier(x_pos, y_pos - 32, _player, _tilemap));
							break;
						case 22:
							player_spawn_x = x_pos;
							player_spawn_y = y_pos - 32;
							break;
						case 23:
							//TODO: make an exit
							break;
						default:
							trace("Shouldn't be here");
							break;
					}
					// reset the tile to nothing
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
			
			_tilemap.setCallback(3,dig,8);
			FlxG.flash(0xff131c1b);
			
			
			//center Map
			var fx:uint = _tilemap.width/2 - FlxG.width/2;
			var fy:uint = _tilemap.height/2 - FlxG.height/2;
			FlxG.followBounds(fx,fy,fx,fy);
			_tilemap.follow();
			_tilemap.setCallback(3,dig,8);
			
			addObjects();

		}
		
		private function addObjects():void {
			for(var i:uint = 0; i < 8; i++)
				this.add(_bullets[i]);
			for each (var soldier:SmallSoldier in _sm_soldiers){
				this.add(soldier);
			}
							
			this.add(_player);
			this.add(_tilemap);
		}
	}
}
