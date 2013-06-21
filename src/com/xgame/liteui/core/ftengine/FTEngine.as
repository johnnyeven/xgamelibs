package com.xgame.liteui.core.ftengine
{
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.text.engine.BreakOpportunity;
	import flash.text.engine.ContentElement;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.engine.FontLookup;
	import flash.text.engine.FontPosture;
	import flash.text.engine.FontWeight;
	import flash.text.engine.GraphicElement;
	import flash.text.engine.GroupElement;
	import flash.text.engine.RenderingMode;
	import flash.text.engine.TextBaseline;
	import flash.text.engine.TextElement;
	import flash.text.engine.TextLine;
	import flash.text.engine.TextLineMirrorRegion;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.utils.getDefinitionByName;
	
	import com.xgame.utils.StringUtils;

	public class FTEngine extends EventDispatcher
	{
		public var defaultFontName: String = "黑体";
		public var defaultFontSize: Number = 12;
		public var defaultFontColor: uint = 0x000000;
		public var defaultBold: Boolean = false;
		public var defaultHGap: Number = 0;
		
		protected var _fontName: String;
		protected var _fontSize: int = 0;
		protected var _fontColor: int = -1;
		protected var _bold: Boolean = false;
		protected var _hGap: Number = -1;
		private var _hasBold: Boolean = false;
		
		public function FTEngine()
		{
		}
		
		public function createElement(value: String): GroupElement
		{
			XML.ignoreWhitespace = false;
			var _parsedXML: XML = convertToXML(value);
			var _groupElement:Vector.<ContentElement> = new Vector.<ContentElement>();
			
			_fontName = _parsedXML.hasOwnProperty("@fontName") ? (_parsedXML.@fontName as String) : "";
			_fontSize = _parsedXML.hasOwnProperty("@size") ? int(_parsedXML.@size) : 0;
			_fontColor = _parsedXML.hasOwnProperty("@color") ? int(_parsedXML.@color) : -1;
			_hGap = _parsedXML.hasOwnProperty("@hGap") ? (_parsedXML.@hGap as Number) : -1;
			if(_parsedXML.hasOwnProperty("@bold"))
			{
				_bold = _parsedXML.@bold as Boolean;
				_hasBold = true;
			}
			else
			{
				_bold = false;
				_hasBold = false;
			}
			var _parsedChild: XMLList;
			for(var key: String in _parsedXML.children())
			{
				_parsedChild = _parsedXML.child(key);
				switch(_parsedChild.localName())
				{
					case "string":
						_groupElement.push(getTextElement(_parsedChild));
						break;
					case "graphic":
						
						break;
					case "a":
						
						break;
					case "n":
						
						break;
				}
			}
			XML.ignoreWhitespace = true;
			return new GroupElement(_groupElement);
		}
		
		private function getTextElement(child: XMLList): ContentElement
		{
			var _value: String = child.toString();
			_value = StringUtils.htmlEntitiesDecode(_value);
			var _element: TextElement = new TextElement(_value, getFormat(child));
			return _element;
		}
		
		private function getLinkElement(child: XMLList): ContentElement
		{
			var _value: String;
			if(child.hasOwnProperty("@value"))
			{
				_value = child.@value as String;
			}
			else
			{
				_value = child.string[0].toString();
			}
			var _element: ContentElement = getTextElement(child.string[0]);
			
			var _evtDispatcher: EventDispatcher = new EventDispatcher();
			_evtDispatcher.addEventListener(MouseEvent.CLICK, onMouseClick, false, 0, true);
			_evtDispatcher.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver, false, 0, true);
			_evtDispatcher.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut, false, 0, true);
			
			_element.eventMirror = _evtDispatcher;
			_element.userData = _value;
			return _element;
		}
		
		private function getGraphicElement(child: XMLList): ContentElement
		{
			try
			{
				var _class: Class = getDefinitionByName(child.toString()) as Class;
				var _graphic: DisplayObject = new _class();
				var _elementFormat: ElementFormat = new ElementFormat();
				_elementFormat.dominantBaseline = TextBaseline.IDEOGRAPHIC_CENTER;
				return new GraphicElement(_graphic, _graphic.width, _graphic.height, _elementFormat);
			}
			catch(err: Error)
			{
				
			}
			return null;
		}
		
		private function onMouseOver(evt: MouseEvent): void
		{
			Mouse.cursor = MouseCursor.BUTTON;
		}
		
		private function onMouseOut(evt: MouseEvent): void
		{
			Mouse.cursor = MouseCursor.AUTO;
		}
		
		private function onMouseClick(evt: MouseEvent): void
		{
			var _target: TextLine = evt.target as TextLine;
			if(_target != null)
			{
				for(var i: uint = 0; i<_target.mirrorRegions.length; i++)
				{
					var _mirrorRegion: TextLineMirrorRegion = _target.mirrorRegions[i] as TextLineMirrorRegion;
					if(_mirrorRegion.bounds.contains(_target.mouseX, _target.mouseY))
					{
						
					}
				}
			}
		}
		
		private function getFormat(child: XMLList): ElementFormat
		{
			var fontName: String;
			var fontSize: int;
			var color: uint;
			var bold: Boolean;
			var hGap: Number;
			
			if(child.hasOwnProperty("@fontName"))
			{
				fontName = child.@fontName as String;
			}
			else
			{
				if(!StringUtils.empty(_fontName))
				{
					fontName = _fontName;
				}
				else
				{
					fontName = defaultFontName;
				}
			}
			if(child.hasOwnProperty("@size"))
			{
				fontSize = int(child.@size);
			}
			else if(_fontSize != 0)
			{
				fontSize = _fontSize;
			}
			else
			{
				fontSize = defaultFontSize;
			}
			if(child.hasOwnProperty("@color"))
			{
				color = int(child.@color);
			}
			else if(_fontColor != -1)
			{
				color = _fontColor;
			}
			else
			{
				color = defaultFontColor;
			}
			if(child.hasOwnProperty("@bold"))
			{
				bold = child.@bold as Boolean;
			}
			else if(_hasBold)
			{
				bold = _bold;
			}
			else
			{
				bold = defaultBold;
			}
			if(child.hasOwnProperty("@hGap"))
			{
				hGap = child.@hGap;
			}
			else if(_hGap != -1)
			{
				hGap = _hGap;
			}
			else
			{
				hGap = defaultHGap;
			}
			
			var _fontWeight: String = FontWeight.NORMAL;
			if(bold)
			{
				_fontWeight = FontWeight.BOLD;
			}
			
			var _fontDesc: FontDescription = new FontDescription(fontName, _fontWeight, FontPosture.NORMAL, FontLookup.EMBEDDED_CFF, RenderingMode.CFF);
			var _elementFormat: ElementFormat = new ElementFormat(_fontDesc, fontSize, color);
			_elementFormat.dominantBaseline = TextBaseline.IDEOGRAPHIC_TOP;
			_elementFormat.breakOpportunity = BreakOpportunity.ANY;
			_elementFormat.trackingRight = hGap;
			
			return _elementFormat;
		}
		
		public static function convertToXML(value: String): XML
		{
			var _xml: XML;
			try
			{
				_xml = XML(value);
			}
			catch(err: Error)
			{
				CONFIG::DebugMode
				{
					trace("FTEngine.convertToXML Error: " + err.message);
				}
			}
			if(_xml.name() == null)
			{
				value = "<p><string>" + value + "</string></p>";
				_xml = XML(value);
			}
			return _xml;
		}
	}
}