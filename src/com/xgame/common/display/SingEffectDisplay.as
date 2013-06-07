package com.xgame.common.display
{
	import com.xgame.common.behavior.Behavior;
	import com.xgame.configuration.GlobalContextConfig;
	import com.xgame.core.scene.Scene;
	import com.xgame.events.SkillEvent;
	
	public class SingEffectDisplay extends EffectDisplay
	{
		protected var _skillId: String;
		protected var _singTime: int;
		
		public function SingEffectDisplay(skillId: String, target: *)
		{
			super(null);
			_skillId = skillId;
			this.target = target;
			_positionX = 0;
			_positionY = 0;
			_isLoop = true;
		}

		public function get singTime():int
		{
			return _singTime;
		}

		public function set singTime(value:int):void
		{
			_singTime = GlobalContextConfig.Timer + value;
		}
		
		override protected function step():Boolean
		{
			if(GlobalContextConfig.Timer >= _singTime)
			{
				_isEnd = true;
				
				var evt: SkillEvent = new SkillEvent(SkillEvent.SING_COMPLETE);
				evt.skillId = _skillId;
				evt.skillTarget = _target;
				dispatchEvent(evt);
			}
			if(!super.step())
			{
				return false;
			}
			return true;
		}
		
		override public function setBufferPos(x:Number=NaN, y:Number=NaN):void
		{
			if(!isNaN(x) && !isNaN(y))
			{
				_buffer.x = -x;
				_buffer.y = -y;
			}
			else if(_graphic != null)
			{
				_buffer.x = -_graphic.frameWidth / 2;
				_buffer.y = -_graphic.frameHeight / 2;
			}
		}
	}
}