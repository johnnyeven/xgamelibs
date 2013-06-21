package com.xgame.utils.manager
{
	import flash.errors.IllegalOperationError;
	import flash.utils.Dictionary;

	public class LanguageManager
	{
		private static var _allowInstance: Boolean;
		private static var _instance: LanguageManager;
		private var _container: Dictionary;
		private static var _language: String;
		
		public function LanguageManager()
		{
			if(_allowInstance)
			{
				_container = new Dictionary();
			}
			else
			{
				throw new IllegalOperationError("不能实例化LanguageManager类，应使用LanguageManager.getInstance()来获取实例。");
			}
		}
		
		public static function getInstance(): LanguageManager
		{
			if(_instance == null)
			{
				_allowInstance = true;
				_instance = new LanguageManager();
				_allowInstance = false;
			}
			return _instance;
		}
		
		public function init(value: XML): void
		{
			if(value == null)
			{
				throw new IllegalOperationError("LanguageManager传入的XML为空。");
			}
			else
			{
				for(var key: String in value.children())
				{
					_container[value.child(key).name()] = value.child(key);
				}
			}
		}
		
		public function lang(value: String): String
		{
			if(_container[value] != null)
			{
				return _container[value];
			}
			return null;
		}

		public static function get language():String
		{
			return _language;
		}

		public static function set language(value: String):void
		{
			value = value.replace("-", "_");
			_language = value;
		}

	}
}