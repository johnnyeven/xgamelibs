package com.xgame.core.center
{
	import flash.errors.IllegalOperationError;

	public class GameCenter extends BaseCenter
	{
		private static var _instance: GameCenter;
		private static var _allowInstance: Boolean = false;
		
		public function GameCenter()
		{
			super();
			if(!_allowInstance)
			{
				throw new IllegalOperationError("不能直接实例化");
			}
		}
		
		public static function get instance(): GameCenter
		{
			if(_instance == null)
			{
				_allowInstance = true;
				_instance = new GameCenter();
				_allowInstance = false;
			}
			return _instance;
		}
	}
}