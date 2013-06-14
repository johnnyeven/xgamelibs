package com.xgame.common.display
{
	import com.xgame.common.behavior.Behavior;
	
	public class StatusEffectDisplay extends SkillEffectDisplay
	{
		public function StatusEffectDisplay(skillId:String, skillTarget: *)
		{
			super(skillId, null);
			loop = true;
			target = skillTarget;
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
				_buffer.y = -_graphic.frameHeight + 45;
			}
		}
	}
}