package com.xgame.common.commands
{
	import com.xgame.common.interfaces.protocols.IReceiving;
	
	import flash.utils.Dictionary;

	public class CommandCollector extends Object
	{
		protected var _commandList: Dictionary;
		
		public function CommandCollector()
		{
			_commandList = new Dictionary();
		}
		
		public function getProtocol(protocolId: uint): IReceiving
		{
			if(_commandList[protocolId] == null)
			{
				//TODO 替换为debug
				trace("收到一个不认识的协议号：" + protocolId);
				return null;
			}
			return new _commandList[protocolId]();
		}
		
		public function dispose(): void
		{
			for(var protocolId: String in _commandList)
			{
				_commandList[protocolId] = null;
				delete _commandList[protocolId];
			}
			_commandList = null;
		}
	}
}