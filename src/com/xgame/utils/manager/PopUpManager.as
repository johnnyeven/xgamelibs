package com.xgame.utils.manager
{
	import com.xgame.core.GameManager;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.utils.Dictionary;
	
	import org.puremvc.as3.patterns.facade.Facade;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class PopUpManager
	{
		public static var modeUseBlurFilter: Boolean = false;
		public static var popUpIndex: Dictionary = new Dictionary();
		private static var _modeIndex: Dictionary = new Dictionary();
		private static var _modelNum: uint = 2;
		
		public function PopUpManager()
		{
		}
		
		public static function addPopUp(popUp: DisplayObject, mode: Boolean = false): void
		{
			if(popUpIndex[popUp])
			{
				return;
			}
			
			popUpIndex[popUp] = true;
			
			if(mode)
			{
				_modelNum++;
				var _transparency: Sprite = addModeTransparency(_modelNum);
				_modeIndex[popUp] = _transparency;
			}
			
			GameManager.instance.addPopUp(popUp);
		}
		
		public static function closeAll(zIndex: int): void
		{
			var _popUp: Object;
			var _mediator: Mediator;
			for(_popUp in popUpIndex)
			{
				if(_popUp["mediator"] != null && _popUp["mediator"]["zIndex"] != null)
				{
					if(_popUp["mediator"]["zIndex"] >= zIndex)
					{
						_mediator = _popUp["mediator"] as Mediator;
						Facade.getInstance().sendNotification("Destroy" + _mediator.getMediatorName());
					}
					continue;
				}
				removePopUp(_popUp as DisplayObject);
			}
		}
		
		public static function removePopUp(popUp: DisplayObject): void
		{
			if(popUpIndex[popUp] == null)
			{
				return;
			}
			GameManager.instance.removePopUp(popUp);
			delete popUpIndex[popUp];
			if(_modeIndex[popUp] != null)
			{
				var _transparency: Sprite = _modeIndex[popUp] as Sprite;
				_modelNum--;
				removeModeTrasparency(_modelNum, _transparency);
				delete _modeIndex[popUp];
			}
		}
		
		public static function addModeTransparency(blur: uint): Sprite
		{
			var _transparency: Sprite = new Sprite();
			_transparency.graphics.beginFill(0x000000, .7);
			_transparency.graphics.drawRect(0, 0, GameManager.container.stageWidth, GameManager.container.stageHeight);
			_transparency.graphics.endFill();
			GameManager.instance.addPopUp(_transparency);
			if(modeUseBlurFilter)
			{
				GameManager.instance.baseLayer.filters = [
					new BlurFilter(blur, blur, BitmapFilterQuality.LOW)
				];
			}
			return _transparency;
		}
		
		public static function removeModeTrasparency(blur: uint, _transparency: Sprite): void
		{
			if(GameManager.instance.popUpLayer.contains(_transparency))
			{
				GameManager.instance.popUpLayer.removeChild(_transparency);
				if(modeUseBlurFilter)
				{
					GameManager.instance.baseLayer.filters = [
						new BlurFilter(blur, blur, BitmapFilterQuality.LOW)
					];
				}
			}
		}
		
		public static function updateModeTransparencySize(): void
		{
			var _transparency: DisplayObject;
			for each(_transparency in _modeIndex)
			{
				_transparency.width = GameManager.container.stageWidth;
				_transparency.height = GameManager.container.stageHeight;
			}
		}
	}
}