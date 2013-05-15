package com.xgame.core.map
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.core.LoaderCore;
	import com.greensock.loading.utils.LoaderUtils;
	import com.xgame.common.pool.ResourcePool;
	import com.xgame.configuration.GlobalContextConfig;
	import com.xgame.configuration.MapContextConfig;
	import com.xgame.configuration.SocketContextConfig;
	import com.xgame.core.Camera;
	import com.xgame.core.center.ResourceCenter;
	import com.xgame.enum.Action;
	
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	
	public class Map implements IEventDispatcher
	{
		private var _mapId: uint = 0;
		private var _astar: SilzAstar;
		private var _negativePath: Array;
		protected var _mapBuffer: BitmapData;
		protected var _mapDrawArea: Shape;
		private var _availableBlockX: uint;
		private var _availableBlockY: uint;
		private var _tileToLoad: Array;
		private var _returnPoint: Point;
		protected var _roadMap: BitmapData;
		protected var _roadScale: Number;
		protected var _mapLoopBg: BitmapData;
		protected var _currentStartX: uint;
		protected var _currentStartY: uint;
		protected var _smallMap: BitmapData;
		protected var _smallMapBuffer: BitmapData;
		protected static var _instance: Map;
		protected static var _allowInstance: Boolean = false;
		private var _loaderList: Vector.<LoaderCore>;
		private var _eventDispatcher: EventDispatcher;
		
		public function Map()
		{
			if(!_allowInstance)
			{
				throw new IllegalOperationError("不能直接实例化");
				return;
			}
			_eventDispatcher = new EventDispatcher(this);
			_returnPoint = new Point();
			_loaderList = new Vector.<LoaderCore>();
		}
		
		public static function get instance(): Map
		{
			if(_instance == null)
			{
				_allowInstance = true;
				_instance = new Map();
				_allowInstance = false;
			}
			return _instance;
		}
		
		public function dispose(): void
		{
			_instance = null;
			_returnPoint = null;
			_eventDispatcher = null;
		}
		
		public function loadMapData(): void
		{
			
		}
		
		protected function onMapDataLoadComplete(evt: LoaderEvent): void
		{
			
		}
		
		public function getWorldPosition(x: Number, y: Number): Point
		{
			_returnPoint.x = Camera.instance.x + x;
			_returnPoint.y = Camera.instance.y + y;
			
			return _returnPoint;
		}
		
		public function getScreenPosition(x: Number, y: Number): Point
		{
			_returnPoint.x = x - Camera.instance.x;
			_returnPoint.y = y - Camera.instance.y;
			
			return _returnPoint;
		}
		
		public function block2WorldPosition(x: Number, y: Number): Point
		{
			_returnPoint.x = (x + .5) * MapContextConfig.TileSize.x;
			_returnPoint.y = (y + .5) * MapContextConfig.TileSize.y;
			
			return _returnPoint;
		}
		
		public function worldPosition2Block(x: Number, y: Number): Point
		{
			_returnPoint.x = int(x / MapContextConfig.TileSize.x);
			_returnPoint.y = int(y / MapContextConfig.TileSize.y);
			
			return _returnPoint;
		}
		
		public function update(force: Boolean = false): void
		{
			if(Camera.instance.focus != null && Camera.instance.focus.action == Action.STOP && !force)
			{
				return;
			}
			var _startPoint : Point = worldPosition2Block(Camera.instance.x, Camera.instance.y);
			
			prepareBlock(_startPoint.x, _startPoint.y, force);
			
			if(_currentStartX == _startPoint.x && _currentStartX == _startPoint.y && !force)
			{
				return;
			}
			_mapDrawArea.x = -(Camera.instance.x % MapContextConfig.TileSize.x);
			_mapDrawArea.y = -(Camera.instance.y % MapContextConfig.TileSize.y);
			
			_currentStartX = _startPoint.x;
			_currentStartY = _startPoint.y;
		}
		
		protected function prepareBlock(startX: int = -1, startY: int = -1, force: Boolean = false): void
		{
			if(startX == -1 || startY == -1)
			{
				startX = int(Camera.instance.x / MapContextConfig.TileSize.x);
				startY = int(Camera.instance.y / MapContextConfig.TileSize.y);
			}
			
			if(_currentStartX == startX && _currentStartX == startY && !force)
			{
				return;
			}
			
			//drawSmallMap(startX, startY);
			if(_tileToLoad != null)
			{
				_tileToLoad.splice(0, _tileToLoad.length);
			}
			_tileToLoad = new Array();
			
			var maxBlockX: int = Math.min(MapContextConfig.TileNum.x, startX + _availableBlockX);
			var maxBlockY: int = Math.min(MapContextConfig.TileNum.y, startY + _availableBlockY);
			for(var i: int = startX; i < maxBlockX; i++)
			{
				var tempPos: Array = new Array();
				for(var j: int = startY; j < maxBlockY; j++)
				{
					tempPos.push(i + "_" + j);
				}
				_tileToLoad.push(tempPos);
			}
			loadTiles();
		}
		
		protected function loadTiles(): void
		{
			if(_tileToLoad == null)
			{
				return;
			}
			_mapDrawArea.cacheAsBitmap = false;
			
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
						_returnPoint.x = int(_temp[0]) * MapContextConfig.TileSize.x;
						_returnPoint.y = int(_temp[1]) * MapContextConfig.TileSize.y;
						_mapBuffer.copyPixels(_bm, _bm.rect, _returnPoint);
					}
					else
					{
						var options: Object = {
							positionX: int(_temp[0]),
							positionY: int(_temp[1])
						};
						var _loader: LoaderCore = LoaderUtils.generateLoader(SocketContextConfig.resource_server_ip + GlobalContextConfig.MAP_RES_PATH + _mapId + '/assets/' + _tileToLoad[i][j] + '.jpg');
						_loader.vars = options;
						_loaderList.push(_loader);
						//ResourceCenter.instance.load(SocketContextConfig.resource_server_ip + GlobalContextConfig.MAP_RES_PATH + _mapId + '/' + _tileToLoad[i][j] + '.jpg', options, onTileLoadComplete);
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
			var _loader: LoaderCore = evt.target as LoaderCore;
			if(_loader is ImageLoader)
			{
				var _options: Object = (_loader as ImageLoader).vars;
				var _bm: BitmapData = (_loader as ImageLoader).rawContent;
				ResourcePool.instance.add(_mapId + "_" + _options.positionX + "_" + _options.positionY, _bm);
				
				_returnPoint.x = _options.positionX * MapContextConfig.TileSize.x;
				_returnPoint.y = _options.positionY * MapContextConfig.TileSize.y;
				_mapBuffer.copyPixels(_bm, _bm.rect, _returnPoint);
			}
			if(_loaderList.length > 0)
			{
				startLoad();
			}
			else
			{
				_mapDrawArea.cacheAsBitmap = true;
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
	}
}