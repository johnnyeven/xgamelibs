package com.xgame.utils
{
	public class StringUtils
	{
		public function StringUtils()
		{
		}
		
		public static function empty(value: String): Boolean
		{
			return (value == "") || (value == null);
		}
		
		public static function parseString(value: String, ...args): String
		{
			if(empty(value))
			{
				return "";
			}
			for(var i: uint = 0; i < args.length; i++)
			{
				value = value.replace("{" + i + "}", args[i]);
			}
			return value;
		}
		
		public static function insertString(source: String, target: String, start: int): String
		{
			var _tmpSource: Array = source.split("");
			_tmpSource.splice(start, 0, target);
			return _tmpSource.join("");
		}
		
		public static function removeString(source: String, start: int, length: int): Array
		{
			var _tmpSource: Array = source.split("");
			var _spliceElement: Array = _tmpSource.splice(start, length);
			return new Array(_tmpSource.join(""), _spliceElement.join(""));
		}
		
		public static function htmlEntitiesEncode(value: String): String
		{
			value = value.replace(/\&/g, "&amp;");
			value = value.replace(/\</g, "&gl;");
			value = value.replace(/\>/g, "&gt;");
			return value;
		}
		
		public static function htmlEntitiesDecode(value: String): String
		{
			value = value.replace(/&amp;/g, "&");
			value = value.replace(/&gl;/g, "<");
			value = value.replace(/&gt;/g, ">");
			return value;
		}
	}
}