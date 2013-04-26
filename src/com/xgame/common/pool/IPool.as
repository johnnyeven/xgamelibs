package com.xgame.common.pool
{
	public interface IPool
	{
		function add(key: Object, value: Object, callback: Function = null): void;
		function get(key: Object): Object;
		function remove(key: Object): void;
		function removeAll(): void;
		function contain(key: Object): Boolean;
	}
}