package com.xgame.liteui.layouts
{
	public class Margin
	{
		public var top: Number;
		public var right: Number;
		public var bottom: Number;
		public var left: Number;
		
		public function Margin(top: Number = 0, right: Number = 0, bottom: Number = 0, left: Number = 0)
		{
			this.top = top;
			this.right = right;
			this.bottom = bottom;
			this.left = left;
		}
		
		public function isZero(): Boolean
		{
			if(top == 0 && right == 0 && bottom == 0 && left == 0)
			{
				return true;
			}
			return false;
		}
	}
}