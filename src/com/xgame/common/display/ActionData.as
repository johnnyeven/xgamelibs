package com.xgame.common.display
{
	public class ActionData
	{
		public var action: int;
		public var frameTotal: uint;
		public var lineTotal: uint;
		public var fps: Number;
		
		
		public function ActionData(_action: int = 0, _frameTotal: uint = 1, _lineTotal: uint = 1, _fps: Number = 0)
		{
			action = _action;
			frameTotal = _frameTotal;
			lineTotal = _lineTotal;
			fps = _fps;
		}
	}
}