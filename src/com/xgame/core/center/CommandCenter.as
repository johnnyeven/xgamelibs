package com.xgame.core.center
{
	import com.xgame.common.commands.CommandList;
	import com.xgame.common.interfaces.protocols.IReceiving;
	import com.xgame.common.interfaces.protocols.ISending;
	import com.xgame.common.network.socket.SmartSocket;
	import com.xgame.events.net.CommandEvent;
	import com.xgame.utils.debug.Debug;
	
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.utils.ByteArray;

	public class CommandCenter extends BaseCenter
	{
		private var _socket: SmartSocket;
		private var _commandList: CommandList
		private static var _instance: CommandCenter;
		private static var _allowInstance: Boolean = false;
		
		public function CommandCenter()
		{
			super();
			if(!_allowInstance)
			{
				throw new IllegalOperationError("不能直接实例化");
				return;
			}
			_socket = SmartSocket.instance;
			_socket.callback = process;
			
			_socket.addEventListener(Event.CLOSE, onClosed);
			_socket.addEventListener(Event.CONNECT, onConnected);
			_socket.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			_socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			
			_commandList = CommandList.instance;
		}
		
		public static function get instance(): CommandCenter
		{
			if(_instance == null)
			{
				_allowInstance = true;
				_instance = new CommandCenter();
				_allowInstance = false;
			}
			return _instance;
		}
		
		public function get connected(): Boolean
		{
			return _socket.connected;
		}
		
		private function onClosed(event: Event): void
		{
			dispatchEvent(new CommandEvent(CommandEvent.CLOSED_EVENT));
		}
		
		private function onConnected(event: Event): void
		{
			Debug.info(this, "服务器已连接");
			dispatchEvent(new CommandEvent(CommandEvent.CONNECTED_EVENT));
		}
		
		private function onIOError(event: IOErrorEvent): void
		{
			Debug.error(this, "服务器连接错误");
			dispatchEvent(new CommandEvent(CommandEvent.IOERROR_EVENT));
		}
		
		private function onSecurityError(event: SecurityErrorEvent): void
		{
			Debug.error(this, "服务器安全沙箱冲突");
			dispatchEvent(new CommandEvent(CommandEvent.SECURITYERROR_EVENT));
		}
		
		public function connect(host: String, port: int): void
		{
			Debug.info(this, "服务器连接中...(IP=" + host + ", Port=" + port + ")");
			_socket.connect(host, port);
		}
		
		private function process(protocolId: uint, data: ByteArray): void
		{
			var _protocol: IReceiving = _commandList.getProtocol(protocolId);
			if(_protocol == null)
			{
				return;
			}
			_protocol.fill(data);
			riseTrigger(protocolId, _protocol);
		}
		
		public function add(protocolId: uint, callback: Function): void
		{
			addTrigger(protocolId, callback);
		}
		
		public function remove(protocolId: uint, callback: Function): void
		{
			removeTrigger(protocolId, callback);
		}
		
		public function send(protocol: ISending): void
		{
			protocol.fill();
			protocol.fillTimestamp();
			_socket.send(protocol.byteData);
		}
		
		public function dispose(): void
		{
			if(_socket.hasEventListener(Event.CLOSE))
			{
				_socket.removeEventListener(Event.CLOSE, onClosed);
			}
			if(_socket.hasEventListener(Event.CONNECT))
			{
				_socket.removeEventListener(Event.CONNECT, onConnected);
			}
			if(_socket.hasEventListener(IOErrorEvent.IO_ERROR))
			{
				_socket.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			}
			if(_socket.hasEventListener(SecurityErrorEvent.SECURITY_ERROR))
			{
				_socket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			}
			_socket.dispose();
			_commandList.dispose();
			_socket = null;
			_instance = null;
		}
	}
}