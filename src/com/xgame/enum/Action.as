package com.xgame.enum
{
	public class Action
	{
		public static var RESURRECTION: int = 8;
		public static var STOP: int = 0;
		public static var MOVE: int = 1;
		public static var ATTACK: int = 2;
		public static var SIT: int = 3;
		public static var DIE: int = 4;
		public static var PICKUP: int = 5;
		public static var BE_ATTACKED: int = 6;
		public static var CAUTION: int = 7;
		public static var PlayOnce: Array = [2, 5, 6];
		public static var PlayOnceToCaution: Array = [2, 6];
		
		public function Action()
		{
		}
	}
}