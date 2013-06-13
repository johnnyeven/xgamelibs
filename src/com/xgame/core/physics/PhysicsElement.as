package com.xgame.core.physics
{
	import com.xgame.common.Vector2D;

	public class PhysicsElement implements IPhysics
	{
		private var _x: Number;
		private var _y: Number;
		private var _currentVelocity: Number;
		private var _velocity: Vector2D;
		private var _force: Vector2D;
		private const MAX_VELOCITY: Number = 20;
		
		public function PhysicsElement(x: Number = 0, y: Number = 0)
		{
			_x = x;
			_y = y;
			_velocity = new Vector2D();
			_force = new Vector2D();
		}
		
		public function step(): void
		{
			if(_velocity.length < MAX_VELOCITY)
			{
				_velocity.x += _force.x;
				_velocity.y += _force.y;
			}
			
			_x += _velocity.x;
			_y += _velocity.y;
		}

		public function get x():Number
		{
			return _x;
		}

		public function get y():Number
		{
			return _y;
		}

		public function applyVelocity(x: Number, y: Number): void
		{
			_velocity.x = x;
			_velocity.y = y;
		}
		
		public function applyForce(x: Number, y: Number): void
		{
			_force.x = x;
			_force.y = y;
		}

		public function get velocity():Vector2D
		{
			return _velocity;
		}

		public function get force():Vector2D
		{
			return _force;
		}


	}
}