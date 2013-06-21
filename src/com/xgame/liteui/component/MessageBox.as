package com.xgame.liteui.component
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormatAlign;
	import flash.utils.getDefinitionByName;
	
	import com.xgame.utils.StringUtils;
	import com.xgame.utils.UIUtils;
	import com.xgame.utils.manager.PopUpManager;
	import com.xgame.utils.manager.LanguageManager;
	import com.xgame.liteui.core.Component;
	
	public class MessageBox extends Component
	{
		protected var _labelCaption: Label;
		protected var _labelContent: Label;
		protected var _okButton: CaptionButton;
		protected var _noButton: CaptionButton;
		protected var _closeButton: Button;
		private var _buttonType: uint;
		private var _onButtonPress: Function;
		public static var defaultSkinName: String;
		public static const BUTTON_OK: uint = 1;
		public static const BUTTON_CANCEL: uint = 2;
		
		public function MessageBox(_skin:DisplayObjectContainer=null, _callback: Function = null)
		{
			super(_skin);
			_onButtonPress = _callback;
			_labelCaption = getUI(Label, "labelCaption") as Label;
			_labelContent = getUI(Label, "labelContent") as Label;
			_okButton = getUI(CaptionButton, "okButton") as CaptionButton;
			_noButton = getUI(CaptionButton, "noButton") as CaptionButton;
			_closeButton = getUI(Button, "closeButton") as Button;
			_okButton.caption = LanguageManager.getInstance().lang("common_messagebox_ok");
			_noButton.caption = LanguageManager.getInstance().lang("common_messagebox_cancel");
			sortChildIndex();
			
			_labelCaption.wordWrap = false;
			_labelCaption.align = TextFormatAlign.CENTER;
			_labelContent.wordWrap = true;
			_labelContent.align = TextFormatAlign.LEFT;
			
			_okButton.addEventListener(MouseEvent.CLICK, onOkButtonClick);
			_noButton.addEventListener(MouseEvent.CLICK, onNoButtonClick);
			_closeButton.addEventListener(MouseEvent.CLICK, onCloseButtonClick);
			
			initButton();
		}
		
		override public function dispose(): void
		{
			super.dispose();
			_labelCaption.dispose();
			_labelContent.dispose();
			_okButton.dispose();
			_noButton.dispose();
			_labelCaption = null;
			_labelContent = null;
			_okButton = null;
			_noButton = null;
		}
		
		private function initButton(): void
		{
			if(_buttonType & BUTTON_OK)
			{
				_okButton.visible = true;
			}
			else
			{
				_okButton.visible = false;
			}
			if(_buttonType & BUTTON_CANCEL)
			{
				_noButton.visible = true;
			}
			else
			{
				_noButton.visible = false;
			}
		}

		public function get buttonType():uint
		{
			return _buttonType;
		}

		public function set buttonType(value:uint):void
		{
			_buttonType = value;
			initButton();
		}
		
		public function get caption(): String
		{
			return _labelCaption.text;
		}
		
		public function set caption(value: String):void
		{
			_labelCaption.text = value;
		}
		
		public function get content(): String
		{
			return _labelContent.text;
		}
		
		public function set content(value: String):void
		{
			_labelContent.text = value;
		}
		
		protected function onOkButtonClick(evt: MouseEvent): void
		{
			if(_onButtonPress != null)
			{
				_onButtonPress(BUTTON_OK);
			}
			close();
		}
		
		protected function onNoButtonClick(evt: MouseEvent): void
		{
			if(_onButtonPress != null)
			{
				_onButtonPress(BUTTON_CANCEL);
			}
			close();
		}
		
		protected function onCloseButtonClick(evt: MouseEvent): void
		{
			close();
		}
		
		public function close(): void
		{
			PopUpManager.removePopUp(this);
			dispatchEvent(new Event(Event.CLOSE));
			dispose();
		}
		
		public static function show(caption: String, content: String, skinName: String = "", mode: Boolean = true, buttonType: uint = 3, callback: Function = null): MessageBox
		{
			var _class: Class;
			if(!StringUtils.empty(skinName))
			{
				_class = getDefinitionByName(skinName) as Class;
			}
			else if(!StringUtils.empty(defaultSkinName))
			{
				_class = getDefinitionByName(defaultSkinName) as Class;
			}
			else
			{
				throw new Error("MessageBox未指定显示皮肤");
			}
			var _message: MessageBox = new MessageBox(new _class(), callback);
			_message.caption = caption;
			_message.content = content;
			_message.buttonType = buttonType;
			UIUtils.center(_message);
			PopUpManager.addPopUp(_message, mode);
			return _message;
		}
	}
}