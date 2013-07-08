package com.xgame.configuration 
{
	
	import flash.errors.IllegalOperationError;
	
	/**
	 * ...
	 * @author john
	 */
	public final class SocketContextConfig 
	{
		/**
		 * 帐号服务器IP
		 */
		public static var login_ip: String = 'johnnyeven.3322.org';
		/**
		 * 帐号服务器端口
		 */
		public static var login_port: int = 9040;
		/**
		 * 资源服务器地址
		 */
		//public static var resource_server_ip: String = 'http://www.johnnyeven.com/wooha/';
		public static var resource_server_ip: String = '';
		/**
		 * 游戏服务器IP
		 */
		public static var server_ip: String = 'loverjohnny.3322.org';
		/**
		 * 游戏服务器端口
		 */
		public static var server_port: uint = 9050;
		/**
		 * 认证码
		 */
		public static var auth_key: String;
		
		public static const CONTROLLER_INFO: int = 0
		//INFO
		public static const ACTION_CAMERAVIEW_OBJECT_LIST: int = 0;
		public static const ACTION_LOGIN: int = 1;
		public static const ACTION_QUICK_START: int = 2;
		public static const ACTION_CHANGE_ACTION: int = 3;
		public static const ACTION_REQUEST_CHARACTER: int = 4;
		public static const ACTION_REGISTER_CHARACTER: int = 5;
		public static const ACTION_REQUEST_HOTKEY: int = 6;
		public static const ACTION_LOGOUT: int = 8;
		
		public static const TYPE_INT: int = 0;
		public static const TYPE_LONG: int = 1;
		public static const TYPE_STRING: int = 2;
		public static const TYPE_FLOAT: int = 3;
		public static const TYPE_BOOL: int = 4;
		public static const TYPE_UINT: int = 5;
		public static const TYPE_ULONG: int = 6;
		
		public static const ACK_CONFIRM: int = 1;
		public static const ACK_ERROR: int = 0;
		public static const ORDER_CONFIRM: int = 2;
		
		public function SocketContextConfig() 
		{
			throw new IllegalOperationError("Config类不允许实例化");
		}
		
	}

}