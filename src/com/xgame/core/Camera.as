package com.xgame.core
{
	import com.xgame.common.display.BitmapDisplay;
	import com.xgame.core.scene.Scene;
	
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
		}

		public function get y():Number
		{
			return _y;
		}

		public function set y(value:Number):void
		{
			_y = value;
		}

		public function get scene():Scene
		{
			return _scene;
		}
	}
}