package com.xgame.core.center
{
	/**
	 * 处理器总线控制基础类
	 * 提供触发器注册与反注册与触发等操作
	 */
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	public class BaseCenter extends EventDispatcher
	{
		private var _trigger: Dictionary;
		
		public function BaseCenter()
		{
			super(this);
			
			_trigger = new Dictionary();
		}
		
		protected function addTrigger(key: Object, value: Function): void
		{
			var _item: Array = _trigger[key] as Array;
			if(_item == null)
			{
				_item = new Array();
				_trigger[key] = _item;
			}
			_item.push(value);
		}
		
		protected function removeTrigger(key: Object, value: Function): void
		{
			var _item: Array = _trigger[key] as Array;
			if(_item == null)
			{
				return;
			}
			var index: int = _item.indexOf(value);
			if(index > -1)
			{
				_item.splice(index, 1);
			}
			if(_item.length == 0)
			{
				_trigger[key] = null;
				delete _trigger[key];
			}
		}
		
		protected function riseTrigger(key: Object, param: Object): void
		{
			var _item: Array = _trigger[key] as Array;
			if(_item == null)
			{
				return;
			}
			
			var func: Function;
			for each(func in _item)
			{
				func(param);
			}
		}
		
		protected function getTrigger(key: Object): Array
		{
			return _trigger[key] as Array;
		}
	}
}