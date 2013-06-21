package com.xgame.events.ui
{
	import flash.events.Event;
	
	public class MenuEvent extends Event
	{
		public static const ITEM_CLICK: String = "MenuEvent.ItemClick";
		
		public var itemName: String;
		public function MenuEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}