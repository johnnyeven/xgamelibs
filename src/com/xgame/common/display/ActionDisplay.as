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
			rebuild();
		}
	}
}