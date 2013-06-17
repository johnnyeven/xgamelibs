package com.xgame.core.center
{
	import com.xgame.core.scene.Scene;
	
	import flash.errors.IllegalOperationError;
	import flash.events.KeyboardEvent;
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
			Scene.instance.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, false, 0, true);
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
		
		private function onKeyDown(evt: KeyboardEvent): void
		{
			var keyCode: int = evt.keyCode;
			riseTrigger(keyCode, _id[keyCode]);
		}
		
		public function bind(keyCode: int, id: String, processor: Class): void
		{
			addTrigger(keyCode, processor["execute"]);
			_id[keyCode] = id;
		}
		
		public function unbind(keyCode: int, id: String, processor: Class): void
		{
			removeTrigger(keyCode, processor["execute"]);
			_id[keyCode] = null;
			delete _id[keyCode];
		}
	}
}