package com.xgame.common.behavior
{
	import com.xgame.common.Vector2D;
	import com.xgame.common.display.BitmapDisplay;
	import com.xgame.common.display.TrackEffectDisplay;
	import com.xgame.core.map.Map;
	import com.xgame.core.scene.Scene;
	import com.xgame.events.SkillEvent;
	
	import flash.geom.Point;

	public class TrackSkillBehavior extends Behavior
	{
		private var _xEnd: Boolean = false;
		private var _yEnd: Boolean = false;
		protected var _currentVelocity: Number;
		protected var _velocity: Vector2D;
		
		public function TrackSkillBehavior()
		{
			super();
		}
		
		public function resetVelocity(): void
		{
			var _owner: TrackEffectDisplay = _target as TrackEffectDisplay;
			_velocity = new Vector2D(_owner.targetPosition.x - _owner.startPosition.x, _owner.targetPosition.y - _owner.startPosition.y);
			_currentVelocity = _owner.startVelocity;
			_velocity.length = _currentVelocity;
		}
		
		override public function step():void
		{
			physicsCalculation();
			calculatePosition();
		}
		
		protected function physicsCalculation(): void
		{
			var _owner: TrackEffectDisplay = _target as TrackEffectDisplay;
			if(_velocity != null)
			{
				_target.positionX += _velocity.x;
				_target.positionY += _velocity.y;
				
				if(!_xEnd && Math.abs(_owner.targetPosition.x - _target.positionX) <= Math.abs(_velocity.x))
				{
					_xEnd = true;
				}
				if(!_yEnd && Math.abs(_owner.targetPosition.y - _target.positionY) <= Math.abs(_velocity.y))
				{
					_yEnd = true;
				}
				if(_xEnd && _yEnd)
				{
					var evt: SkillEvent = new SkillEvent(SkillEvent.FIRE_COMPLETE);
					evt.skillId = _owner.skillId;
					evt.skillTarget = _owner.target;
					_owner.dispatchEvent(evt);
					Scene.instance.removeObject(_target);
				}
				_currentVelocity += .5;
				_velocity.x = _owner.targetPosition.x - _target.positionX;
				_velocity.y = _owner.targetPosition.y - _target.positionY;
				_velocity.length = _currentVelocity;
			}
		}
		
		override protected function calculatePosition():void
		{
			var position: Point = Map.instance.getScreenPosition(_target.positionX, _target.positionY);
			_target.x = position.x;
			_target.y = position.y;
		}
	}
}