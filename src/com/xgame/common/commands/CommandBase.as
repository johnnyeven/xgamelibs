package com.xgame.common.commands
{
	import com.xgame.common.interfaces.protocols.IProtocol;
	
	public class CommandBase extends Object implements IProtocol
	{
		private var _protocolId: uint = 0;
		
		public function CommandBase(protocolId: uint)
		{
			super();
			_protocolId = protocolId;
		}
		
		public function get protocolId():uint
		{
			return _protocolId;
		}
	}
}