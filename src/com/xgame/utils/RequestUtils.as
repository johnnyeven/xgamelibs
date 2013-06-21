package com.xgame.utils
{
	import flash.net.URLRequest;
	import flash.net.URLVariables;

	public class RequestUtils
	{
		public static var version: String = "";
		
		public function RequestUtils()
		{
		}
		
		public static function getRequestByVersion(_url: String, _version: String = null): URLRequest
		{
			var _urlRequest: URLRequest = new URLRequest(_url);
			if(StringUtils.empty(_version))
			{
				_version = version;
			}
			setParameter(_urlRequest, _url, "version=" + _version);
			return _urlRequest;
		}
		
		public static function setParameter(_urlRequest: URLRequest, _url: String, _extendParameter: String): void
		{
			var _urlArray: Array = _url.split("?");
			if(_urlArray.length > 1)
			{
				_extendParameter += (StringUtils.empty(_extendParameter) ? _urlArray[1] : ("&" + _urlArray[1]));
			}
			
			if(!StringUtils.empty(_extendParameter))
			{
				var _urlVal: URLVariables = (_urlRequest.data == null ? new URLVariables() : _urlRequest.data as URLVariables);
				var _extendArray: Array = _extendParameter.split("&");
				for each(var kv: String in _extendArray)
				{
					var _kvArray: Array = kv.split("=");
					_urlVal[_kvArray[0]] = _kvArray[1];
				}
				_urlRequest.data = _urlVal;
			}
		}
	}
}