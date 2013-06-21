package com.xgame.utils
{
	import flash.utils.Dictionary;

	public class VersionUtils
	{
		private static var _versionIndex: Dictionary = new Dictionary();
		
		public function VersionUtils()
		{
		}
		
		public static function initVersionIndex(versionFile: XML): void
		{
			for(var key: String in versionFile.children())
			{
				_versionIndex[versionFile.child(key).localName()] = versionFile.child(key).toString();
			}
		}
		
		public static function getVersion(name: String): String
		{
			return _versionIndex[name];
		}
	}
}