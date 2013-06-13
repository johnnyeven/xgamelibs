package com.xgame.utils.debug
{
	import flash.utils.getQualifiedClassName;
	
	public class Debug
	{
		public static const LEVEL_INFO: Number = 0;
		public static const LEVEL_WARNING: Number = 1;
		public static const LEVEL_ERROR: Number = 2;
		private static const _levelArray: Array = ["INFO", "WARNING", "ERROR"];
		
		public function Debug()
		{
		}
		
		private static function log(sender: *, content: *, level: Number): void
		{
			var output: String;
			output = 
				"[" + _levelArray[level] + "]" +
				"[" + getClassName(sender) + " - " +
				getCodePosition() + " - " +
				getDate() + "]\n" + 
				getContent(content);
			trace(output);
		}
		
		public static function info(sender: *, content: *): void
		{
			log(sender, content, LEVEL_INFO);
		}
		
		public static function warning(sender: *, content: *): void
		{
			log(sender, content, LEVEL_WARNING);
		}
		
		public static function error(sender: *, content: *): void
		{
			log(sender, content, LEVEL_ERROR);
		}
		
		private static function getClassName(sender: *): String
		{
			var name: String = getQualifiedClassName(sender);
			var array: Array = name.split("::");
			return array[1];
		}
		
		private static function getCodePosition(): String
		{
			var err: Error = new Error();
			var stack: Array = err.getStackTrace().split("\n");
			var i: int = 0;
			for(; i < stack.length; i++)
			{
				if(stack[i].indexOf("Debug$/log()") >= 0)
				{
					i += 2;
					break;
				}
			}
			var reg: RegExp=/at\s+([^\/\$]+)\$?\/?(\w+)?\(\)([^.]+\.(\w+):(\d+))?/;
			var result: Array = reg.exec(String(stack[i]));
			return result[3];
		}
		
		private static function getContent(content: *): String
		{
			if(content is String)
			{
				return content;
			}
			try
			{
				return content.toString();
			}
			catch(err: Error)
			{
				
			}
			return "";
		}
		
		private static function getDate(): String
		{
			var d: Date = new Date();
			return d.getFullYear() + "-" +
				(d.getMonth() + 1) + "-" +
				d.getDate() + " " +
				d.getHours() + ":" +
				d.getMinutes() + ":" +
				d.getSeconds() + "," + 
				d.getMilliseconds();
		}
	}
}