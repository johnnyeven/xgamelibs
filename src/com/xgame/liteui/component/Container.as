package com.xgame.liteui.component
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import com.xgame.utils.UIUtils;
	import com.xgame.events.ui.ViewEvent;
	import com.xgame.liteui.core.Component;
	import com.xgame.liteui.core.IViewPort;
	
	public class Container extends Component implements IViewPort
	{
		private var _scrollContent: Sprite;
		private var _scrollRect: Rectangle;
		private var _oldMaxWidth: Number;
		private var _oldMaxHeight: Number;
		private var _measureSize: Rectangle;
		private var _hitArea: Shape;
		
		public function Container(_skin:DisplayObjectContainer=null)
		{
			super(null);
			_scrollContent = new Sprite();
			scrollRect = new Rectangle(0, 0, 1, 1);
			addChild(_scrollContent);
			
			if(_skin != null)
			{
				UIUtils.setCommonProperty(this, _skin);
				contentWidth = _skin.width;
				contentHeight = _skin.height;
				UIUtils.remove(_skin);
			}
			_hitArea = new Shape();
			addChild(_hitArea);
		}
		
		private function drawHitArea(): void
		{
			_hitArea.graphics.clear();
			_hitArea.graphics.beginFill(0xFFFFFF, 0);
			_hitArea.graphics.drawRect(0, 0, width, height);
			_hitArea.graphics.endFill();
		}
		
		public function get contentWidth():Number
		{
			return scrollRect.width;
		}
		
		public function set contentWidth(value: Number): void
		{
			var _rect: Rectangle = scrollRect.clone();
			_rect.width = value;
			scrollRect = _rect;
			dispatchEvent(new Event(Event.RESIZE));
		}
		
		public function get contentHeight():Number
		{
			return scrollRect.height;
		}
		
		public function set contentHeight(value: Number): void
		{
			var _rect: Rectangle = scrollRect.clone();
			_rect.height = value;
			scrollRect = _rect;
			dispatchEvent(new Event(Event.RESIZE));
		}
		
		public function get hScrollPosition():Number
		{
			return scrollRect.x;
		}
		
		public function set hScrollPosition(value:Number):void
		{
			var _rect: Rectangle = scrollRect.clone();
			value = Math.max(0, value);
			var _width: Number = Math.max(0, _measureSize.width - contentWidth);
			_rect.x = Math.min(_width, value);
			scrollRect = _rect;
		}
		
		public function get vScrollPosition():Number
		{
			return scrollRect.y;
		}
		
		public function set vScrollPosition(value:Number):void
		{
			var _rect: Rectangle = scrollRect.clone();
			value = Math.max(0, value);
			var _height: Number = Math.max(0, _measureSize.height - contentHeight);
			_rect.y = Math.min(_height, value);
			scrollRect = _rect;
		}
		
		public function get maxWidth():Number
		{
			measureSize();
			return _measureSize.width;
		}
		
		public function get maxHeight():Number
		{
			measureSize();
			return _measureSize.height;
		}
		
		override public function get scrollRect(): Rectangle
		{
			return _scrollRect;
		}
		
		override public function set scrollRect(value:Rectangle):void
		{
			_scrollRect = value;
			_scrollContent.scrollRect = value;
		}
		
		public function measureSize(): void
		{
			var _child: DisplayObject;
			_measureSize = new Rectangle();
			for(var i: int = 0; i<_scrollContent.numChildren; i++)
			{
				_child = _scrollContent.getChildAt(i);
				_measureSize.x = Math.min(_measureSize.x, _child.x);
				_measureSize.y = Math.min(_measureSize.y, _child.y);
				_measureSize.right = Math.max(_measureSize.right, _child.x + _child.width);
				_measureSize.bottom = Math.max(_measureSize.bottom, _child.y + _child.height);
			}
			if(_oldMaxWidth != _measureSize.width)
			{
				_oldMaxWidth = _measureSize.width;
				dispatchEvent(new ViewEvent(ViewEvent.MAX_WIDTH_CHANGE));
			}
			if(_oldMaxHeight != _measureSize.height)
			{
				_oldMaxHeight = _measureSize.height;
				dispatchEvent(new ViewEvent(ViewEvent.MAX_HEIGHT_CHANGE));
			}
			drawHitArea();
		}
		
		public function add(child: DisplayObject): void
		{
			_scrollContent.addChild(child);
			measureSize();
		}
		
		public function remove(child: DisplayObject): void
		{
			_scrollContent.removeChild(child);
			measureSize();
		}
		
		public function removeAll(): void
		{
			_scrollContent.removeChildren();
			measureSize();
		}
		
		public function addAt(child: DisplayObject, index: int): void
		{
			_scrollContent.addChildAt(child, index);
			measureSize();
		}
		
		public function removeAt(index: int): void
		{
			_scrollContent.removeChildAt(index);
			measureSize();
		}
		
		public function get childrenNum(): int
		{
			return _scrollContent.numChildren;
		}
		
		public function getAt(index: int): DisplayObject
		{
			return _scrollContent.getChildAt(index);
		}
	}
}