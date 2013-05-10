package com.xgame.core.scene
{
	import com.xgame.common.display.BitmapDisplay;
	import com.xgame.common.display.BitmapMovieDispaly;
	import com.xgame.configuration.GlobalContextConfig;
	import com.xgame.core.Camera;
	import com.xgame.ns.NSCamera;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.errors.IllegalOperationError;
	import flash.utils.getTimer;

	public class Scene
	{
		protected var _objectList: Array;
		protected var _renderList: Array;
		//protected var _map: WorldMap;
		protected var _mapGround: Shape;
		protected var _stage: Stage;
		protected var _initialized: Boolean = false;
		protected var _player: BitmapMovieDispaly;
		protected var _container: DisplayObjectContainer;
		protected var _layerEffect: Sprite;
		private var _lastZSortTime: uint;
		private var _currentRenderIndex: uint = 0;
		private static const ZSORT_DELAY: uint = 1000;
		private static const RENDER_MAX_TIME: uint = 15;
		
		public function Scene(stage: Stage, container: DisplayObjectContainer = null)
		{
			if(stage == null)
			{
				throw new IllegalOperationError("stage参数必须指定舞台");
			}
			_stage = stage;
			_container = container == null ? stage : container;
			
			_objectList = new Array();
			_renderList = new Array();
			
			_layerEffect = new Sprite();
			_container.addChild(_layerEffect);
			
			initializeBuffer();
		}
		
		public function initializeBuffer(): void
		{
			_mapGround = new Shape();
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
			_container.addChild(value);
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
			
			if(_container.contains(value))
			{
				_container.removeChild(value);
				value.NSCamera::inScene = false;
				value.NSCamera::shadeOut();
			}
		}
		
		public function getDisplay(value: uint): BitmapDisplay
		{
			if(value > _objectList.length)
			{
				return null;
			}
			return _objectList[value] as BitmapDisplay;
		}
		
		public function get objectList(): Array
		{
			return _objectList;
		}
		
		public function get stage(): Stage
		{
			return _stage;
		}
		
		public function get initialized(): Boolean
		{
			return _initialized;
		}
		
		public function get container(): DisplayObjectContainer
		{
			return _container;
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
//			_map.update();
			
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
					if(max < _container.numChildren)
					{
						child = _container.getChildAt(max);
						item = _renderList[max];
						
						if(child != item && _container.contains(item))
						{
							_container.setChildIndex(item, max);
						}
					}
				}
				
				_container.setChildIndex(_mapGround, 0);
				_lastZSortTime = GlobalContextConfig.Timer;
				
				this.NSCamera::cut();
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
			Camera.instance.update();
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
	}
}