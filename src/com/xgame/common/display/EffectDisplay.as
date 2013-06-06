package com.xgame.common.display
{
	import com.xgame.common.behavior.Behavior;
	
	public class EffectDisplay extends BitmapMovieDispaly
	{
		public function EffectDisplay(behavior:Behavior=null)
		{
			super(behavior);
			canBeAttack = false;
		}
		
		override public function get renderLine():uint
		{
			return 0;
		}
		
		override protected function updateActionAfter(): void
		{
			return;
		}
		
		override public function set graphic(value:ResourceData):void
		{
			super.graphic = value;
			_graphic.currentAction = 0;
		}
	}
}