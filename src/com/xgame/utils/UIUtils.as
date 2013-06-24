package com.xgame.utils
{
	import com.xgame.core.GameManager;
	import com.xgame.core.scene.Scene;
	import com.xgame.liteui.core.Component;
	
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class UIUtils
	{
		public function UIUtils()
		{
		}
		
		public static function remove(child: DisplayObject): void
		{
			if(child.parent != null)
			{
				child.parent.removeChild(child);
			}
		}
		
		public static function center(target: DisplayObject): void
		{
			var _stageCenter: Point = stageCenter;
			target.x = _stageCenter.x - (target.width * target.scaleX) / 2;
			target.y = _stageCenter.y - (target.height * target.scaleY) / 2;
		}
		
		public static function getSkinSize(target: DisplayObject): Point
		{
			var source: Point = new Point(target.width, target.height);
			var zero: Point = new Point(0, 0);
			
			if(target.parent != null)
			{
				source = target.parent.localToGlobal(source);
				zero = target.parent.localToGlobal(zero);
			}
			
			return source.subtract(zero);
		}
		
		public static function restoreSkinSize(target: DisplayObject): void
		{
			var _size: Point = getSkinSize(target);
			if(_size.x == 0 || _size.y == 0)
			{
				return;
			}
			target.width = _size.x;
			target.height = _size.y;
		}
		
		public static function setCommonProperty(target: Component, source: DisplayObject): void
		{
			target.name = source.name;
			target.x = source.x;
			target.y = source.y;
		}
		
		private static function get stageCenter(): Point
		{
			var _stage: Stage = GameManager.container;
			
			return new Point(_stage.stageWidth / 2, _stage.stageHeight / 2);
		}
		
		public static function componentCenterInStage(comp: DisplayObject, width: Number = NaN, height: Number = NaN): Point
		{
			var _stage: Stage = GameManager.container;
			var _rect: Rectangle = comp.getBounds(comp);
			
			if(!isNaN(width))
			{
				_rect.width = width;
			}
			if(!isNaN(height))
			{
				_rect.height = height;
			}
			
			var x: Number = (_stage.stageWidth - _rect.width * comp.scaleX) / 2;
			var y: Number = (_stage.stageHeight - _rect.height * comp.scaleY) / 2;
			
			return new Point(x, y);
		}
	}
}