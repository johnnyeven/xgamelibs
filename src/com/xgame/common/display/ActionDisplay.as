package com.xgame.common.display
{
	import com.xgame.common.Vector2D;
	import com.xgame.common.behavior.Behavior;

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
			_action = value;
			_graphic.currentAction = value;
			rebuild();
		}
	}
}