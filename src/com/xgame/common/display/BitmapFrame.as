package com.xgame.common.display
{
	import flash.display.BitmapData;

	public class BitmapFrame extends Object
	{
		public var offsetX: Number;
		public var offsetY: Number;
		public var bitmapData: BitmapData;
		public var label: String;
		
		public function BitmapFrame()
		{
			super();
		}
		
		public function dispose(): void
		{
			if(bitmapData != null)
			{
				bitmapData.dispose();
				bitmapData = null;
			}
		}
	}
}