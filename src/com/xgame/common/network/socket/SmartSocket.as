package com.xgame.common.network.socket
{
	import flash.errors.IllegalOperationError;
	import flash.events.ProgressEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Endian;
	
	public class SmartSocket extends Socket
	{
		private static var _instance: SmartSocket;
		private static var _allowInstance: Boolean = false;
		private var _contentLength: uint;
		private var _cache: ByteArray;
		private var _callback: Function;
		private var _protocolId: uint;
		private var _ping: uint;
		private var _commandList: Dictionary;
		
		public function SmartSocket()
		{
			super();
			if(!_allowInstance)
			{
				throw new IllegalOperationError("不能直接实例化");
				return;
			}
			_cache = new ByteArray();
			_cache.endian = Endian.BIG_ENDIAN;
			_commandList = new Dictionary();
			_contentLength = 0;
			_protocolId = 0;
			_ping = 0;
			addEventListener(ProgressEvent.SOCKET_DATA, onSocketData);
		}
		
		public static function get instance(): SmartSocket
		{
			if(_instance == null)
			{
				_allowInstance = true;
				_instance = new SmartSocket();
				_allowInstance = false;
			}
			return _instance;
		}
		
		public function set callback(value: Function): void
		{
			_callback = value;
		}
		
		override public function connect(host:String, port:int):void
		{
			if(connected)
			{
				return;
			}
			super.connect(host, port);
		}
		
		private function onSocketData(evt: ProgressEvent): void
		{
			var _byteArray: ByteArray = new ByteArray();
			_byteArray.endian = Endian.BIG_ENDIAN;
			readBytes(_byteArray, 0, bytesAvailable);
			assembly(_byteArray);
		}
		
		private function assembly(data: ByteArray): void
		{
			var _byteArray: ByteArray = new ByteArray();
			_byteArray.endian = Endian.BIG_ENDIAN;
			
			if(_cache.length > 0)
			{
				_cache.readBytes(_byteArray, 0, _cache.bytesAvailable);
			}
			data.readBytes(_byteArray, _byteArray.length, data.bytesAvailable);
			
			if(_contentLength == 0 && _byteArray.bytesAvailable < 6)
			{
				_cache = _byteArray;
			}
			else
			{
				process(_byteArray);
			}
		}
		
		private function process(data: ByteArray): void
		{
			var _byteArray1: ByteArray;
			var _byteArray2: ByteArray;
			var _byteArray3: ByteArray;
			if(_contentLength == 0)
			{
				_contentLength = data.readInt();
			}
			if(_contentLength > 65534)
			{
				//TODO 改debug
				trace("包过长，抛弃，包长度：" + _contentLength + "，上次协议号：" + _protocolId);
			}
			if(data.bytesAvailable < _contentLength || _contentLength < 2)
			{
				_byteArray1 = new ByteArray();
				_byteArray1.endian = Endian.BIG_ENDIAN;
				data.readBytes(_byteArray1, 0, data.bytesAvailable);
				_cache = _byteArray1;
			}
		}
	}
}