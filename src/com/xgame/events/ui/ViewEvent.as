package com.xgame.events.ui
{
	import flash.events.Event;
	
	public class ViewEvent extends Event
	{
		public static const MAX_WIDTH_CHANGE: String = "ViewEvent.MaxWidthChange";
		public static const MAX_HEIGHT_CHANGE: String = "ViewEvent.MaxHeightChange";
		
		public function ViewEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}