package com.xgame.common.display
{
	import com.xgame.common.behavior.Behavior;
	import com.xgame.core.map.Map;
	import com.xgame.core.scene.Scene;
	
	import flash.geom.Point;
	
	public class EffectDisplay extends BitmapMovieDispaly
	{
		protected var _owner: BitmapDisplay;
		protected var _target: *;
		protected var _effectId: String;
		protected var _isTargetSet: Boolean = false;
		
		public function EffectDisplay(behavior:Behavior=null)
		{
			super(behavior);
			canBeAttack = false;
		}
		
		public function get effectId():String
		{
			return _effectId;
		}

		public function get target():*
		{
			return _target;
		}

		public function set target(value:*):void
		{
			if(value != null)
			{
				_target = value;
				_isTargetSet = true;
			}
		}

		public function get owner():BitmapDisplay
		{
			return _owner;
		}
		
		public function set owner(value:BitmapDisplay):void
		{
			_owner = value;
		}
		
		override public function get renderLine():uint
		{
			return 0;
		}
		
		override public function update():void
		{
			if(_isTargetSet)
			{
				super.update();
			}
		}
		
		override protected function updateActionPre():void
		{
			super.updateActionPre();
			if(parentDisplay != null)
			{
				x = positionX;
				y = positionY;
			}
			else
			{
				var pos: Point = Map.instance.getScreenPosition(positionX, positionY);
				x = pos.x;
				y = pos.y;
			}
		}
		
		override protected function updateActionAfter(): void
		{
			return;
		}
		
		override public function set graphic(value:ResourceData):void
		{
			super.graphic = value;
			_graphic.currentAction = 0;
		}
		
		public function get targetPosition(): Point
		{
			if(_target is BitmapDisplay)
			{
				return new Point((_target as BitmapDisplay).positionX, (_target as BitmapDisplay).positionY);
			}
			else if(_target is Point)
			{
				return _target as Point;
			}
			return null;
		}
	}
}