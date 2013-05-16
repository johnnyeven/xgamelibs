package com.xgame.events.map
{
	import flash.events.Event;
	
	public class MapEvent extends Event
	{
		public static const MAP_DATA_COMPLETE: String = "MapEvent.MapDataComplete";
		public static const COMPLETE: String = "MapEvent.Complete";
		
		public function MapEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}