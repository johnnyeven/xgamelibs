package com.xgame.common.interfaces.protocols
{
	import flash.utils.ByteArray;

	public interface IReceiving
	{
		function fill(data: ByteArray): void;
		function equals(value: IReceiving): Boolean;
	}
}