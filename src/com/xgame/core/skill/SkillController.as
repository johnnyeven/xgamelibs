package com.xgame.core.skill
{
	import com.xgame.common.display.BitmapDisplay;
	import com.xgame.common.display.ExplodeSkillEffectDisplay;
	import com.xgame.common.display.SingEffectDisplay;
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
		
		public function prepareSkill(skillId: String, target: *): void
		{
			var effect: SingEffectDisplay = new SingEffectDisplay(skillId, target);
			effect.owner = _target;
			effect.graphic = ResourcePool.instance.getResourceData("assets.skill.prepareSkill");
			effect.singTime = 1000;
			effect.render = new Render();
			effect.addEventListener(SkillEvent.SING_COMPLETE, onFire, false, 0, true);
			_target.addDisplay(effect);
		}
		
		protected function onFire(evt: SkillEvent): void
		{
			(evt.currentTarget as SingEffectDisplay).removeEventListener(SkillEvent.SING_COMPLETE, onFire);
			
			var tracker: TrackEffectDisplay;
			for(var i: int = 0; i < 5; i++)
			{
				tracker = new TrackEffectDisplay(evt.skillId, evt.skillTarget, new Point(_target.positionX, _target.positionY), .1, i);
				tracker.owner = _target;
				tracker.graphic = ResourcePool.instance.getResourceData("assets.skill." + evt.skillId + "_FIRE");
				tracker.render = new Render();
				tracker.addEventListener(SkillEvent.FIRE_COMPLETE, onExplode, false, 0, true);
				Scene.instance.addObject(tracker);
			}
		}
		
		protected function onExplode(evt: SkillEvent): void
		{
			Debug.info(evt.currentTarget, evt.currentTarget.name);
			(evt.currentTarget as TrackEffectDisplay).removeEventListener(SkillEvent.FIRE_COMPLETE, onExplode);
			var explode: ExplodeSkillEffectDisplay = new ExplodeSkillEffectDisplay(evt.skillId, evt.skillTarget);
			explode.owner = _target;
			explode.graphic = ResourcePool.instance.getResourceData("assets.skill." + evt.skillId + "_EXPLODE");
			explode.render = new Render();
			
			if(evt.skillTarget is BitmapDisplay)
			{
				(evt.skillTarget as BitmapDisplay).addDisplay(explode);
			}
			else
			{
				Scene.instance.addObject(explode);
			}
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