package com.xgame.core.skill
{
	import com.xgame.common.display.BitmapDisplay;
	import com.xgame.common.display.AutoRemoveEffectDisplay;
	import com.xgame.common.display.SingEffectDisplay;
	import com.xgame.common.display.StatusEffectDisplay;
	import com.xgame.common.display.TrackEffectDisplay;
	import com.xgame.common.display.renders.Render;
	import com.xgame.common.pool.ResourcePool;
	import com.xgame.core.scene.Scene;
	import com.xgame.events.SkillEvent;
	import com.xgame.utils.debug.Debug;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	
	public class SkillController implements IEventDispatcher
	{
		protected var _target: BitmapDisplay;
		protected var _eventDispatcher: EventDispatcher;
		
		public function SkillController()
		{
			_eventDispatcher = new EventDispatcher(this);
		}
		
		public function get target():BitmapDisplay
		{
			return _target;
		}

		public function set target(value:BitmapDisplay):void
		{
			_target = value;
		}

		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			_eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			_eventDispatcher.removeEventListener(type, listener, useCapture);
		}
		
		public function dispatchEvent(event:Event):Boolean
		{
			return _eventDispatcher.dispatchEvent(event);
		}
		
		public function hasEventListener(type:String):Boolean
		{
			return _eventDispatcher.hasEventListener(type);
		}
		
		public function willTrigger(type:String):Boolean
		{
			return _eventDispatcher.willTrigger(type);
		}
	}
}