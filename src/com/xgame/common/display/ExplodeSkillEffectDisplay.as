package com.xgame.common.display
{
	import com.xgame.common.Vector2D;
	import com.xgame.common.behavior.Behavior;
	import com.xgame.core.scene.Scene;
	
	import flash.geom.Point;
	
	public class ExplodeSkillEffectDisplay extends SkillEffectDisplay
	{
		
		public function ExplodeSkillEffectDisplay(skillId:String, skillTarget: *)
		{
			super(skillId);
			_isLoop = false;
			target = skillTarget;
		}
		
		override protected function step():Boolean
		{
			if(!super.step())
			{
				return false;
			}
			if(_isEnd)
			{
				if(parentDisplay != null)
				{
					parentDisplay.removeDisplay(this);
				}
				else
				{
					Scene.instance.removeObject(this);
				}
			}
			return true;
		}
	}
}