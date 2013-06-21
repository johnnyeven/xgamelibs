package com.xgame.liteui.layouts
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	import utils.liteui.component.Container;
	
	public class HorizontalTileLayout extends BaseLayout
	{
		public function HorizontalTileLayout(container:DisplayObjectContainer=null)
		{
			super(container);
		}
		
		override public function update():void
		{
			super.update();
			var containerWidth: Number = _container.width;
			var containerChildrenNum: Number = _container.numChildren;
			var containerGetChildAt: Function = _container.getChildAt;
			
			if(_container is Container)
			{
				containerWidth = (_container as Container).contentWidth;
				containerChildrenNum = (_container as Container).childrenNum;
				containerGetChildAt = (_container as Container).getAt;
			}
			
			var child: DisplayObject;
			var _x: Number = 0;
			var _y: Number = 0;
			var childMaxHeight: Number = 0;
			for(var i: int = 0; i<containerChildrenNum; i++)
			{
				child = containerGetChildAt(i);
				if(child != null)
				{
					if(_x + child.width > containerWidth)
					{
						_x = 0;
						_y += (childMaxHeight + vGap);
						childMaxHeight = 0;
					}
					child.x = _x;
					child.y = _y;
					_x += (child.width + hGap);
					childMaxHeight = Math.max(child.height, childMaxHeight);
				}
			}
			_measureHeight = _y + childMaxHeight - vGap;
			
			if(_y > 0)
			{
				_measureWidth = containerWidth;
			}
			else
			{
				_measureWidth = _x - hGap;
			}
		}
	}
}