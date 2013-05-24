package com.xgame.common.display
{
	import com.xgame.common.Vector2D;
	import com.xgame.common.behavior.Behavior;
	import com.xgame.enum.Action;

	public class ActionDisplay extends BitmapMovieDispaly
	{
		protected var _action: int;
		private var _follow: ActionDisplay;
		private var _followDistance: Vector2D;
		
		public function ActionDisplay(behavior: Behavior = null)
		{
			super(behavior);
		}
		
		override protected function step():Boolean
		{
			if(!super.step())
			{
				return false;
			}
			return true;
		}
		
		protected function configLoop(): void
		{
			switch(_action)
			{
				case Action.DIE:
					loop = false;
					break;
				default:
					loop = true;
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
			_followDistance = new Vector2D(40, 40);
		}

		public function get followDistance():Vector2D
		{
			return _followDistance;
		}

		public function set followDistance(value:Vector2D):void
		{
			_followDistance = value;
		}
		
		public function get followed(): Boolean
		{
			return (_follow != null);
		}
	}
}