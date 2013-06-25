package com.xgame.common.commands.sending
{
	import com.xgame.common.commands.CommandBase;
	import com.xgame.common.interfaces.protocols.ISending;
	
	import flash.utils.ByteArray;
	
	public class SendingBase extends CommandBase implements ISending
	{
		protected var _byteData: ByteArray;
		
		public function SendingBase(protocolId:uint)
		{
			super(protocolId);
			_byteData = new ByteArray();
		}
		
		public function get byteData():ByteArray
		{
			return _byteData;
		}
		
		public function fill():void
		{
			_byteData.clear();
			_byteData.writeShort(protocolId);
		}
		
		public function get protocolName():String
		{
			return "SendingBase";
		}
	}
}