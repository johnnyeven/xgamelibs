package com.xgame.core.map
{
	import com.demonsters.debugger.MonsterDebugger;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.XMLLoader;
	import com.greensock.loading.core.LoaderCore;
	import com.greensock.loading.utils.LoaderUtils;
	import com.xgame.common.display.ActionDisplay;
	import com.xgame.common.pool.ResourcePool;
	import com.xgame.configuration.GlobalContextConfig;
	import com.xgame.configuration.MapContextConfig;
	import com.xgame.configuration.SocketContextConfig;
	import com.xgame.core.Camera;
	import com.xgame.core.center.ResourceCenter;
	import com.xgame.enum.Action;
	import com.xgame.events.map.MapEvent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class Map implements IEventDispatcher
	{
		private var _mapId: uint = 0;
		private var _astar: SilzAstar;
		private var _negativePath: Array;
		protected var _mapBuffer: BitmapData;
		protected var _mapDrawArea: Shape;
		private var _availableTileX: uint;
		private var _availableTileY: uint;
		private var _tileToLoad: Array;
		protected var _roadMap: BitmapData;
		protected var _roadScale: Number;
		protected var _alphaMap: BitmapData;
		protected var _mapLoopBg: BitmapData;
		protected var _currentStartX: uint;
		protected var _currentStartY: uint;
		protected var _smallMap: BitmapData;
		protected var _smallScale: Number;
		protected var _smallMapBuffer: BitmapData;
		protected static var _instance: Map;
		protected static var _allowInstance: Boolean = false;
		private var _loaderList: Vector.<LoaderCore>;
		private var _eventDispatcher: EventDispatcher;
		
		public function Map(mapId: uint)
		{
			if(!_allowInstance)
			{
				throw new IllegalOperationError("不能直接实例化");
				return;
			}
			_mapId = mapId;
			_eventDispatcher = new EventDispatcher(this);
			_loaderList = new Vector.<LoaderCore>();
		}
		
		public static function initilization(mapId: uint): Map
		{
			if(_instance == null)
			{
				_allowInstance = true;
				_instance = new Map(mapId);
				_allowInstance = false;
			}
			return _instance;
		}
		
		public static function get instance(): Map
		{
			return _instance;
		}
		
		public function dispose(): void
		{
			_instance = null;
			_eventDispatcher = null;
		}
		
		public function loadMapData(): void
		{
			ResourceCenter.instance.load(SocketContextConfig.resource_server_ip + GlobalContextConfig.MAP_RES_PATH + _mapId + '/config.xml', {}, onMapDataLoadComplete);
		}
		
		protected function onMapDataLoadComplete(evt: LoaderEvent): void
		{
			var _xmlLoader: XMLLoader = evt.target as XMLLoader;
			var _xml: XML = _xmlLoader.content as XML;
			
			if(int(_xml.id) != _mapId)
			{
				throw new IllegalOperationError("MapId与配置不一致");
				return;
			}
			else
			{
				MapContextConfig.MapSize.x = _xml.width;
				MapContextConfig.MapSize.y = _xml.height;
				
				MapContextConfig.TileNum.x = _xml.tileNumWidth;
				MapContextConfig.TileNum.y = _xml.tileNumHeight;
				
				MapContextConfig.TileSize.x = Math.floor(MapContextConfig.MapSize.x / MapContextConfig.TileNum.x);
				MapContextConfig.TileSize.y = Math.floor(MapContextConfig.MapSize.y / MapContextConfig.TileNum.y);
				
				MapContextConfig.BlockNum.x = _xml.blockNumWidth;
				MapContextConfig.BlockNum.y = _xml.blockNumHeight;
				
				MapContextConfig.BlockSize.x = Math.floor(MapContextConfig.MapSize.x / MapContextConfig.BlockNum.x);
				MapContextConfig.BlockSize.y = Math.floor(MapContextConfig.MapSize.y / MapContextConfig.BlockNum.y);
				
				_availableTileX = Math.ceil(GlobalContextConfig.Width / MapContextConfig.TileSize.x) + 2;
				_availableTileY = Math.ceil(GlobalContextConfig.Height / MapContextConfig.TileSize.y) + 2;
				
				Camera.instance.x = 0;
				Camera.instance.y = 0;
				
				loadRoadMap();
				loadAlphaMap();
				
				dispatchEvent(new MapEvent(MapEvent.MAP_DATA_COMPLETE));
			}
		}
		
		private function initializeAstar(): void
		{
			_astar = new SilzAstar(_negativePath);
		}
		
		private function resetNegativePath(): void
		{
			if(_negativePath != null)
			{
				_negativePath.splice(0, _negativePath.length);
				_negativePath = null
			}
			_negativePath = new Array();
			
			for(var y: int = 0; y < MapContextConfig.BlockNum.x; y++)
			{
				var temp: Array = new Array();
				for(var x: int = 0; x < MapContextConfig.BlockNum.y; x++)
				{
					temp.push(true);
				}
				_negativePath.push(temp);
			}
		}
		
		protected function loadRoadMap(): void
		{
			var url: String = SocketContextConfig.resource_server_ip + GlobalContextConfig.MAP_RES_PATH + _mapId + "/road.png";
			ResourceCenter.instance.load(url, {}, onRoadMapLoadComplete);
		}
		
		private function onRoadMapLoadComplete(evt: LoaderEvent): void
		{
			resetNegativePath();
			_roadMap = ((evt.currentTarget as ImageLoader).rawContent as Bitmap).bitmapData;
			
			_roadScale = _roadMap.width / MapContextConfig.MapSize.x;
			
			for(var y: int = 0; y < MapContextConfig.BlockNum.x; y++)
			{
				for(var x: int = 0; x < MapContextConfig.BlockNum.y; x++)
				{
					_negativePath[y][x] = _roadMap.getPixel32(int(MapContextConfig.BlockSize.x * x * _roadScale), int(MapContextConfig.BlockSize.y * y * _roadScale)) == 0x00000000 ? true : false;
				}
			}
			initializeAstar();
		}
		
		protected function loadAlphaMap(): void
		{
			var url: String = SocketContextConfig.resource_server_ip + GlobalContextConfig.MAP_RES_PATH + _mapId + "/alpha.png";
			ResourceCenter.instance.load(url, {}, onAlphaMapLoadComplete);
		}
		
		private function onAlphaMapLoadComplete(evt: LoaderEvent): void
		{
			if(_alphaMap != null)
			{
				_alphaMap.dispose();
				_alphaMap = null;
			}
			
			_alphaMap = ((evt.currentTarget as ImageLoader).rawContent as Bitmap).bitmapData;
		}
		
		public function initializeBuffer(): void
		{
			_mapBuffer = new BitmapData(
				GlobalContextConfig.Width + 2 * MapContextConfig.TileSize.x,
				GlobalContextConfig.Height + 2 * MapContextConfig.TileSize.y,
				false
			);
		}
		
		public function prepareMap(): void
		{
			var _smallMapPath: String = SocketContextConfig.resource_server_ip +
				GlobalContextConfig.MAP_RES_PATH +
				_mapId + '/thumbnail.jpg';
			ResourceCenter.instance.load(_smallMapPath, {}, onSmallMapComplete);
		}
		
		private function onSmallMapComplete(evt: LoaderEvent): void
		{
			_smallMap = ((evt.target as ImageLoader).rawContent as Bitmap).bitmapData;
			
			_smallScale = _smallMap.width / MapContextConfig.MapSize.x;
			_smallMapBuffer = new BitmapData(_mapBuffer.width * _smallScale, _mapBuffer.height * _smallScale, false, 0);
			
			update(true);
		}
		
		public function getWorldPosition(x: Number, y: Number): Point
		{
			var _returnPoint: Point = new Point();
			_returnPoint.x = Camera.instance.x + x;
			_returnPoint.y = Camera.instance.y + y;
			
			return _returnPoint;
		}
		
		public function getScreenPosition(x: Number, y: Number): Point
		{
			var _returnPoint: Point = new Point();
			_returnPoint.x = x - Camera.instance.x;
			_returnPoint.y = y - Camera.instance.y;
			
			return _returnPoint;
		}
		
		public function block2WorldPosition(x: Number, y: Number): Point
		{
			var _returnPoint: Point = new Point();
			_returnPoint.x = (x + .5) * MapContextConfig.BlockSize.x;
			_returnPoint.y = (y + .5) * MapContextConfig.BlockSize.y;
			
			return _returnPoint;
		}
		
		public function worldPosition2Block(x: Number, y: Number): Point
		{
			var _returnPoint: Point = new Point();
			_returnPoint.x = int(x / MapContextConfig.BlockSize.x);
			_returnPoint.y = int(y / MapContextConfig.BlockSize.y);
			
			return _returnPoint;
		}
		
		public function worldPosition2Tile(x: Number, y: Number): Point
		{
			var _returnPoint: Point = new Point();
			_returnPoint.x = int(x / MapContextConfig.TileSize.x);
			_returnPoint.y = int(y / MapContextConfig.TileSize.y);
			
			return _returnPoint;
		}
		
		public function update(force: Boolean = false): void
		{
			if(Camera.instance.focus != null && !force)
			{
				if(Camera.instance.focus is ActionDisplay)
				{
					if((Camera.instance.focus as ActionDisplay).action == Action.STOP)
					{
						return;
					}
				}
				else
				{
					return;
				}
			}
			_mapDrawArea.x = -(Camera.instance.x % MapContextConfig.TileSize.x);
			_mapDrawArea.y = -(Camera.instance.y % MapContextConfig.TileSize.y);
			
			var _startPoint : Point = worldPosition2Tile(Camera.instance.x, Camera.instance.y);
			var _startX: int = _startPoint.x;
			var _startY: int = _startPoint.y;
			if(_currentStartX == _startX && _currentStartY == _startPoint.y && !force)
			{
				return;
			}
			
			prepareBlock(_startX, _startY, force);
			
			_currentStartX = _startX;
			_currentStartY = _startY;
		}
		
		protected function prepareBlock(startX: int = -1, startY: int = -1, force: Boolean = false): void
		{
			if(startX == -1 || startY == -1)
			{
				startX = int(Camera.instance.x / MapContextConfig.TileSize.x);
				startY = int(Camera.instance.y / MapContextConfig.TileSize.y);
			}
			
			if(_currentStartX == startX && _currentStartY == startY && !force)
			{
				return;
			}
			
			drawSmallMap(startX, startY);
			if(_tileToLoad != null)
			{
				_tileToLoad.splice(0, _tileToLoad.length);
			}
			_tileToLoad = new Array();
			
			var maxBlockX: int = Math.min(MapContextConfig.TileNum.x, startX + _availableTileX);
			var maxBlockY: int = Math.min(MapContextConfig.TileNum.y, startY + _availableTileY);
			for(var j: int = startY; j < maxBlockY; j++)
			{
				var tempPos: Array = new Array();
				for(var i: int = startX; i < maxBlockX; i++)
				{
					tempPos.push(j + "_" + i);
				}
				_tileToLoad.push(tempPos);
			}
			loadTiles();
		}
		
		protected function drawSmallMap(startX: int, startY: int): void
		{
			if(_smallMap != null && _smallMapBuffer != null)
			{
				_smallMapBuffer.fillRect(_smallMapBuffer.rect, 0);
				var rect: Rectangle = new Rectangle(
					startX * MapContextConfig.TileSize.x * _smallScale,
					startY * MapContextConfig.TileSize.y * _smallScale,
					_smallMapBuffer.width,
					_smallMapBuffer.height
				);
				_smallMapBuffer.copyPixels(_smallMap, rect, new Point());
				
				var per: Number = 1 / _smallScale;
				_mapBuffer.draw(_smallMapBuffer, new Matrix(per, 0, 0, per));
			}
		}
		
		protected function loadTiles(): void
		{
			if(_tileToLoad == null)
			{
				return;
			}
			_mapDrawArea.cacheAsBitmap = false;
			CONFIG::DebugMode
			{
				MonsterDebugger.trace(this, _tileToLoad);
			}
			var _bm: BitmapData;
			var _temp: Array;
			for(var i: int = 0; i < _tileToLoad.length; i++)
			{
				for(var j: int = 0; j < _tileToLoad[i].length; j++)
				{
					_bm = ResourcePool.instance.get(_mapId + "_" + _tileToLoad[i][j]) as BitmapData;
					_temp = _tileToLoad[i][j].split("_");
					if(_bm != null)
					{
						//缓存中存在，直接Copy
						var _point: Point = new Point(j * MapContextConfig.TileSize.x, i * MapContextConfig.TileSize.y);
						_mapBuffer.copyPixels(_bm, _bm.rect, _point);
					}
					else
					{
						var options: Object = {
							positionX: int(_temp[1]),
							positionY: int(_temp[0])
						};
						var _loader: LoaderCore = LoaderUtils.generateLoader(SocketContextConfig.resource_server_ip + GlobalContextConfig.MAP_RES_PATH + _mapId + '/assets/' + _tileToLoad[i][j] + '.jpg');
						_loader.autoDispose = true;
						_loader.vars = options;
						_loaderList.push(_loader);
					}
				}
			}
			
			startLoad();
		}
		
		protected function startLoad(): void
		{
			if(_loaderList.length == 0)
			{
				return;
			}
			var _loader: LoaderCore = _loaderList[0];
			_loader.addEventListener(LoaderEvent.COMPLETE, onTileLoadComplete);
			_loader.load();
			_loaderList.splice(0, 1);
		}
		
		protected function onTileLoadComplete(evt: LoaderEvent): void
		{
			var _loader: LoaderCore = evt.currentTarget as LoaderCore;
			_loader.removeEventListener(LoaderEvent.COMPLETE, onTileLoadComplete);
			if(_loader is ImageLoader)
			{
				var _options: Object = (_loader as ImageLoader).vars;
				var _bm: BitmapData = ((_loader as ImageLoader).rawContent as Bitmap).bitmapData;
				ResourcePool.instance.add(_mapId + "_" + _options.positionY + "_" + _options.positionX, _bm);
				
				var _point: Point = new Point((_options.positionX - _currentStartX) * MapContextConfig.TileSize.x, (_options.positionY - _currentStartY) * MapContextConfig.TileSize.y);
				_mapBuffer.copyPixels(_bm, _bm.rect, _point);
			}
			_loader.unload();
			_loader.dispose();
			_loader = null;
			if(_loaderList.length > 0)
			{
				startLoad();
			}
			else
			{
				_mapDrawArea.cacheAsBitmap = true;
				dispatchEvent(new MapEvent(MapEvent.COMPLETE));
			}
		}
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			_eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			_eventDispatcher.removeEventListener(type, listener, useCapture);
		}
		
		public function dispatchEvent(event:Event):Boolean
		{
			return _eventDispatcher.dispatchEvent(event);
		}
		
		public function hasEventListener(type:String):Boolean
		{
			return _eventDispatcher.hasEventListener(type);
		}
		
		public function willTrigger(type:String):Boolean
		{
			return _eventDispatcher.willTrigger(type);
		}

		public function get mapId():uint
		{
			return _mapId;
		}

		public function get mapDrawArea():Shape
		{
			return _mapDrawArea;
		}
		
		public function get astar():SilzAstar
		{
			return _astar;
		}
		
		public function get negativePath():Array
		{
			return _negativePath;
		}

		public function set mapDrawArea(value:Shape):void
		{
			_mapDrawArea = value;
			_mapDrawArea.graphics.beginBitmapFill(_mapBuffer);
			_mapDrawArea.graphics.drawRect(0, 0, _mapBuffer.width, _mapBuffer.height);
			_mapDrawArea.graphics.endFill();
		}


	}
}