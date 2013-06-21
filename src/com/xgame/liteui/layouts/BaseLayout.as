package com.xgame.liteui.layouts
{
	import flash.display.DisplayObjectContainer;

	public class BaseLayout
	{
		protected var _container: DisplayObjectContainer;
		protected var _measureWidth: Number = 0;
		protected var _measureHeight: Number = 0;
		private var _hGap: Number = 0;
		private var _vGap: Number = 0;
		
		public function BaseLayout(container: DisplayObjectContainer = null)
		{
			_container = container;
		}
		
		public function update(): void
		{
		}
		
		public function get container(): DisplayObjectContainer
		{
			return _container;
		}
		
		public function set container(value:DisplayObjectContainer):void
		{
			_container = value;
		}

		public function get hGap():Number
		{
			return _hGap;
		}

		public function set hGap(value:Number):void
		{
			_hGap = value;
		}

		public function get vGap():Number
		{
			return _vGap;
		}

		public function set vGap(value:Number):void
		{
			_vGap = value;
		}

		public function get measureWidth():Number
		{
			return _measureWidth;
		}

		public function get measureHeight():Number
		{
			return _measureHeight;
		}
		
		public function dispose(): void
		{
			_container = null;
		}
	}
}