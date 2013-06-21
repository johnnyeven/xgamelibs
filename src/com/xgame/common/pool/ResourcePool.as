package com.xgame.common.pool
{
	import com.xgame.common.display.ResourceData;
	import com.xgame.utils.Reflection;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.errors.IllegalOperationError;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;

	public class ResourcePool extends Object implements IPool
	{
		private var _pool: Dictionary;
		private var _dataPool: Dictionary;
		private static var _instance: ResourcePool;
		private static var _allowInstance: Boolean = false;
		
		public function ResourcePool()
		{
			super();
			if(!_allowInstance)
			{
				throw new IllegalOperationError("不能直接实例化");
				return;
			}
			_pool = new Dictionary();
			_dataPool = new Dictionary();
		}
		
		public static function get instance(): ResourcePool
		{
			if(_instance == null)
			{
				_allowInstance = true;
				_instance = new ResourcePool();
				_allowInstance = false;
			}
			return _instance;
		}
		
		public function add(key:Object, value:Object, callback:Function=null):void
		{
			_pool[key] = value;
			if(callback != null)
			{
				callback();
			}
		}
		
		public function get(key:Object):Object
		{
			return _pool[key];
		}
		
		public function remove(key:Object):void
		{
			_pool[key] = null;
			delete _pool[key];
		}
		
		public function removeAll():void
		{
			var _key: Object;
			for(_key in _pool)
			{
				remove(_key);
			}
			_pool = new Dictionary();
		}
		
		public function contain(key:Object):Boolean
		{
			return _pool.hasOwnProperty(key);
		}
		
		public function getBitmapData(name: String, domain: ApplicationDomain = null): BitmapData
		{
			var _cache: BitmapData = get(name) as BitmapData;
			if(_cache == null)
			{
				_cache = Reflection.createBitmapData(name, domain);
				if(_cache != null)
				{
					add(name, _cache);
				}
			}
			return _cache;
		}
		
		public function getDisplayObject(name: String, domain: ApplicationDomain = null): DisplayObject
		{
			var _cache: DisplayObject = get(name) as DisplayObject;
			if(_cache == null)
			{
				_cache = Reflection.createDisplayObject(name, domain);
				if(_cache != null)
				{
					add(name, _cache);
				}
			}
			return _cache;
		}
		
		public function getResourceData(name: String): ResourceData
		{
			var _resourceData: ResourceData;
			if(_dataPool.hasOwnProperty(name))
			{
				_resourceData = _dataPool[name];
			}
			else
			{
				_resourceData = new ResourceData();
				var _bitmapData: BitmapData;
				for(var i: int = 0; i < 9; i++)
				{
					_bitmapData = getBitmapData(name + "_" + i);
					if(_bitmapData != null)
					{
						_resourceData.getResource(_bitmapData, i, _bitmapData["frameLine"], _bitmapData["frameTotal"], _bitmapData["fps"]);
					}
				}
				_dataPool[name] = _resourceData;
			}
			return _resourceData;
		}
	}
}