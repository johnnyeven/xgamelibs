package com.xgame.events.ui
{
	import flash.events.Event;
	
	public class TreeEvent extends Event
	{
		public var caption: String;
		public static const TREE_NODE_CLICK: String = "TreeEvent.TreeNodeClick";
		
		public function TreeEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}