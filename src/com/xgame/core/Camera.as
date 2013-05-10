package com.xgame.core
{
	import com.xgame.common.display.BitmapDisplay;
	import com.xgame.configuration.GlobalContextConfig;
	import com.xgame.configuration.MapContextConfig;
	import com.xgame.core.scene.Scene;
	import com.xgame.ns.NSCamera;
	
	import flash.errors.IllegalOperationError;
	import flash.geom.Rectangle;

	public class Camera
	{
		private static var _instance: Camera;
		private static var _allowInstance: Boolean = false;
		private var _cameraView: Rectangle;
		private var _cameraCutView: Rectangle;
		protected var _x: Number;
		protected var _y: Number;
		protected var _scene: Scene;
		protected var _focus: BitmapDisplay;
		NSCamera static var needCut: Boolean = false;
		
		public function Camera(value: Scene)
		{
			if(!_allowInstance)
			{
				throw new IllegalOperationError("不能直接实例化");
				return;
			}
			_scene = value;
			_cameraView = new Rectangle();
			_cameraCutView = new Rectangle();
		}
		
		public static function initialization(value: Scene): Camera
		{
			if(_instance == null)
			{
				_allowInstance = true;
				_instance = new Camera(value);
				_allowInstance = false;
			}
			return _instance;
		}
		
		public static function get instance(): Camera
		{
			return _instance;
		}

		public function get x():Number
		{
			return _x;
		}

		public function set x(value:Number):void
		{
			_x = value;
			
			var offset: Number = MapContextConfig.MapSize.x - GlobalContextConfig.Width;
			_x = _x < 0 ? 0 : _x;
			_x = _x > offset ? offset : _x;
		}

		public function get y():Number
		{
			return _y;
		}

		public function set y(value:Number):void
		{
			_y = value;
			
			var offset: Number = MapContextConfig.MapSize.y - GlobalContextConfig.Height;
			_y = _y < 0 ? 0 : _y;
			_y = _y > offset ? offset : _y;
		}

		public function get scene():Scene
		{
			return _scene;
		}

		public function get cameraView():Rectangle
		{
			return _cameraView;
		}
		
		public function get cameraCutView():Rectangle
		{
			var tempX: int = _x;
			var tempY: int = _y;
			
			tempX -= MapContextConfig.TileSize.x;
			tempY -= MapContextConfig.TileSize.y;
			
			tempX = tempX < 0 ? 0 : tempX;
			tempY = tempY < 0 ? 0 : tempY;
			
			_cameraCutView.x = tempX;
			_cameraCutView.y = tempY;
			_cameraCutView.width = GlobalContextConfig.Width + MapContextConfig.TileSize.x * 2;
			_cameraCutView.height = GlobalContextConfig.Height + MapContextConfig.TileSize.y * 2;
			
			return _cameraCutView;
		}
		
		public function focus(value: BitmapDisplay): void
		{
			_focus.beFocus = false;
			_focus = value;
			
			update();
			_scene.NSCamera::cut();
			//TODO map.render();
		}
		
		public function update(): void
		{
			if(_focus != null)
			{
				x = _focus.positionX - (GlobalContextConfig.Width >> 1);
				y = _focus.positionY - (GlobalContextConfig.Height >> 1);
			}
			_cameraView.x = _x;
			_cameraView.y = _y;
			_cameraView.width = GlobalContextConfig.Width;
			_cameraView.height = GlobalContextConfig.Height;
		}

	}
}