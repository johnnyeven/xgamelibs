package com.xgame.common.display
{
	import com.greensock.TweenLite;
	import com.xgame.common.display.renders.Render;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.geom.Rectangle;

	public class BitmapDisplay extends StaticDisplay
	{
		public var objectId: String;
		public var objectName: String;
		public var canBeAttack: Boolean = false;
		public var inUse: Boolean = false;
		public var beFocus: Boolean = false;
		protected var _graphic: ResourceData;
		protected var _render: Render;
		protected var _buffer: Bitmap;
		protected var _rect: Rectangle
		protected var _positionX: int;
		protected var _positionY: int;
		protected var _zIndex: uint = 0;
		protected var _zIndexOffset: uint = 0;
		private var _renderPos: uint;
		private static const CENTER: uint = 0;
		private static const TOP_LEFT: uint = 1;
		private static const BOTTOM_LEFT: uint = 2;
		
		public function BitmapDisplay()
		{
			super();
			_renderPos = TOP_LEFT;
			_rect = new Rectangle();
			_positionX = 0;
			_positionY = 0;
			
			_buffer = new Bitmap(null, "auto", true);
			addChild(_buffer);
			mouseChildren = false;
			mouseEnabled = false;
		}
		
		public function updateController(): void
		{
			
		}
		
		public function update(): void
		{
			if(_buffer != null && _render != null && inUse)
			{
				_render.render(this);
			}
		}
		
		public function setBufferPos(x: Number = NaN, y: Number = NaN): void
		{
			if(!isNaN(x) && !isNaN(y))
			{
				_buffer.x = -x;
				_buffer.y = -y;
			}
			else if(_graphic != null)
			{
				_buffer.x = -_graphic.frameWidth / 2;
				_buffer.y = -_graphic.frameHeight;
			}
		}
		
		public function shadeOut(callback: Function = null): void
		{
			TweenLite.killTweensOf(this);
			TweenLite.to(this, .5, {
				alpha: 0,
				onComplete: callback
			});
		}
		
		public function shadeIn(callback: Function = null): void
		{
			TweenLite.killTweensOf(this);
			TweenLite.to(this, .5, {
				alpha: 1,
				onComplete: callback
			});
		}
		
		public function dispose(callback: Function = null): void
		{
			if(_graphic != null)
			{
				_graphic.dispose();
				_graphic = null;
			}
			
			if(!inUse)
			{
				canBeAttack = false;
			}
			else
			{
				inUse = false;
				shadeOut(dispose);
			}
		}
		
		protected function rebuild(): void
		{
			setBufferPos();
		}

		public function get graphic():ResourceData
		{
			return _graphic;
		}

		public function set graphic(value:ResourceData):void
		{
			_graphic = value;
			rebuild();
		}

		public function get buffer():Bitmap
		{
			return _buffer;
		}

		public function get rect(): Rectangle
		{
			_rect.x = 0;
			_rect.y = 0;
			_rect.width = _graphic.frameWidth;
			_rect.height = _graphic.frameHeight;
			return _rect;
		}

		public function get positionX():int
		{
			return _positionX;
		}

		public function set positionX(value:int):void
		{
			_positionX = value;
		}

		public function get positionY():int
		{
			return _positionY;
		}

		public function set positionY(value:int):void
		{
			_positionY = value;
			_zIndex = value;
		}

		public function get zIndex(): uint
		{
			return _zIndex + _zIndexOffset;
		}

		public function get zIndexOffset():uint
		{
			return _zIndexOffset;
		}

		public function set zIndexOffset(value:uint):void
		{
			_zIndexOffset = value;
		}

		public function get renderLine(): uint
		{
			return 0;
		}
		
		public function get renderFrame(): uint
		{
			return 0;
		}

		public function get render():Render
		{
			return _render;
		}

		public function set render(value:Render):void
		{
			_render = value;
			_render.target = this;
		}

	}
}