package com.xgame.common.pool
{
	import com.xgame.utils.Reflection;
	
	import flash.display.BitmapData;
	import flash.errors.IllegalOperationError;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;

	public class ResourcePool extends Object implements IPool
	{
		private var _pool: Dictionary;
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
				add(name, _cache);
			}
			return _cache;
		}
	}
}