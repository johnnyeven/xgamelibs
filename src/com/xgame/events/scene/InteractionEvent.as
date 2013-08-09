package com.xgame.events.scene
{
	import com.xgame.common.display.BitmapDisplay;
	
	import flash.events.Event;
	
	public class InteractionEvent extends Event
	{
		public static const SCENE_CLICK: String = "InteractionEvent.SceneClick";
		
		public var clicker: BitmapDisplay;
		public var stageX: Number;
		public var stageY: Number;
		
		public function InteractionEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}