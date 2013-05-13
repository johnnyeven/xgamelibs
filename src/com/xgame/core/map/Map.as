package com.xgame.core.map
{
	import com.xgame.configuration.MapContextConfig;
	import com.xgame.core.Camera;
	
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
		protected var _currentStartX: uint;	//prepareLoadData
		protected var _currentStartY: uint;
		protected var _smallMap: BitmapData;
		protected var _smallMapBuffer: BitmapData;
		protected static var _instance: Map;
		protected static var _allowInstance: Boolean = false;
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