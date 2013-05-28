package com.xgame.utils
{
	public class Angle
	{
		public function Angle()
		{
		}
		
		public static function getAngle(x: Number, y: Number): Number
		{
			return Math.atan2(y, x);
		}
		
		public static function radian2Angle(value: Number): Number
		{
			return value * 180 / Math.PI;
		}
		
		public static function angle2Radian(value: Number): Number
		{
			return value * Math.PI / 180;
		}
	}
}