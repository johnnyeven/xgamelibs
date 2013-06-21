package com.xgame.liteui.component
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	
	import mx.utils.UIDUtil;
	
	import com.xgame.utils.manager.MenuManager;
	import com.xgame.utils.UIUtils;
	import com.xgame.liteui.core.Component;
	import com.xgame.liteui.layouts.Margin;
	import utils.resource.ResourcePool;
	
	public class MenuItem extends Component
	{
		public var itemName: String;
		public var parentMenu: Menu;
		private var _margin: Margin;
		private var _padding: Margin;
		private var _bg: MovieClip;
		private var _childMenuIcon: MovieClip;
		private var _text: Label;
		private var _childMenu: Menu;
		private var _clickArea: Shape;
		public static const ICON_OFFSET: int = 10;
		
		public function MenuItem(_skin:DisplayObjectContainer=null)
		{
			if(_skin == null)
			{
				_skin = ResourcePool.getResource("ui.menu.itemBG") as DisplayObjectContainer;
			}
			super(_skin);
			
			_bg = getSkin("bg") as MovieClip;
			_childMenuIcon = getSkin("childMenuIcon") as MovieClip;
			if(_childMenuIcon != null)
			{
				_childMenuIcon.visible = false;
			}
			
			_text = new Label();
			addChild(_text);
			_clickArea = new Shape();
			addChild(_clickArea);
			_text.color = 0xFFFFFF;
			_text.autoSize = true;
			
			margin = new Margin(0, 0, 0, 0);
			padding = new Margin(3, 0, 3, 0);
		}
		
		public function set text(value: String): void
		{
			_text.text = value;
			update();
		}
		
		public function set color(value: uint): void
		{
			_text.color = value;
		}
		
		public function set indent(value: Number): void
		{
			_text.x = value + _padding.left;
			update();
		}

		public function get margin(): Margin
		{
			return _margin;
		}

		public function set margin(value: Margin):void
		{
			_margin = value;
		}

		public function get padding(): Margin
		{
			return _padding;
		}

		public function set padding(value: Margin):void
		{
			_padding = value;
			update();
		}
		
		override public function get width():Number
		{
			var _width:Number;
			if(_bg != null)
			{
				_width = Math.max(_text.width, UIUtils.getSkinSize(_bg).x);
			}
			else
			{
				_width = _text.width;
			}
			if(_childMenu != null)
			{
				_width += _childMenuIcon.width + ICON_OFFSET;
			}
			return _width + _padding.left + _padding.right;
		}
		
		override public function get height():Number
		{
			var _height: Number;
			if(_bg != null)
			{
				_height = Math.max(_text.height, UIUtils.getSkinSize(_bg).y);
			}
			else
			{
				_height = _text.height;
			}
			return _height + _padding.top + _padding.bottom;
		}

		public function get childMenu():Menu
		{
			return _childMenu;
		}

		public function set childMenu(value:Menu):void
		{
			_childMenu = value;
			_childMenuIcon.x = parentMenu.width - parentMenu.padding.left - parentMenu.padding.right + ICON_OFFSET;
			_childMenuIcon.y = (height - _childMenuIcon.height) * .5;
			_childMenuIcon.visible = true;
			
			_childMenu.x = parentMenu.width - parentMenu.padding.left - parentMenu.padding.right + ICON_OFFSET;
			_childMenu.y = -5;
			
			parentMenu.update();
		}
		
		public function update(): void
		{
			if(parentMenu != null)
			{
				_clickArea.graphics.clear();
				_clickArea.graphics.beginFill(0xFFFFFF, 0);
				_clickArea.graphics.drawRect(0, 0, parentMenu.width - parentMenu.padding.left - parentMenu.padding.right + ICON_OFFSET + _childMenuIcon.width, height);
				_clickArea.graphics.endFill();
			}
			_text.x = _padding.left;
			_text.y = _padding.top;
		}
		
		override protected function onMouseOver(evt:MouseEvent):void
		{
			if(_childMenu != null)
			{
				addMenu(_childMenu);
			}
		}
		
		override protected function onMouseOut(evt:MouseEvent):void
		{
			if(_childMenu != null)
			{
				removeMenu(_childMenu);
			}
		}
		
		public function addMenu(child: Menu): void
		{
			addChild(child);
		}
		
		public function removeMenu(child: Menu): void
		{
			removeChild(child);
		}
	}
}