package com.xgame.core.scene
{
	import com.xgame.common.display.ActionDisplay;
	import com.xgame.common.display.BitmapDisplay;
	import com.xgame.common.display.CharacterDisplay;
	import com.xgame.configuration.GlobalContextConfig;
	import com.xgame.core.Camera;
	import com.xgame.core.map.Map;
	import com.xgame.events.map.MapEvent;
	import com.xgame.events.scene.SceneEvent;
	import com.xgame.ns.NSCamera;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.getTimer;

	public class Scene implements IEventDispatcher
	{
		protected var _objectList: Array;
		protected var _renderList: Array;
		protected var _map: Map;
		protected var _mapGround: Shape;
		protected var _stage: Stage;
		protected var _initialized: Boolean = false;
		protected var _ready: Boolean = false;
		protected var _player: CharacterDisplay;
		protected var _container: DisplayObjectContainer;
		protected var _layerDisplay: Sprite;
		protected var _layerEffect: Sprite;
		private var _lastZSortTime: uint;
		private var _currentRenderIndex: uint = 0;
		private var _eventDispatcher: EventDispatcher;
		private static const ZSORT_DELAY: uint = 1000;
		private static const RENDER_MAX_TIME: uint = 15;
		private static var _instance: Scene;
		private static var _allowInstance: Boolean = false;
		
		public function Scene(stage: Stage, container: DisplayObjectContainer = null)
		{
			if(_allowInstance)
			{
				if(stage == null)
				{
					throw new IllegalOperationError("stage参数必须指定舞台");
				}
				_stage = stage;
				_container = container == null ? stage : container;
				_eventDispatcher = new EventDispatcher(this);
				
				_objectList = new Array();
				_renderList = new Array();
				
				_layerDisplay = new Sprite();
				_layerEffect = new Sprite();
				_container.addChild(_layerDisplay);
				_container.addChild(_layerEffect);
				
				initializeBuffer();
				_initialized = true;
			}
			else
			{
				throw new IllegalOperationError("不允许实例化这个类");
			}
		}
		
		public static function initialization(stage: Stage, container: DisplayObjectContainer = null): Scene
		{
			if(_instance == null)
			{
				_allowInstance = true;
				_instance = new Scene(stage, container);
				_allowInstance = false;
			}
			return _instance;
		}
		
		public static function get instance(): Scene
		{
			return _instance;
		}
		
		public function initializeBuffer(): void
		{
			_mapGround = new Shape();
		}
		
		public function initializeMap(mapId: uint): void
		{
			_map = Map.initilization(mapId);
			_map.addEventListener(MapEvent.MAP_DATA_COMPLETE, onMapDataComplete);
			_map.loadMapData();
		}
		
		private function onMapDataComplete(evt: MapEvent): void
		{
			_map.initializeBuffer();
			_map.mapDrawArea = _mapGround;
			_map.addEventListener(MapEvent.COMPLETE, onMapComplete);
			_map.prepareMap();
		}
		
		private function onMapComplete(evt: MapEvent): void
		{
			GlobalContextConfig.Timer = getTimer();
			dispatchEvent(new SceneEvent(SceneEvent.SCENE_READY));
			_container.addChild(_mapGround);
			_container.setChildIndex(_mapGround, 0);
			_ready = true;
		}
		
		public function addObject(value: BitmapDisplay): void
		{
			if(_objectList.indexOf(value) > -1)
			{
				return;
			}
			_objectList.push(value);
			if(Camera.instance.cameraView.contains(value.positionX, value.positionY))
			{
				pushRenderList(value);
			}
		}
		
		public function removeObject(value: BitmapDisplay): void
		{
			var index: int = _objectList.indexOf(value);
			if(index > -1)
			{
				_objectList.splice(index, 1);
			}
			pullRenderList(value);
			value.dispose();
			value = null;
		}
		
		public function pushRenderList(value: BitmapDisplay): void
		{
			if(_renderList.indexOf(value) > -1)
			{
				return;
			}
			_renderList.push(value);
			_layerDisplay.addChild(value);
			value.NSCamera::inScene = true;
			value.NSCamera::shadeIn();
		}
		
		public function pullRenderList(value: BitmapDisplay): void
		{
			var index: int = _renderList.indexOf(value);
			if(index > -1)
			{
				_renderList.splice(index, 1);
			}
			
			if(_layerDisplay.contains(value))
			{
				_layerDisplay.removeChild(value);
				value.NSCamera::inScene = false;
				value.NSCamera::shadeOut();
			}
		}
		
		public function getDisplay(value: uint): BitmapDisplay
		{
			if(value >= _objectList.length)
			{
				return null;
			}
			return _objectList[value] as BitmapDisplay;
		}
		
		public function get objectList(): Array
		{
			return _objectList;
		}
		
		public function get renderList():Array
		{
			return _renderList;
		}
		
		public function get stage(): Stage
		{
			return _stage;
		}
		
		public function get initialized(): Boolean
		{
			return _initialized;
		}
		
		public function get ready():Boolean
		{
			return _ready;
		}
		
		public function get container(): DisplayObjectContainer
		{
			return _container;
		}
		
		public function set player(value: CharacterDisplay): void
		{
			_player = value;
		}
		
		public function get player(): CharacterDisplay
		{
			return _player;
		}
		
		public function update(): void
		{
			updateTimer();
			step();
		}
		
		protected function updateTimer(): void
		{
			GlobalContextConfig.Timer = getTimer();
		}
		
		protected function step(): void
		{
			var _child: BitmapDisplay;
			Camera.instance.update();
			_map.update();
			
			if(_objectList.length == 0)
			{
				return;
			}
			
			for each(_child in _objectList)
			{
				if(_child != null)
				{
					_child.updateController();
				}
			}
			var item: BitmapDisplay;
			
			if(GlobalContextConfig.Timer - _lastZSortTime > ZSORT_DELAY)
			{
				_renderList.sortOn("zIndex", Array.NUMERIC);
				
				var max: uint = _renderList.length;
				var child: DisplayObject;
				
				while(max--)
				{
					if(max < _layerDisplay.numChildren)
					{
						child = _layerDisplay.getChildAt(max);
						item = _renderList[max];
						
						if(child != item && _layerDisplay.contains(item))
						{
							_layerDisplay.setChildIndex(item, max);
						}
					}
				}
				
				_lastZSortTime = GlobalContextConfig.Timer;
			}
			else if(Camera.NSCamera::needCut)
			{
				this.NSCamera::cut();
			}
			
			
			while(true)
			{
				if(_currentRenderIndex >= _renderList.length)
				{
					_currentRenderIndex = 0;
					break;
				}
				item = _renderList[_currentRenderIndex];
				if(item == null)
				{
					_currentRenderIndex = 0;
					break;
				}
				item.update();
				_currentRenderIndex++;
				
				if(getTimer() - GlobalContextConfig.Timer > RENDER_MAX_TIME)
				{
					break;
				}
			}
		}
		
		NSCamera function cut(): void
		{
			var item: BitmapDisplay;
			for each(item in _objectList)
			{
				if(Camera.instance.cameraView.contains(item.positionX, item.positionY))
				{
					pushRenderList(item);
				}
				else
				{
					pullRenderList(item);
				}
			}
			Camera.NSCamera::needCut = false;
		}
		
		public function dispose(): void
		{
			_objectList.splice(0, _objectList.length);
			
			while(_layerDisplay.numChildren > 0)
			{
				_layerDisplay.removeChildAt(0);
			}
			while(_layerEffect.numChildren > 0)
			{
				_layerEffect.removeChildAt(0);
			}
			while(_container.numChildren > 0)
			{
				_container.removeChildAt(0);
			}
			
			_mapGround.graphics.clear();
			_mapGround = null;
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