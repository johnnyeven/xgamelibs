package com.xgame.liteui.component
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import com.xgame.events.ui.MenuEvent;
	import com.xgame.liteui.core.Component;
	import com.xgame.liteui.layouts.Margin;
	import com.xgame.common.pool.ResourcePool;
	
	public class Menu extends Component
	{
		private var _bg: MovieClip;
		private var _itemList: Dictionary;
		private var _callbackList: Dictionary;
		private var _padding: Margin;
		private var _width: Number = 0;
		private var _height: Number = 0;
		public static var _itemMargin: Margin = new Margin(3, 0, 3, 0);
		
		public function Menu(_skin:DisplayObjectContainer=null)
		{
			if(_skin == null)
			{
				_skin = ResourcePool.instance.getDisplayObject("ui.menu.BG") as DisplayObjectContainer;
			}
			super(_skin);
			
			_bg = getSkin("bg") as MovieClip;
			_itemList = new Dictionary();
			_callbackList = new Dictionary();
			_padding = new Margin(20, 20, 20, 20);
		}
		
		public function addItem(_item: MenuItem, _onClick: Function = null): void
		{
			_itemList[_item.itemName] = _item;
			_callbackList[_item.itemName] = _onClick;
			_item.parentMenu = this;
			_item.addEventListener(MouseEvent.CLICK, onItemClick);
			addChild(_item);
			update();
		}
		
		protected function onItemClick(evt: MouseEvent): void
		{
			var _item: MenuItem = evt.target as MenuItem;
			var _evt: MenuEvent = new MenuEvent(MenuEvent.ITEM_CLICK);
			_evt.itemName = _item.itemName;
			
			if(_callbackList[_item.itemName] != null)
			{
				var _callback: Function = _callbackList[_item.itemName] as Function;
				_callback(_evt);
			}
			evt.stopImmediatePropagation();
		}
		
		public function removeItem(_item: MenuItem): void
		{
			delete _itemList[_item.itemName];
			delete _callbackList[_item.itemName];
			removeChild(_item);
			_item.dispose();
			update();
		}
		
		public function removeItemByName(_itemName: String): void
		{
			var _item: MenuItem = _itemList[_itemName] as MenuItem
			delete _itemList[_itemName];
			delete _callbackList[_itemName];
			if(_item != null)
			{
				removeChild(_item);
				_item.dispose();
			}
			update();
		}
		
		public function update(): void
		{
			var _lastItem: MenuItem;
			var _item: MenuItem;
			var _width: Number = 0;
			var _height: Number = 0;
			var _left: Number;
			var _right: Number;
			var _top: Number;
			var _bottom: Number;
			
			for each(_item in _itemList)
			{
				_left = _item.margin.left;
				_right = _item.margin.right;
				_top = _item.margin.top;
				_bottom = _item.margin.bottom;
				
				_item.x = _padding.left + _left;
				if(_lastItem != null)
				{
					_item.y = _lastItem.y + _lastItem.height + _top + _bottom;
				}
				else
				{
					_item.y = _padding.top + _top;
				}
				_lastItem = _item;
				_width = Math.max(_width, _lastItem.width + _left + _right);
				_height += _item.height + _top + _bottom;
				_item.update();
			}
			_width += _padding.right + _padding.left;
			_height += _padding.bottom + _padding.top;
			
			this._width = _width;
			this._height = _height;
			if(_bg != null)
			{
				_bg.width = _width;
				_bg.height = _height;
			}
		}
		
		override public function dispose():void
		{
			var _item: MenuItem;
			for each(_item in _itemList)
			{
				if(_item.childMenu != null)
				{
					_item.childMenu.dispose();
				}
				_item.dispose();
			}
			super.dispose();
		}
		
		override public function get width(): Number
		{
			return _width;
		}
		
		override public function set width(value:Number):void
		{
			
		}
		
		override public function set height(value:Number):void
		{
			
		}

		public function get padding():Margin
		{
			return _padding;
		}

		public function set padding(value:Margin):void
		{
			_padding = value;
			update();
		}
	}
}