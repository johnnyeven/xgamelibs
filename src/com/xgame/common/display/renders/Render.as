package com.xgame.common.display.renders
{
	import com.xgame.common.display.BitmapDisplay;

	public class Render
	{
		private var _target: BitmapDisplay;
		
		public function Render()
		{
		}
		
		public function render(target: BitmapDisplay = null, force: Boolean = false): void
		{
			if(target == null)
			{
				target = _target;
			}
			draw(target, _target.renderLine, _target.renderFrame);
		}
		
		protected function draw(target: BitmapDisplay = null, line: uint = 0, frame: uint = 0): void
		{
			if(target == null)
			{
				target = _target;
			}
			_target.graphic.render(target.buffer, line, frame);
		}
		
		public function set target(value: BitmapDisplay): void
		{
			if(value != null)
			{
				_target = value;
			}
		}
	}
}