package com.xgame.liteui.component
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import com.xgame.liteui.core.Component;
	
	public class Button extends Component
	{
		protected var _buttonNormal: Sprite;
		protected var _buttonOver: Sprite;
		protected var _buttonPress: Sprite;
		
		public function Button(_skin:DisplayObjectContainer=null)
		{
			super(_skin);
			
			_buttonNormal = getSkin("buttonNormal") as Sprite;
			_buttonOver = getSkin("buttonOver") as Sprite;
			_buttonPress = getSkin("buttonPress") as Sprite;
			
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			setMouseNormalSkin();
		}
		
		override protected function onMouseOver(evt:MouseEvent):void
		{
			super.onMouseOver(evt);
			setMouseOverSkin();
		}
		
		override protected function onMouseOut(evt:MouseEvent):void
		{
			super.onMouseOut(evt);
			setMouseNormalSkin();
		}
		
		protected function onMouseDown(evt:MouseEvent):void
		{
			setMouseDownSkin();
		}
		
		protected function onMouseUp(evt:MouseEvent):void
		{
			setMouseNormalSkin();
		}
		
		protected function hideAllStatu(): void
		{
			_buttonNormal.visible = false;
			_buttonOver.visible = false;
			_buttonPress.visible = false;
		}
		
		protected function setMouseOverSkin(): void
		{
			hideAllStatu();
			_buttonOver.visible = true;
		}
		
		protected function setMouseDownSkin(): void
		{
			hideAllStatu();
			_buttonPress.visible = true;
		}
		
		protected function setMouseNormalSkin(): void
		{
			hideAllStatu();
			_buttonNormal.visible = true;
		}
	}
}