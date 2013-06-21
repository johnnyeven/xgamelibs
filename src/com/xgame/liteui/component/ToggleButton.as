package utils.liteui.component
{
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	public class ToggleButton extends CaptionButton
	{
		protected var _toggleStatus: Boolean;
		
		public function ToggleButton(_skin:DisplayObjectContainer=null)
		{
			super(_skin);
			_toggleStatus = false;
			addEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		protected function onMouseClick(evt: MouseEvent): void
		{
			if(_toggleStatus)
			{
				_toggleStatus = false;
				setMouseNormalSkin();
				color = 0x0099FF;
			}
			else
			{
				_toggleStatus = true;
				setMouseDownSkin();
				color = 0xFF9900;
			}
		}
		
		override protected function onMouseOut(evt:MouseEvent):void
		{
			if(_toggleStatus)
			{
				setMouseDownSkin();
			}
			else
			{
				setMouseNormalSkin();
			}
		}
		
		public function set toggle(value: Boolean): void
		{
			if(value != _toggleStatus)
			{
				_toggleStatus = value;
				if(_toggleStatus)
				{
					setMouseDownSkin();
					color = 0xFF9900;
				}
				else
				{
					setMouseNormalSkin();
					color = 0x0099FF;
				}
			}
		}
		
		public function get toggle(): Boolean
		{
			return _toggleStatus;
		}
	}
}