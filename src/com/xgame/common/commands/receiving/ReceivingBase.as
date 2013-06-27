package com.xgame.common.commands.receiving
{
	import com.xgame.common.commands.CommandBase;
	import com.xgame.common.interfaces.protocols.IReceiving;
	
	import flash.utils.ByteArray;
	import flash.utils.describeType;
	
	public class ReceivingBase extends CommandBase implements IReceiving
	{
		public var message: int;
		
		public function ReceivingBase(protocolId:uint)
		{
			super(protocolId);
		}
		
		public function fill(data:ByteArray):void
		{
			message = data.readByte();
		}
		
		public function equals(value:IReceiving):Boolean
		{
			var _currentXML: XML = describeType(this);
			var _targetXML: XML = describeType(value);
			if(_currentXML.@name != _targetXML.@name)
			{
				return false;
			}
			
			var _child: XML;
			for each(_child in _currentXML.variable)
			{
				if(this[_child.@name.toString()] != value[_child.@name.toString()])
				{
					return false;
				}
			}
			return true;
		}
		
		public function get protocolName():String
		{
			return "ReceivingBase";
		}
	}
}