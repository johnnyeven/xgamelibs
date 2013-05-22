package com.xgame.common.display
{
	public class ActionDisplay extends BitmapMovieDispaly
	{
		protected var _action: int;
		
		public function ActionDisplay()
		{
			super();
		}
		
		public function get action():int
		{
			return _action;
		}
		
		public function set action(value:int):void
		{
			_action = value;
		}
	}
}