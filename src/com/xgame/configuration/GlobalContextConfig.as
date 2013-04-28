package com.xgame.configuration 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.errors.IllegalOperationError;
	
	/**
	 * ...
	 * @author john
	 */
	public final class GlobalContextConfig 
	{
		public static var GameId: int = 1001;
		public static var container: DisplayObjectContainer;
		/**
		 * 资源更新周期(秒)
		 */
		public static var resourceDelay: uint = 3600;
		public static var stage: Stage;
		/**
		 * 移动同步间隔（毫秒）
		 */
		public static var sync_trigger: uint = 1000;
		/**
		 * 场景刷新间隔（毫秒）
		 */
		public static var cameraview_trigger: uint = 1000;
		/**
		 * 舞台宽
		 */
		public static var Width: uint = 1028;
		/**
		 * 舞台高
		 */
		public static var Height: uint = 600;
		/**
		 * 游戏计时器
		 */
		public static var Timer: uint;
		/**
		 * 死亡后尸体保留时间
		 */
		public static var deadRetainTime: uint = 10000;
		
		/**
		 * 配置文件目录
		 */
		public static const CONFIG_PATH: String = 'config/';
		/**
		 * 脚本目录
		 */
		public static const SCRIPT_PATH: String = 'scripts/';
		/**
		 * 资源目录
		 */
		public static const RESOURCE_PATH: String = 'resources/';
		/**
		 * 地图资源目录
		 */
		public static const MAP_RES_PATH: String = 'resources/maps/';
		/**
		 * 角色资源目录
		 */
		public static const CHAR_RES_PATH: String = 'resources/characters/';
		
		public function GlobalContextConfig() 
		{
			throw new IllegalOperationError("Config类不允许实例化");
		}
	}

}