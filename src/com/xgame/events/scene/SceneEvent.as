package com.xgame.events.scene
{
	import flash.events.Event;
	
	public class SceneEvent extends Event
	{
		public static const SCENE_READY: String = "SceneEvent.SceneReady";
		
		public function SceneEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}