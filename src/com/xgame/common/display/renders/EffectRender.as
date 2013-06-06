package com.xgame.common.display.renders
{
	import com.xgame.common.display.BitmapDisplay;
	import com.xgame.core.map.Map;
	
	import flash.geom.Point;

	public class EffectRender extends Render
	{
		public function EffectRender()
		{
			super();
		}
		
		override public function render(target:BitmapDisplay=null, force:Boolean=false):void
		{
			super.render(target, force);
			
			if(_target.parentDisplay != null)
			{
				target.x = target.positionX;
				target.y = target.positionY;
			}
			else
			{
				var pos: Point = Map.instance.getScreenPosition(target.positionX, target.positionY);
				target.x = pos.x;
				target.y = pos.y;
			}
		}
	}
}