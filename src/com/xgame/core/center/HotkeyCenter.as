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
		
		public function HotkeyCenter()
		{
			super();
			if(!_allowInstance)
			{
				throw new IllegalOperationError("不能直接实例化");
				return;
			}
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
			riseTrigger(keyCode);
		}
		
		public function bind(keyCode: int, processor: Class): void
		{
			addTrigger(keyCode, processor["execute"]);
		}
		
		public function unbind(keyCode: int, processor: Class): void
		{
			removeTrigger(keyCode, processor["execute"]);
		}
	}
}