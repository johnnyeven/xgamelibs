package com.xgame.liteui.component
{
	import flash.display.DisplayObjectContainer;
	
	public class CaptionButton extends Button
	{
		protected var _label: Label;
		
		public function CaptionButton(_skin:DisplayObjectContainer=null)
		{
			super(_skin);
			_label = getUI(Label, "caption") as Label;
			_label.mouseEnabled = false;
			_label.mouseChildren = false;
			//sortChildIndex();
		}
		
		override public function dispose(): void
		{
			super.dispose();
			_label.dispose();
			_label = null;
		}
		
		public function get caption(): String
		{
			return _label.text;
		}
		
		public function set caption(value: String): void
		{
			_label.text = value;
		}
		
		public function get align(): String
		{
			return _label.align;
		}
		
		public function set align(value: String): void
		{
			_label.align = value;
		}
		
		public function get color(): uint
		{
			return _label.color;
		}
		
		public function set color(value: uint): void
		{
			_label.color = value;
		}
		
		public function get size(): uint
		{
			return _label.size;
		}
		
		public function set size(value: uint): void
		{
			_label.size = value;
		}
		
		public function get bold(): Boolean
		{
			return _label.bold;
		}
		
		public function set bold(value: Boolean): void
		{
			_label.bold = value;
		}
		
		public function get fontName(): String
		{
			return _label.fontName;
		}
		
		public function set fontName(value: String): void
		{
			_label.fontName = value;
		}
	}
}