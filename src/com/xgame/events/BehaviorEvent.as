package com.xgame.events
{
	import flash.events.Event;
	
	public class BehaviorEvent extends Event
	{
		public static const MOVE_IN_POSITION: String = "BehaviorEvent.MoveInPosition";
		
		public function BehaviorEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}