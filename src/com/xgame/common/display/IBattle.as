package com.xgame.common.display
{
	import flash.geom.Point;

	public interface IBattle
	{
		function isDead(): Boolean;
		function get healthMax(): Number;
		function set healthMax(value: Number): void;
		function get health(): Number;
		function set health(value: Number): void;
		function get manaMax(): Number;
		function set manaMax(value: Number): void;
		function get mana(): Number;
		function set mana(value: Number): void;
		function get energyMax(): Number;
		function set energyMax(value: Number): void;
		function get energy(): Number;
		function set energy(value: Number): void;
		function get attackRange(): Number;
		function set attackRange(value: Number): void;
		function get attackSpeed(): Number;
		function set attackSpeed(value: Number): void;
		function get attackCoolDown(): Number;
		function get attacker(): *;
		function set attacker(value: *): void;
		function get attackerPosition(): Point;
		function get locker(): BitmapDisplay;
		function set locker(value:BitmapDisplay):void;
		function prepareAttack(o: *): void;
		function attack(): void;
		function underAttack(damage: Number): void;
	}
}