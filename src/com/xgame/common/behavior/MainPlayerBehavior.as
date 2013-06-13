package com.xgame.common.behavior
{
	import com.xgame.common.Vector2D;
	import com.xgame.common.display.ActionDisplay;
	import com.xgame.common.display.BitmapDisplay;
	import com.xgame.common.display.CharacterDisplay;
	import com.xgame.common.display.IBattle;
	import com.xgame.core.map.Map;
	import com.xgame.core.scene.Scene;
	import com.xgame.core.skill.SkillController;
	import com.xgame.enum.Action;
	import com.xgame.events.BehaviorEvent;
	import com.xgame.utils.Angle;
	
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class MainPlayerBehavior extends Behavior
	{
		protected var _currentStep: uint;
		protected var _path: Array;
		protected var _skillTarget: *;
		
		public function MainPlayerBehavior()
		{
			super();
			
			_currentStep = 1;
			installListener();
		}
		
		override public function installListener():void
		{
			Scene.instance.stage.addEventListener(MouseEvent.CLICK, onMouseClick, false, 0, true);
			Scene.instance.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, false, 0, true);
		}
		
		override public function uninstallListener():void
		{
			Scene.instance.stage.removeEventListener(MouseEvent.CLICK, onMouseClick);
			Scene.instance.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
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
		
		private function onKeyDown(evt: KeyboardEvent): void
		{
			if((_target as IBattle).locker != null)
			{
				_skillTarget = (_target as IBattle).locker;
			}
			else
			{
				_skillTarget = Map.instance.getWorldPosition(Scene.instance.stage.mouseX, Scene.instance.stage.mouseY);
			}
			_skill.prepareSkill("skill1", _skillTarget);
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
				(_target as CharacterDisplay).locker = clicker;
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
		
		public function moveKeepDistance(x: Number, y: Number, distance: Number = -1): void
		{
			var _this: CharacterDisplay = _target as CharacterDisplay;
			if(_this.attacker != null)
			{
				if(Perception.getDistanceByPoint(_this, _this.attackerPosition) <= distance)
				{
					return;
				}
			}
			else
			{
				return;
			}
			
			_endPoint = new Point(x, y);
			if(distance <= 0)
			{
				move();
				return;
			}
			
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
					return;
				}
				
				var node: Array = Map.instance.astar.find(_target.positionX, _target.positionY, _endPoint.x, _endPoint.y);
				if(node == null)
				{
					(_target as ActionDisplay).action = Action.STOP;
					return;
				}
				else
				{
					var index: int = getNearestPathIndex(node, x, y, distance);
					var newNode: Point;
					if (index != -1)
					{
						var vector: Vector2D;
						var temp: Point = Map.instance.block2WorldPosition(node[index].x, node[index].y);
						var temp2: Point = Map.instance.block2WorldPosition(node[index + 1].x, node[index + 1].y);
						if (index >= node.length -1)
						{
							vector = new Vector2D(temp.x - _this.attackerPosition.x, temp.y - _this.attackerPosition.y);
						}
						else
						{
							vector = new Vector2D(temp.x - temp2.x, temp.y - temp2.y);
						}
						vector.length = distance - 5;
						
						newNode = Map.instance.worldPosition2Block(temp2.x + vector.x, temp2.y + vector.y);
					}
					else
					{
						moveKeepDistance(_this.attackerPosition.x, _this.attackerPosition.y, distance);
						return;
					}
					
					_path = new Array();
					for (var i: uint = 0; i <= index; i++)
					{
						_path.push([node[i].x, node[i].y]);
						if (i == index)
						{
							_path.push([newNode.x, newNode.y]);
						}
					}
					_endPoint = Map.instance.block2WorldPosition(_path[_path.length - 1][0], _path[_path.length - 1][1]);
				}
			}
			_currentStep = 1;
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
						_eventDispatcher.dispatchEvent(new BehaviorEvent(BehaviorEvent.MOVE_IN_POSITION));
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
			clearPath();
			(_target as ActionDisplay).action = action == -1 ? Action.STOP : action;
		}
		
		private function getNearestPathIndex(node: Array, x: Number, y: Number, distance: Number): int
		{
			var _this: CharacterDisplay = _target as CharacterDisplay;
			var _point: Point;
			for(var i: int = node.length - 1; i >= 0; i--)
			{
				_point = Map.instance.block2WorldPosition(node[i].x, node[i].y);
				if(_this.attacker != null)
				{
					if(Point.distance(_point, _this.attackerPosition) > distance)
					{
						return i;
					}
				}
				else
				{
					if(Point.distance(_point, new Point(x, y)) > distance)
					{
						return i;
					}
				}
			}
			return -1;
		}
		
		override public function set target(value:BitmapDisplay):void
		{
			_target = value;
			_skill = new SkillController();
			_skill.target = value;
		}
	}
}