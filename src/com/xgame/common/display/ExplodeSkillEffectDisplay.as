package com.xgame.common.display
{
	import com.xgame.common.behavior.Behavior;
	
	import flash.geom.Point;
	
	public class ExplodeSkillEffectDisplay extends SkillEffectDisplay
	{
		public function ExplodeSkillEffectDisplay(skillId:String, skillTarget: *)
		{
			super(skillId);
			_isLoop = false;
			target = skillTarget;
		}
	}
}