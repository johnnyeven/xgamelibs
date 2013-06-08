package com.xgame.events
{
	import flash.events.Event;
	
	public class SkillEvent extends Event
	{
		public var skillId: String;
		public var skillTarget: *;
		public static const SING_COMPLETE: String = "SkillEvent.SingComplete";
		public static const FIRE_COMPLETE: String = "SkillEvent.FireComplete";
		public function SkillEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}