package com.xgame.common.behavior
{
	import com.xgame.common.display.BitmapDisplay;
	import com.xgame.configuration.GlobalContextConfig;
	import com.xgame.configuration.MapContextConfig;
	import com.xgame.core.Camera;
	import com.xgame.core.map.Map;
	
	import flash.geom.Point;

	public class Behavior
	{
		private var _halfSceneWidth: Number;
		private var _halfSceneHeight: Number;
		protected var _target: BitmapDisplay;
		
		public function Behavior()
		{
			_halfSceneWidth = GlobalContextConfig.Width / 2;
			_halfSceneHeight = GlobalContextConfig.Height / 2;
		}
		
		public function step(): void
		{
			calculatePosition();
		}
		
		protected function calculatePosition(): void
		{
			var targetX: Number;
			var targetY: Number;
			if(Camera.instance.focus == _target)
			{
				targetX = _target.positionX < _halfSceneWidth ? _target.positionX : _halfSceneWidth;
				targetY = _target.positionY < _halfSceneHeight ? _target.positionY : _halfSceneHeight;
				
				targetX = _target.positionX > (MapContextConfig.MapSize.x - _halfSceneWidth) ? (_target.positionX - (MapContextConfig.MapSize.x - GlobalContextConfig.Width)) : targetX;
				targetY = _target.positionY > (MapContextConfig.MapSize.y - _halfSceneHeight) ? (_target.positionY - (MapContextConfig.MapSize.y - GlobalContextConfig.Height)) : targetY;
			}
			else
			{
				var _point: Point = Map.instance.getScreenPosition(_target.positionX, _target.positionY);
				targetX = _point.x;
				targetY = _point.y;
			}
			
			_target.x = targetX;
			_target.y = targetY;
		}
		
		public function installListener(): void
		{
			
		}
		
		public function uninstallListener(): void
		{
			
		}
		
		public function dispose(): void
		{
			uninstallListener();
		}

		public function get target():BitmapDisplay
		{
			return _target;
		}

		public function set target(value:BitmapDisplay):void
		{
			_target = value;
		}
		
		public function changeDirectionByAngle(angle: int): void
		{
			if(_target == null)
			{
				return;
			}
			if(angle < -22.5)
			{
				angle += 360;
			}
			
//			if(angle>=-22.5 && angle<22.5)
//			{
//				_target.setDirectionNum(_me.directions.Up);
//			}
//			else if(angle>=22.5 && angle<67.5)
//			{
//				_target.setDirectionNum(_me.directions.RightUp);
//			}
//			else if(angle>=67.5 && angle<112.5)
//			{
//				_target.setDirectionNum(_me.directions.Right);
//			}
//			else if(angle>=112.5 && angle<157.5)
//			{
//				_me.setDirectionNum(_me.directions.RightDown);
//			}
//			else if(angle>=157.5 && angle<202.5)
//			{
//				_me.setDirectionNum(_me.directions.Down);
//			}
//			else if(angle>=202.5 && angle<247.5)
//			{
//				_me.setDirectionNum(_me.directions.LeftDown);
//			}
//			else if(angle>=247.5 && angle<292.5)
//			{
//				_me.setDirectionNum(_me.directions.Left);
//			}
//			else
//			{
//				_me.setDirectionNum(_me.directions.LeftUp);
//			}
		}
	}
}