package com.xgame.common.display
{
	import com.xgame.common.behavior.Behavior;
	import com.xgame.enum.Action;
	
	import flash.geom.Point;
	
	public class CharacterDisplay extends ActionDisplay implements IBattle
	{
		protected var _attacker: *;
		protected var _health: Number;
		protected var _healthMax: Number;
		protected var _mana: Number;
		protected var _manaMax: Number;
		protected var _energy: Number;
		protected var _energyMax: Number;
		protected var _attackSpeed: Number;
		protected var _attackRange: Number;
		
		protected var _lastAttackTime: int;
		
		public function CharacterDisplay(behavior:Behavior=null)
		{
			super(behavior);
		}
		
		public function isDead():Boolean
		{
			return _action == Action.DIE;
		}
		
		public function get healthMax():Number
		{
			return _healthMax;
		}
		
		public function set healthMax(value:Number):void
		{
			_healthMax = _healthMax > 0 ? _healthMax : 0;
		}
		
		public function get health():Number
		{
			return _health;
		}
		
		public function set health(value:Number):void
		{
			_health = _health > _healthMax ? _healthMax : _health;
		}
		
		public function get manaMax():Number
		{
			return _manaMax;
		}
		
		public function set manaMax(value:Number):void
		{
			_manaMax = _manaMax > 0 ? _manaMax : 0;
		}
		
		public function get mana():Number
		{
			return _mana;
		}
		
		public function set mana(value:Number):void
		{
			_mana = _mana > _manaMax ? _manaMax : _mana;
		}
		
		public function get energyMax():Number
		{
			return _energyMax;
		}
		
		public function set energyMax(value:Number):void
		{
			_energyMax = _energyMax > 0 ? _energyMax : 0;
		}
		
		public function get energy():Number
		{
			return _energy;
		}
		
		public function set energy(value:Number):void
		{
			_energy = _energy > _energyMax ? _energyMax : _energy;
		}
		
		public function get attackRange():Number
		{
			return _attackRange;
		}
		
		public function set attackRange(value:Number):void
		{
			_attackRange = value;
		}
		
		public function get attackSpeed():Number
		{
			return _attackSpeed;
		}
		
		public function set attackSpeed(value:Number):void
		{
			_attackSpeed = value;
		}
		
		public function get attackCoolDown():Number
		{
			return (1 / _attackSpeed) * 1000;
		}
		
		public function get attacker():*
		{
			return _attacker;
		}
		
		public function set attacker(value:*):void
		{
			_attacker = value;
		}
		
		public function get attackerPosition():Point
		{
			if (_attacker != null)
			{
				if (_attacker is BitmapDisplay)
				{
					return new Point((_attacker as BitmapDisplay).positionX, (_attacker as BitmapDisplay).positionY);
				}
				else if (_attacker is Point)
				{
					return _attacker as Point;
				}
				else
				{
					trace(_attacker.toString());
				}
			}
			return null;
		}
		
		public function prepareAttack(o:*):void
		{
		}
		
		public function attack():void
		{
		}
		
		public function underAttack(damage:Number):void
		{
		}
	}
}