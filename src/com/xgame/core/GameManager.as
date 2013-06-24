package com.xgame.core
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	
	import com.xgame.liteui.core.Component;
	import com.xgame.utils.MenuManager;
	
	public class GameManager extends Component
	{
		private var _backLayer: Sprite;
		private var _baseLayer: Sprite;
		private var _viewLayer: Sprite;
		private var _popUpLayer: Sprite;
		private var _toolTipLayer: Sprite;
		private var _infoLayer: Sprite;
		private static var _setRoot: Boolean = false;
		private static var _root: Stage;
		private static var _allowInstance: Boolean = false;
		private static var _instance: GameManager;
		
		public function GameManager()
		{
			super(null);
			if(_instance != null)
			{
				throw new IllegalOperationError("不能实例化GameManager类");
			}
			_instance = this;
			_backLayer = new Sprite();
			_baseLayer = new Sprite();
			_viewLayer = new Sprite();
			_popUpLayer = new Sprite();
			_toolTipLayer = new Sprite();
			_infoLayer = new Sprite();
			addChild(_backLayer);
			addChild(_baseLayer);
			addChild(_viewLayer);
			addChild(_popUpLayer);
			addChild(_toolTipLayer);
			addChild(_infoLayer);
			addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
		}
		
		private function onAddToStage(evt: Event): void
		{
			container = stage;
			container.addEventListener(Event.RESIZE, onStageResize);
		}
		
		protected function onStageResize(evt: Event): void
		{
			MenuManager.updateModeTransparencySize();
		}
		
		public function addBack(target: DisplayObject): void
		{
			_backLayer.addChild(target);
		}
		
		public function removeBack(target: DisplayObject): void
		{
			if(_backLayer.contains(target))
			{
				_backLayer.removeChild(target);
			}
		}
		
		public function addBase(target: DisplayObject): void
		{
			_baseLayer.addChild(target);
		}
		
		public function removeBase(target: DisplayObject): void
		{
			if(_baseLayer.contains(target))
			{
				_baseLayer.removeChild(target);
			}
		}
		
		public function addView(target: DisplayObject): void
		{
			_viewLayer.addChild(target);
		}
		
		public function removeView(target: DisplayObject): void
		{
			if(_viewLayer.contains(target))
			{
				_viewLayer.removeChild(target);
			}
		}
		
		public function addPopUp(target: DisplayObject): void
		{
			_popUpLayer.addChild(target);
		}
		
		public function removePopUp(target: DisplayObject): void
		{
			if(_popUpLayer.contains(target))
			{
				_popUpLayer.removeChild(target);
			}
		}
		
		public function addToolTip(target: DisplayObject): void
		{
			_toolTipLayer.addChild(target);
		}
		
		public function removeToolTip(target: DisplayObject): void
		{
			if(_toolTipLayer.contains(target))
			{
				_toolTipLayer.removeChild(target);
			}
		}
		
		public function addInfo(target: DisplayObject): void
		{
			_infoLayer.addChild(target);
		}
		
		public function removeInfo(target: DisplayObject): void
		{
			if(_infoLayer.contains(target))
			{
				_infoLayer.removeChild(target);
			}
		}
		
		public static function get instance(): GameManager
		{
//			if(_instance == null)
//			{
//				_allowInstance = true;
//				_instance = new GameManager();
//				_allowInstance = false;
//			}
			return _instance;
		}
		
		public static function set container(value: Stage): void
		{
			if(!_setRoot)
			{
				_root = value;
				_setRoot = true;
			}
		}
		
		public static function get container(): Stage
		{
			return _root;
		}
		
		public function get backLayer(): Sprite
		{
			return _backLayer;
		}

		public function get baseLayer(): Sprite
		{
			return _baseLayer;
		}

		public function get popUpLayer():Sprite
		{
			return _popUpLayer;
		}

		public function get viewLayer():Sprite
		{
			return _viewLayer;
		}

		public function get toolTipLayer():Sprite
		{
			return _toolTipLayer;
		}

		public function get infoLayer():Sprite
		{
			return _infoLayer;
		}


	}
}