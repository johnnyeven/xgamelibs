package com.xgame.liteui.component
{
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.engine.TextBaseline;
	import flash.text.engine.TextBlock;
	import flash.text.engine.TextLine;
	
	import com.xgame.utils.StringUtils;
	import com.xgame.utils.UIUtils;
	import com.xgame.liteui.core.Component;
	import com.xgame.liteui.core.ftengine.FTEFormater;
	import com.xgame.liteui.core.ftengine.FTEngine;
	
	public class Label extends Component
	{
		private var _text: String = "";
		private var _align: String = TextFormatAlign.LEFT;
		private var _color: uint = 0x000000;
		private var _size: uint = 12;
		private var _wordWrap: Boolean = false;
		private var _autoSize: Boolean = false;
		private var _bold: Boolean = false;
		private var _ftengine: FTEngine;
		private var _textBlock: TextBlock;
		private var _textBuffer: Sprite;
		private var _hGap: Number = 1;
		private var _vGap: Number = 2;
		private var _fontName: String = "微软雅黑";
		private var _textWidth: Number = 100;
		private var _textHeight: Number = 16;
		public var lock: Boolean = false;
		
		public function Label(_skin:TextField=null)
		{
			super(null);
			mouseEnabled = false;
			mouseChildren = false;
			
			_ftengine = new FTEngine();
			_ftengine.defaultBold = _bold;
			_ftengine.defaultFontColor = _color;
			_ftengine.defaultFontName = _fontName;
			_ftengine.defaultFontSize = _size;
			
			_textBlock = new TextBlock();
			_textBlock.baselineZero = TextBaseline.IDEOGRAPHIC_TOP;
			_textBuffer = new Sprite();
			addChild(_textBuffer);
			setFilter();
			
			if(_skin != null)
			{
				lock = true;
				UIUtils.setCommonProperty(this, _skin);
				
				_textWidth = _skin.width;
				_textHeight = _skin.height;
				_wordWrap = _skin.wordWrap;
				
				var defaultTextFormat: TextFormat = _skin.defaultTextFormat;
				align = defaultTextFormat.align;
				color = Number(defaultTextFormat.color);
				size = Number(defaultTextFormat.size);
				bold = Boolean(defaultTextFormat.bold);
				fontName = defaultTextFormat.font;
				text = FTEFormater.htmlToFTEFormat(_skin.htmlText);
				
				lock = false;
				updateText();
				
				UIUtils.remove(_skin);
			}
		}
		
		override public function dispose(): void
		{
			super.dispose();
			_ftengine = null;
			_textBuffer = null;
			_textBlock = null;
		}
		
		public function updateText(): void
		{
			if(!lock)
			{
				cleanTextLine();
				_textBlock.content = _ftengine.createElement(_text);
				createTextLine();
			}
		}
		
		private function createTextLine(): void
		{
			var _textWidth: Number = this._textWidth;
			if(_autoSize)
			{
				_textWidth = 100000;
			}
			var _textLine:TextLine = _textBlock.createTextLine(null, _textWidth);
			var _textLineHeight: Number = 0;
			
			while(_textLine != null)
			{
				if(_autoSize)
				{
					_textBuffer.addChild(_textLine);
					break;
				}
				if(_align == TextFormatAlign.RIGHT)
				{
					_textLine.x = this._textWidth - _textLine.width;
				}
				if(_align == TextFormatAlign.CENTER)
				{
					if(_textBuffer.numChildren >= 1)
					{
						_textBuffer.getChildAt(0).x = 0;
					}
					else
					{
						_textLine.x = (this._textWidth - _textLine.width) * .5;
					}
				}
				if(_wordWrap)
				{
					_textLine.y = _textLineHeight;
					_textLineHeight += (_textLine.height + _vGap);
				}
				else
				{
					_textLine.y = (_textHeight - _textLine.height) * .5;
				}
				if(_textLineHeight > _textHeight)
				{
					break;
				}
				_textBuffer.addChild(_textLine);
				_textLine = _textBlock.createTextLine(_textLine, _textWidth);
				if(!_wordWrap)
				{
					break;
				}
			}
		}
		
		private function cleanTextLine(): void
		{
			while(_textBuffer.numChildren > 0)
			{
				_textBuffer.removeChildAt(0);
			}
		}

		public function get text():String
		{
			return _text;
		}

		public function set text(value:String):void
		{
			_text = StringUtils.empty(value) ? "" : value;
			updateText();
		}

		public function get align():String
		{
			return _align;
		}

		public function set align(value:String):void
		{
			_align = value;
			updateText();
		}

		public function get color():uint
		{
			return _color;
		}

		public function set color(value:uint):void
		{
			_color = value;
			_ftengine.defaultFontColor = value;
			updateText();
		}

		public function get size():uint
		{
			return _size;
		}

		public function set size(value:uint):void
		{
			_size = value;
			_ftengine.defaultFontSize = value;
			updateText();
		}

		public function get wordWrap():Boolean
		{
			return _wordWrap;
		}

		public function set wordWrap(value:Boolean):void
		{
			_wordWrap = value;
			updateText();
		}

		public function get autoSize():Boolean
		{
			return _autoSize;
		}

		public function set autoSize(value:Boolean):void
		{
			_autoSize = value;
			updateText();
		}

		public function get bold():Boolean
		{
			return _bold;
		}

		public function set bold(value:Boolean):void
		{
			_bold = value;
			_ftengine.defaultBold = value;
			updateText();
		}

		public function get hGap():Number
		{
			return _hGap;
		}

		public function set hGap(value:Number):void
		{
			_hGap = value;
			_ftengine.defaultHGap = value;
			updateText();
		}

		public function get vGap():Number
		{
			return _vGap;
		}

		public function set vGap(value:Number):void
		{
			_vGap = value;
			updateText();
		}

		public function get fontName():String
		{
			return _fontName;
		}

		public function set fontName(value:String):void
		{
			switch(value)
			{
				case "SimHei":
					_fontName = "黑体";
					break;
				case "Microsoft YaHei":
					_fontName = "微软雅黑";
					break;
				case "Microsoft YaHei Bold":
					_fontName = "微软雅黑";
					bold = true;
					break;
				default:
					_fontName = value;
					break;
			}
			//_fontName = value;
			_ftengine.defaultFontName = _fontName;
			updateText();
		}
		
		public function get textWidth(): Number
		{
			return _textWidth;
		}
		
		public function set textWidth(value: Number): void
		{
			_textWidth = value;
			updateText();
		}
		
		public function get textHeight():Number
		{
			return _textHeight;
		}
		
		public function set textHeight(value:Number):void
		{
			_textHeight = value;
			updateText();
		}
		
		public function get textBlock(): TextBlock
		{
			return _textBlock;
		}
		
		override protected function setFilter(): void
		{
			if(filterEnabled)
			{
				_textBuffer.filters = [
					new GlowFilter(filterColor, 1, 2, 2, 300)
				];
			}
			else
			{
				_textBuffer.filters = [];
			}
		}
	}
}