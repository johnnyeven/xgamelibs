package com.xgame.common.display
{
	import com.greensock.TweenLite;
	import com.xgame.common.behavior.Behavior;
	import com.xgame.common.display.renders.Render;
	import com.xgame.core.Camera;
	import com.xgame.enum.Direction;
	import com.xgame.ns.NSCamera;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;

	public class BitmapDisplay extends StaticDisplay
	{
		public var objectId: String;
		public var objectName: String;
		public var canBeAttack: Boolean = false;
		public var beFocus: Boolean = false;
		protected var _speed: Number;
		protected var _direction: int;
		protected var _graphic: ResourceData;
		protected var _behavior: Behavior;
		protected var _render: Render;
		protected var _buffer: Bitmap;
		protected var _rect: Rectangle;
		protected var _positionX: int;
		protected var _positionY: int;
		protected var _zIndex: uint = 0;
		protected var _zIndexOffset: uint = 0;
		private var _renderPos: uint;
		private var _childrenDisplay: Vector.<BitmapDisplay>;
		private var _childrenContainer: Sprite;
		private var _parentDisplay: BitmapDisplay;
		private static const CENTER: uint = 0;
		private static const TOP_LEFT: uint = 1;
		private static const BOTTOM_LEFT: uint = 2;
		NSCamera var inScene: Boolean = false;
		
		public function BitmapDisplay(behavior: Behavior = null)
		{
			super();
			_childrenDisplay = new Vector.<BitmapDisplay>();
			
			_renderPos = TOP_LEFT;
			_rect = new Rectangle();
			_positionX = 0;
			_positionY = 0;
			
			_buffer = new Bitmap(null, "auto", true);
			addChild(_buffer);
			_childrenContainer = new Sprite;
			addChild(_childrenContainer);
			mouseChildren = false;
			mouseEnabled = false;
			
			this.behavior = behavior;
		}
		
		public function get childrenDisplay():Vector.<BitmapDisplay>
		{
			return _childrenDisplay;
		}

		public function get parentDisplay():BitmapDisplay
		{
			return _parentDisplay;
		}

		public function set parentDisplay(value:BitmapDisplay):void
		{
			_parentDisplay = value;
		}

		public function set behavior(value: Behavior): void
		{
			if(value != null)
			{
				if(_behavior != null)
				{
					_behavior.dispose();
				}
				_behavior = value;
				_behavior.target = this;
				_behavior.installListener();
			}
		}
		
		public function updateController(): void
		{
			if(_behavior != null)
			{
				_behavior.step();
			}
		}
		
		public function update(): void
		{
			updateActionPre();
			if(_buffer != null && _render != null && this.NSCamera::inScene)
			{
				_render.render(this);
			}
			updateActionAfter();
		}
		
		protected function updateActionPre(): void
		{
		}
		
		protected function updateActionAfter(): void
		{
			var item: BitmapDisplay;
			for each(item in _childrenDisplay)
			{
				item.updateController();
				item.render.render(item);
				item.update();
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
		
		NSCamera function shadeOut(callback: Function = null): void
		{
			TweenLite.killTweensOf(this);
			TweenLite.to(this, .5, {
				alpha: 0,
				onComplete: callback
			});
		}
		
		NSCamera function shadeIn(callback: Function = null): void
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
				//TODO 重新放回资源池而不是销毁
//				_graphic.dispose();
				_graphic = null;
			}
			
			if(!this.NSCamera::inScene)
			{
				canBeAttack = false;
			}
			else
			{
				this.NSCamera::inScene = false;
				this.NSCamera::shadeOut(dispose);
			}
		}
		
		protected function rebuild(): void
		{
			setBufferPos();
		}
		
		public function addDisplay(value: BitmapDisplay): void
		{
			if(_childrenDisplay.indexOf(value) >= 0)
			{
				return;
			}
			_childrenDisplay.push(value);
			value.parentDisplay = this;
			_childrenContainer.addChild(value);
		}
		
		public function removeDisplay(value: BitmapDisplay): void
		{
			var index: int = _childrenDisplay.indexOf(value);
			if(index >= 0)
			{
				if(_childrenContainer.contains(value))
				{
					_childrenContainer.removeChild(value);
				}
				
				_childrenDisplay.splice(index, 1);
				value.parentDisplay = null;
				value.dispose();
				value = null;
			}
		}

		public function get graphic():ResourceData
		{
			return _graphic;
		}

		public function set graphic(value:ResourceData):void
		{
			_graphic = value;
			_graphic.currentAction = 0;
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
			
			if(!Camera.NSCamera::needCut && 
				Camera.instance.cameraView != null && 
				Camera.instance.cameraView.contains(_positionX, _positionY))
			{
				Camera.NSCamera::needCut = true;
			}
		}

		public function get positionY():int
		{
			return _positionY;
		}

		public function set positionY(value:int):void
		{
			_positionY = value;
			_zIndex = value;
			
			if(!Camera.NSCamera::needCut && 
				Camera.instance.cameraView != null && 
				Camera.instance.cameraView.contains(_positionX, _positionY))
			{
				Camera.NSCamera::needCut = true;
			}
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

		public function get behavior():Behavior
		{
			return _behavior;
		}

		public function get direction():int
		{
			return _direction;
		}

		public function set direction(value:int):void
		{
			_direction = value;
		}
		
		public function get speed():Number
		{
			return _speed;
		}
		
		public function set speed(value:Number):void
		{
			_speed = value;
		}
		
		public function get angle(): uint
		{
			switch(_direction)
			{
				case Direction.DOWN:
					return 180;
					break;
				case Direction.LEFT_DOWN:
					return 215;
					break;
				case Direction.LEFT:
					return 270;
					break;
				case Direction.LEFT_UP:
					return 315;
					break;
				case Direction.UP:
					return 0;
					break;
				case Direction.RIGHT_UP:
					return 45;
					break;
				case Direction.RIGHT:
					return 90;
					break;
				case Direction.RIGHT_DOWN:
					return 135;
					break;
				default:
					return 180;
			}
		}

	}
}