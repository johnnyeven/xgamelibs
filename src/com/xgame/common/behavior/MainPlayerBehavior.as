package com.xgame.common.behavior
{
	import com.xgame.common.display.ActionDisplay;
	import com.xgame.common.display.BitmapDisplay;
	import com.xgame.common.display.IAttackable;
	import com.xgame.core.map.Map;
	import com.xgame.core.scene.Scene;
	import com.xgame.enum.Action;
	import com.xgame.utils.Angle;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class MainPlayerBehavior extends Behavior
	{
		protected var _currentStep: uint;
		protected var _path: Array;
		
		public function MainPlayerBehavior()
		{
			super();
			
			_currentStep = 1;
			installListener();
		}
		
		override public function installListener():void
		{
			Scene.instance.stage.addEventListener(MouseEvent.CLICK, onMouseClick, false, 0, true);
		}
		
		override public function uninstallListener():void
		{
			Scene.instance.stage.removeEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		public function clearPath(): void
		{
			if(_path == null)
			{
				return;
			}
			(_target as ActionDisplay).action = Action.STOP;
			_path.splice(0, _path.length);
			_path = null;
			_currentStep = 1;
		}
		
		private function onMouseClick(evt: MouseEvent): void
		{
			if((_target as ActionDisplay).action == Action.DIE)
			{
				return;
			}
			
			var clicker: BitmapDisplay = Perception.getClicker(evt.stageX, evt.stageY);
			if(clicker != null)
			{
				//TODO 激活点击事件
				return;
			}
			
			_endPoint = Map.instance.getWorldPosition(evt.stageX, evt.stageY);
			move();
		}
		
		protected function move(): Boolean
		{
			if(_path == null)
			{
				_path = new Array();
			}
			else
			{
				_path.splice(0, _path.length);
			}
			
			var _point1: Point;
			var _point2: Point;
			if(Map.instance.astar == null)
			{
				_point1 = Map.instance.worldPosition2Block(_target.positionX, _target.positionY);
				_path.push([_point1.x, _point1.y]);
				_point2 = Map.instance.worldPosition2Block(_endPoint.x, _endPoint.y);
				_path.push([_point2.x, _point2.y]);
			}
			else
			{
				_point1 = Map.instance.worldPosition2Block(_endPoint.x, _endPoint.y);
				if(Map.instance.negativePath[_point1.y][_point1.x])
				{
					(_target as ActionDisplay).action = Action.STOP;
					return false;
				}
				
				var node: Array = Map.instance.astar.find(_target.positionX, _target.positionY, _endPoint.x, _endPoint.y);
				if(node == null)
				{
					(_target as ActionDisplay).action = Action.STOP;
					return false;
				}
				else
				{
					for(var i: int = 0; i < node.length; i++)
					{
						_path.push([node[i].x, node[i].y]);
					}
				}
			}
			_currentStep = 1;
			
			return true;
		}
		
		protected function moveTo(x: Number, y: Number): void
		{
			if((_target as ActionDisplay).action != Action.DIE)
			{
				_target.positionX = x;
				_target.positionY = y;
			
				(_target as ActionDisplay).action = Action.MOVE;
			}
		}
		
		override protected function calculatePosition():void
		{
			super.calculatePosition();
			
			if((_target as ActionDisplay).action == Action.DIE)
			{
				return;
			}
			if(_path != null && _path[_currentStep] != null)
			{
				if((_target as ActionDisplay).action != Action.MOVE)
				{
					(_target as ActionDisplay).action = Action.MOVE;
				}
				
				_nextPoint = _currentStep == _path.length ? _endPoint : Map.instance.block2WorldPosition(_path[_currentStep][0], _path[_currentStep][1]);
				
				var radian: Number = Angle.getAngle(_nextPoint.x - _target.positionX, _nextPoint.y - _target.positionY);
				var angle: int = int(Angle.radian2Angle(radian)) + 90;
				
				var xEnd: Boolean = false;
				var yEnd: Boolean = false;
				
				var xSpeed: Number = _target.speed * Math.cos(radian);
				var ySpeed: Number = _target.speed * Math.sin(radian);
				
				if(Math.abs(_target.positionX - _nextPoint.x) <= xSpeed)
				{
					xEnd = true;
					xSpeed = 0;
				}
				if(Math.abs(_target.positionY - _nextPoint.y) <= ySpeed)
				{
					yEnd = true;
					ySpeed = 0;
				}
				
				moveTo(_target.positionX + xSpeed, _target.positionY + ySpeed);
				
				if(xEnd && yEnd)
				{
					_currentStep++;
					if(_currentStep >= _path.length)
					{
						stopMovement();
					}
				}
				else
				{
					changeDirectionByAngle(angle);
				}
			}
		}
		
		protected function stopMovement(action: int = -1): void
		{
			(_target as ActionDisplay).action = action == -1 ? Action.STOP : action;
			clearPath();
		}
	}
}