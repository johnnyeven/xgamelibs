package com.xgame.liteui.core
{
	import flash.events.IEventDispatcher;

	public interface IViewPort extends IEventDispatcher
	{
		function get contentWidth(): Number;
		function get contentHeight(): Number;
		function get hScrollPosition(): Number;
		function set hScrollPosition(value: Number): void;
		function get vScrollPosition(): Number;
		function set vScrollPosition(value: Number): void;
		function get maxWidth(): Number;
		function get maxHeight(): Number;
	}
}