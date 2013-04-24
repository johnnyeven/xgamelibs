package com.xgame.core.center
{
	import com.xgame.common.commands.CommandList;
	import com.xgame.common.interfaces.protocols.IReceiving;
	import com.xgame.common.interfaces.protocols.ISending;
	import com.xgame.common.network.socket.SmartSocket;
	
	import flash.errors.IllegalOperationError;
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
			_socket.send(protocol.byteData);
		}
	}
}