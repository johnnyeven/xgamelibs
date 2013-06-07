package com.xgame.common.display
{
	import com.xgame.common.behavior.Behavior;
	import com.xgame.common.behavior.MainPlayerBehavior;
	import com.xgame.common.behavior.Perception;
	import com.xgame.configuration.GlobalContextConfig;
	import com.xgame.core.map.Map;
	import com.xgame.enum.Action;
	import com.xgame.events.BehaviorEvent;
	
	import flash.geom.Point;
	
	public class CharacterDisplay extends ActionDisplay implements IBattle
	{
		protected var _locker: BitmapDisplay;
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
		
		protected var _characterName: String;
		protected var _characterLevel: uint;
		
		public function CharacterDisplay()
		{
			super(new MainPlayerBehavior());
			canBeAttack = true;
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
			if(o is BitmapDisplay)
			{
				if((o as BitmapDisplay).canBeAttack)
				{
					_attacker = o;
				}
				else
				{
					return;
				}
			}
			else if(o is Point)
			{
				_attacker = o;
			}
			followDistance = _attackRange;
			if(Perception.getDistanceByPoint(this, attackerPosition) <= _attackRange)
			{
				attack();
			}
			else
			{
				_behavior.addEventListener(BehaviorEvent.MOVE_IN_POSITION, onMoveInPosition);
				(_behavior as MainPlayerBehavior).moveKeepDistance(attackerPosition.x, attackerPosition.y, followDistance);
			}
		}
		
		protected function onMoveInPosition(evt: BehaviorEvent): void
		{
			if (_attacker != null)
			{
				if(Perception.getDistanceByPoint(this, attackerPosition) <= _attackRange)
				{
					_behavior.removeEventListener(BehaviorEvent.MOVE_IN_POSITION, onMoveInPosition);
					attack();
				}
				else
				{
					(_behavior as MainPlayerBehavior).moveKeepDistance(attackerPosition.x, attackerPosition.y, followDistance);
				}
			}
		}
		
		public function attack():void
		{
			if(_attacker == null)
			{
				return;
			}
			if(_attacker is BitmapDisplay)
			{
				if(!(_attacker as BitmapDisplay).canBeAttack)
				{
					return;
				}
			}
			action = Action.ATTACK;
			
			var speed: Number = 1000 / _attackSpeed;
			_playTime = _playTime > speed ? speed : _playTime;
			_lastAttackTime = GlobalContextConfig.Timer;
		}
		
		public function underAttack(damage:Number):void
		{
			if (damage >= _health)
			{
				_health = 0;
				action = Action.DIE;
			}
			else
			{
				_health -= damage;
			}
		}
		
		override protected function step():Boolean
		{
			if(!super.step())
			{
				return false;
			}
			_buffer.alpha = Map.instance.inAlphaArea(positionX, positionY) ? .5 : 1;
			return true;
		}

		public function get characterName():String
		{
			return _characterName;
		}

		public function set characterName(value:String):void
		{
			_characterName = value;
		}

		public function get characterLevel():uint
		{
			return _characterLevel;
		}

		public function set characterLevel(value:uint):void
		{
			_characterLevel = value;
		}

		public function get locker():BitmapDisplay
		{
			return _locker;
		}

		public function set locker(value:BitmapDisplay):void
		{
			_locker = value;
		}


	}
}