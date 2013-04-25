package com.xgame.utils.manager
{
	import flash.errors.IllegalOperationError;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;

	public class TimerManager extends Object
	{
		private static var _instance: TimerManager;
		private static var _allowInstance: Boolean = false;
		private var _timerIndex: Dictionary;
		private var _callbackToTimerIndex: Dictionary
		private var _callbackListIndex: Dictionary;
		
		public function TimerManager()
		{
			super();
			if(!_allowInstance)
			{
				throw new IllegalOperationError("不能直接实例化");
			}
			_timerIndex = new Dictionary();
			_callbackToTimerIndex = new Dictionary();
			_callbackListIndex = new Dictionary();
		}
		
		public static function get instance(): TimerManager
		{
			if(_instance == null)
			{
				_allowInstance = true;
				_instance = new TimerManager();
				_allowInstance = false;
			}
			return _instance;
		}
		
		public function add(delay: int, callback: Function): void
		{
			if(_callbackToTimerIndex[callback] != null)
			{
				return;
			}
			_callbackToTimerIndex[callback] = createTimer(delay);
			_callbackListIndex[delay].push(callback);
		}
		
		public function remove(callback: Function): void
		{
			if(_callbackToTimerIndex[callback] == null)
			{
				return;
			}
			var _timer: Timer = _callbackToTimerIndex[callback];
			delete _callbackToTimerIndex[callback];
			var _callbackArray: Array = _callbackListIndex[_timer.delay];
			var _index: int = _callbackArray.indexOf(callback);
			if(_index > -1)
			{
				_callbackArray.splice(_index, 1);
			}
			if(_callbackArray.length == 0)
			{
				_timer.stop();
				_timer.removeEventListener(TimerEvent.TIMER, onTimer);
				delete _callbackListIndex[_timer.delay];
				delete _timerIndex[_timer.delay];
			}
		}
		
		private function createTimer(delay: int): Timer
		{
			if(_timerIndex[delay] == null)
			{
				var _timer: Timer = new Timer(delay);
				_timer.addEventListener(TimerEvent.TIMER, onTimer);
				_timer.start();
				_timerIndex[delay] = _timer;
			}
			if(_callbackListIndex[delay] == null)
			{
				_callbackListIndex[delay] = new Array();
			}
			return _timerIndex[delay];
		}
		
		private function onTimer(evt: TimerEvent): void
		{
			var _callback: Function;
			var _callbackArray: Array = _callbackListIndex[(evt.target as Timer).delay];
			for each(_callback in _callbackArray)
			{
				_callback();
			}
		}
	}
}