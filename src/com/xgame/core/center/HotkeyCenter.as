package com.xgame.core.center
{
	import flash.errors.IllegalOperationError;
	import flash.utils.Dictionary;

	public class HotkeyCenter extends BaseCenter
	{
		private static var _instance: HotkeyCenter;
		private static var _allowInstance: Boolean = false;
		private var _id: Dictionary;
		
		public function HotkeyCenter()
		{
			super();
			if(!_allowInstance)
			{
				throw new IllegalOperationError("不能直接实例化");
				return;
			}
			_id = new Dictionary();
		}
		
		public static function get instance(): HotkeyCenter
		{
			if(_instance == null)
			{
				_allowInstance = true;
				_instance = new HotkeyCenter();
				_allowInstance = false;
			}
			return _instance;
		}
		
		public function bind(keyCode: int, id: String, process: Function): void
		{
			addTrigger(keyCode, process);
			_id[keyCode] = id;
		}
		
		public function unbind(keyCode: int, id: String, process: Function): void
		{
			removeTrigger(keyCode, process);
			_id[keyCode] = null;
			delete _id[keyCode];
		}
	}
}