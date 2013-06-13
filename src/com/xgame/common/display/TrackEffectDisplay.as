package com.xgame.common.display
{
	import com.xgame.common.Vector2D;
	import com.xgame.common.behavior.Behavior;
	import com.xgame.common.behavior.TrackSkillBehavior;
	
	import flash.geom.Point;
	
	public class TrackEffectDisplay extends SkillEffectDisplay
	{
		protected var _startPosition: Point;
		protected var _startVelocity: Number;
		
		public function TrackEffectDisplay(skillId:String, skillTarget: *, startPosition: Point = null, startVelocity: Number = 10)
		{
			super(skillId);
			if(startPosition != null)
			{
				_startPosition = startPosition;
				positionX = _startPosition.x;
				positionY = _startPosition.y;
			}
			_isLoop = false;
			target = skillTarget;
			_startVelocity = startVelocity;
			behavior = new TrackSkillBehavior();
		}
		
		public function set startPosition(value: Point): void
		{
			if(value != null)
			{
				_startPosition = value;
				positionX = _startPosition.x;
				positionY = _startPosition.y;
				(_behavior as TrackSkillBehavior).resetVelocity();
			}
		}

		public function get startPosition():Point
		{
			return _startPosition;
		}

		public function get startVelocity():Number
		{
			return _startVelocity;
		}
		
	}
}