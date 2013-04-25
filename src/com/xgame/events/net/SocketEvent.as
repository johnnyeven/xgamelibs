package com.xgame.events.net
{
	import flash.events.Event;
	
	public class SocketEvent extends Event
	{
		public static const PING_REFRESH: String = "SocketEvent.PingRefresh";
		
		public function SocketEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}