package com.xgame.utils.manager
{
	import com.xgame.core.scene.Scene;
	import com.xgame.liteui.component.Menu;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.utils.Dictionary;
	
	import org.puremvc.as3.patterns.mediator.Mediator;
	
//	import utils.GameManager;

	public class MenuManager
	{
		public static var currentMenu: Menu;
		public static var menuIndex: Dictionary = new Dictionary();
		private static var _modeIndex: Dictionary = new Dictionary();
		
		public function MenuManager()
		{
		}
		
		public static function showMenu(menu: Menu): void
		{
			if(menuIndex[menu])
			{
				return;
			}
			
			if(currentMenu != null)
			{
				removeMenu(currentMenu);
			}
			
			menuIndex[menu] = true;
			currentMenu = menu;
			
			var _transparency: Sprite = addModeTransparency();
			_modeIndex[menu] = _transparency;
			
//			GameManager.instance.addToolTip(menu);
		}
		
		public static function closeAll(zIndex: int): void
		{
			var _menu: Object;
			for(_menu in menuIndex)
			{
				removeMenu(_menu as Menu);
			}
		}
		
		public static function removeMenu(menu: Menu): void
		{
			if(menuIndex[menu] == null)
			{
				return;
			}
//			GameManager.instance.removeToolTip(menu);
			delete menuIndex[menu];
			if(_modeIndex[menu] != null)
			{
				var _transparency: Sprite = _modeIndex[menu] as Sprite;
				removeModeTrasparency(_transparency);
				delete _modeIndex[menu];
			}
			menu.dispose();
		}
		
		public static function addModeTransparency(): Sprite
		{
			var _transparency: Sprite = new Sprite();
			_transparency.graphics.beginFill(0x000000, 0);
//			_transparency.graphics.drawRect(0, 0, GameManager.container.stageWidth, GameManager.container.stageHeight);
			_transparency.graphics.endFill();
//			GameManager.instance.addToolTip(_transparency);
			_transparency.addEventListener(MouseEvent.CLICK, onTransparencyClick);
			return _transparency;
		}
		
		private static function onTransparencyClick(evt: MouseEvent): void
		{
			removeMenu(currentMenu);
		}
		
		public static function removeModeTrasparency(_transparency: Sprite): void
		{
			if(_transparency.hasEventListener(MouseEvent.CLICK))
			{
				_transparency.removeEventListener(MouseEvent.CLICK, onTransparencyClick);
			}
//			GameManager.instance.removeToolTip(_transparency);
			_transparency = null;
		}
		
		public static function updateModeTransparencySize(): void
		{
			var _transparency: DisplayObject;
			for each(_transparency in _modeIndex)
			{
//				_transparency.width = GameManager.container.stageWidth;
//				_transparency.height = GameManager.container.stageHeight;
			}
		}
	}
}