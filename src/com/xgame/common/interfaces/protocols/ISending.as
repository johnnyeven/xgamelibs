package com.xgame.common.interfaces.protocols
{
	import flash.utils.ByteArray;

	public interface ISending
	{
		function get byteData(): ByteArray;
		function fill(): void;
	}
}