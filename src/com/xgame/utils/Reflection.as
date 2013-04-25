package com.xgame.utils
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.system.ApplicationDomain;

	public class Reflection extends Object
	{
		public function Reflection()
		{
			super();
		}
		
		public static function createInstance(name: String, domain: ApplicationDomain = null): *
		{
			var _class: Class = getClass(name, domain);
			if(_class != null)
			{
				var _do: * = new _class();
				if(_do is Sprite)
				{
					_do.cacheAsBitmap = true;
				}
				return _do;
			}
			return null;
		}
		
		public static function getClass(name: String, domain: ApplicationDomain = null): Class
		{
			if(domain == null)
			{
				domain = ApplicationDomain.currentDomain;
			}
			return domain.getDefinition(name) as Class;
		}
		
		public static function createBitmapData(name: String, domain: ApplicationDomain = null): BitmapData
		{
			var _class: Class = getClass(name, domain);
			if(_class != null)
			{
				try
				{
					return new _class(0, 0);
				}
				catch(err: Error)
				{
					return null;
				}
			}
			return null;
		}
		
		public static function createDisplayObject(name: String, domain: ApplicationDomain = null): DisplayObject
		{
			return createInstance(name, domain) as DisplayObject;
		}
	}
}