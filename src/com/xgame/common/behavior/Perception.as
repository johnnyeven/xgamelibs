package com.xgame.common.behavior
{
	
	import com.xgame.common.display.BitmapDisplay;
	import com.xgame.core.map.Map;
	import com.xgame.core.scene.Scene;
	import com.xgame.ns.NSCamera;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author john
	 */
	public class Perception 
	{
		public function Perception() 
		{
		}
		
		public static function getNearestTarget(): BitmapDisplay
		{
			return Scene.instance.getDisplay(0);
		}
		
		/**
		 * 根据坐标距离返回碰撞目标
		 * @param	_targetPos
		 * @param	checkAttackable
		 * @param	checkDistance
		 * @return
		 */
		public static function getTargetByPos(_targetPos: Point, checkAttackable:Boolean = false, checkDistance:uint = 15): BitmapDisplay
		{
			var standbyArray: Array = Scene.instance.renderList;
			var hitList: Array = new Array();
			for each(var o: BitmapDisplay in standbyArray)
			{
				if (o == Scene.instance.player || !o.NSCamera::inScene)
				{
					continue;
				}
				if (checkAttackable && !o.canBeAttack)
				{
					continue;
				}
				var _distance: Number = getDistanceByPoint(o, _targetPos);
				if (_distance < checkDistance)
				{
					hitList.push(o);
				}
			}
			if (hitList.length == 0)
			{
				return null;
			}
			hitList.sortOn("zIndex", Array.DESCENDING);
			return hitList[0];
		}
		
		/**
		 * 根据点击区域返回点击目标
		 * @param	_targetPos
		 * @param	checkAttackable
		 * @param	excludeCurrentObject
		 * @return
		 */
		public static function getTargetByRect(_targetPos: Point, checkAttackable:Boolean = false, excludeCurrentObject: Boolean = true): BitmapDisplay
		{
			var standbyArray: Array = Scene.instance.renderList;
			var hitList: Array = new Array();
			for each(var o: BitmapDisplay in standbyArray)
			{
				if (excludeCurrentObject && o == Scene.instance.player)
				{
					continue;
				}
				if (!o.NSCamera::inScene)
				{
					continue;
				}
				if (checkAttackable && !o.canBeAttack)
				{
					continue;
				}
				if (o.hitTestPoint(_targetPos.x, _targetPos.y))
				{
					hitList.push(o);
				}
			}
			if (hitList.length == 0)
			{
				return null;
			}
			hitList.sortOn("zIndex", Array.DESCENDING);
			return hitList[0];
		}
		
		public static function getTargetByGraphic(_targetPos: Point, checkAttackable:Boolean = false, excludeCurrentObject: Boolean = true): BitmapDisplay
		{
			var standbyArray: Array = Scene.instance.renderList;
			var hitList: Array = new Array();
			var x: Number, y:Number;
			var testInstance: BitmapData;
			
			for each(var o: BitmapDisplay in standbyArray)
			{
				//TODO EffectDisplay
//				if (o is CEffectObject)
//				{
//					continue;
//				}
				if (excludeCurrentObject && o == Scene.instance.player)
				{
					continue;
				}
				if (!o.NSCamera::inScene)
				{
					continue;
				}
				if (checkAttackable && !o.canBeAttack)
				{
					continue;
				}
//				if ((o as IAttackable).isDead)
//				{
//					continue;
//				}
				x = int(_targetPos.x - (o.positionX - (o.graphic.frameWidth / 2)));
				y = int(_targetPos.y - (o.positionY - (o.graphic.frameHeight)));
				
				if (x > o.graphic.frameWidth || x < 0)
				{
					continue;
				}
				if (y > o.graphic.frameHeight || y < 0)
				{
					continue;
				}
				
				try
				{
					testInstance = o.graphic.bitmapArray[o.renderLine][o.renderFrame].bitmapData;
					if (testInstance.hitTest(new Point(), 0xFFFFFF, new Point(x, y)))
					{
						return o;
					}
				}
				catch (err: Error)
				{
					return null;
				}
			}
			return null;
		}
		
		/**
		 * 获取点击对象
		 * @param	x
		 * @param	y
		 * @return
		 */
		public static function getClicker(x: Number, y: Number): BitmapDisplay
		{
			var point: Point = Map.instance.getWorldPosition(x, y);
			return getTargetByGraphic(point);
		}
		
		public static function getDistance(target1: BitmapDisplay, target2: BitmapDisplay): Number
		{
			return Math.sqrt(Math.pow(target1.positionX - target2.positionX, 2) + Math.pow(target1.positionY - target2.positionY, 2));
		}
		
		public static function getDistanceByPoint(target1: BitmapDisplay, target2: Point): Number
		{
			return Math.sqrt(Math.pow(target1.positionX - target2.x, 2) + Math.pow(target1.positionY - target2.y, 2));
		}
	}

}