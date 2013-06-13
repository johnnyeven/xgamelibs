package com.xgame.common.behavior
{
	import com.xgame.common.Vector2D;
	import com.xgame.common.display.BitmapDisplay;
	import com.xgame.common.display.TrackEffectDisplay;
	import com.xgame.core.map.Map;
	import com.xgame.core.physics.PhysicsElement;
	import com.xgame.core.scene.Scene;
	import com.xgame.events.SkillEvent;
	import com.xgame.utils.debug.Debug;
	
	import flash.geom.Point;

	public class TrackSkillBehavior extends Behavior
	{
		private var _xEnd: Boolean = false;
		private var _yEnd: Boolean = false;
		protected var _velocity: Vector2D;
		protected var _force: Vector2D;
		protected var _physics: PhysicsElement;
		protected const MAX_VELOCITY: Number = 50;
		
		public function TrackSkillBehavior()
		{
			super();
		}
		
		override public function set target(value:BitmapDisplay):void
		{
			_target = value;
			var _owner: TrackEffectDisplay = _target as TrackEffectDisplay;
			_physics = new PhysicsElement(_target.positionX, _target.positionY);
			resetVelocity();
			_force = new Vector2D(_owner.targetPosition.x - _target.positionX, _owner.targetPosition.y - _target.positionY);
			_force.length = 6;
			_physics.applyVelocity(_velocity.x, _velocity.y);
			_physics.applyForce(_force.x, _force.y);
		}
		
		public function resetVelocity(): void
		{
			var _owner: TrackEffectDisplay = _target as TrackEffectDisplay;
			_velocity = new Vector2D(-10, -10);
			Debug.info(this, _velocity);
		}
		
		override public function step():void
		{
			_physics.step();
			physicsCalculation();
			calculatePosition();
		}
		
		protected function physicsCalculation(): void
		{
			var _owner: TrackEffectDisplay = _target as TrackEffectDisplay;
			_target.positionX = _physics.x;
			_target.positionY = _physics.y;
			if(!_xEnd && Math.abs(_owner.targetPosition.x - _target.positionX) <= Math.abs(_physics.velocity.x))
			{
				_xEnd = true;
				_physics.velocity.x = 0;
			}
			if(!_yEnd && Math.abs(_owner.targetPosition.y - _target.positionY) <= Math.abs(_physics.velocity.y))
			{
				_yEnd = true;
				_physics.velocity.y = 0;
			}
			if(_xEnd && _yEnd)
			{
				var evt: SkillEvent = new SkillEvent(SkillEvent.FIRE_COMPLETE);
				evt.skillId = _owner.skillId;
				evt.skillTarget = _owner.target;
				_owner.dispatchEvent(evt);
				Scene.instance.removeObject(_target);
			}
			_force.x = _owner.targetPosition.x - _target.positionX;
			_force.y = _owner.targetPosition.y - _target.positionY;
			_force.length = 1;
			_physics.applyForce(_force.x, _force.y);
		}
		
		override protected function calculatePosition():void
		{
			var position: Point = Map.instance.getScreenPosition(_target.positionX, _target.positionY);
			_target.x = position.x;
			_target.y = position.y;
		}
	}
}