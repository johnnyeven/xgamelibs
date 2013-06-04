package com.xgame.common.display
{
	import com.xgame.common.Vector2D;
	import com.xgame.common.behavior.Behavior;
	import com.xgame.enum.Action;

	public class ActionDisplay extends BitmapMovieDispaly
	{
		protected var _action: int;
		private var _follow: ActionDisplay;
		private var _followDistance: Number;
		
		public function ActionDisplay(behavior: Behavior = null)
		{
			super(behavior);
		}
		
		protected function configLoop(): void
		{
			switch(_action)
			{
				case Action.CAUTION:
				case Action.MOVE:
					loop = true;
					break;
				default:
					loop = false;
			}
		}
		
		public function get action():int
		{
			return _action;
		}
		
		public function set action(value:int):void
		{
			if(_action == value || _action == Action.DIE)
			{
				return;
			}
			if(value == Action.DIE)
			{
				canBeAttack = false;
			}
			else
			{
				canBeAttack = true;
			}
			_currentFrame = 0;
			_action = value;
			_graphic.currentAction = value;
			
			configLoop();
			rebuild();
		}

		public function get follow():ActionDisplay
		{
			return _follow;
		}

		public function set follow(value:ActionDisplay):void
		{
			_follow = value;
			_followDistance = 40;
		}

		public function get followDistance():Number
		{
			return _followDistance;
		}

		public function set followDistance(value:Number):void
		{
			_followDistance = value;
		}
		
		public function get followed(): Boolean
		{
			return (_follow != null);
		}
	}
}