package com.xgame.events.net
{
	import flash.events.Event;
	
	public class CommandEvent extends Event
	{
		public static const CONNECTED_EVENT: String = "CommandEvent.ConnectedEvent";
		public static const CLOSED_EVENT: String = "CommandEvent.ClosedEvent";
		public static const IOERROR_EVENT: String = "CommandEvent.IOErrorEvent";
		public static const SECURITYERROR_EVENT: String = "CommandEvent.SecurityErrorEvent";
		
		public function CommandEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}