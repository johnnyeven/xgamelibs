package com.xgame.utils
{
	import flash.display.DisplayObject;
	import flash.geom.Point;

	public class MouseUtils
	{
		public function MouseUtils()
		{
		}
		
		public static function getMousePosition(target: DisplayObject): Point
		{
			return new Point(target.mouseX * target.scaleX, target.mouseY * target.scaleY);
		}
	}
}