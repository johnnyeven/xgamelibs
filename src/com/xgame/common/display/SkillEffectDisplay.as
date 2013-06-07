package com.xgame.common.display
{
	import com.xgame.common.behavior.Behavior;
	
	public class SkillEffectDisplay extends EffectDisplay
	{
		protected var _skillId: String;
		
		public function SkillEffectDisplay(skillId: String, behavior: Behavior = null)
		{
			super(behavior);
			_skillId = skillId;
		}

		public function get skillId():String
		{
			return _skillId;
		}

	}
}