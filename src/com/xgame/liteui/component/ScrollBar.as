package utils.liteui.component
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import utils.GameManager;
	import utils.MouseUtils;
	import utils.UIUtils;
	import utils.enum.ScrollBarOrientation;
	import utils.enum.ScrollBarPolicy;
	import utils.events.ScrollBarEvent;
	import utils.events.ViewEvent;
	import utils.liteui.core.Component;
	import utils.liteui.core.IViewPort;
	
	public class ScrollBar extends Component
	{
		protected var _upButton: Button;
		protected var _downButton: Button;
		protected var _trackSprite: Sprite;
		protected var _bar: Sprite;
		protected var _barIcon: Sprite;
		protected var _view: IViewPort;
		private var _orientation: String = ScrollBarOrientation.VERTICAL;
		private var _viewStepScale: Number = 0;
		private var _scrollStepScale: Number = 0;
		private var _scrollPolicy: String = ScrollBarPolicy.AUTO;
		private var _value: Number = 0;
		private var _maxValue: Number = 0;
		private var _autoScroll: Boolean = false;
		private var _oldBarMouseDownPos: Number;
		private var _oldBarMousePos: Number;
		private var _width: Number;
		private var _height: Number;
		
		private static const MIN_BAR_SIZE: Number = 14;
		private static const MAX_STEP: Number = 5;
		
		public function ScrollBar(_skin:DisplayObjectContainer=null)
		{
			var size: Point = UIUtils.getSkinSize(_skin);
			super(_skin);
			_upButton = getUI(Button, "btnUp") as Button;
			_downButton = getUI(Button, "btnDown") as Button;
			_trackSprite = getSkin("track") as Sprite;
			_bar = getSkin("bar") as Sprite;
			_barIcon = getSkin("barIcon") as Sprite;
			sortChildIndex();
			
			if(_upButton != null)
			{
				_upButton.addEventListener(MouseEvent.CLICK, onUpButtonClick);
			}
			if(_downButton != null)
			{
				_downButton.addEventListener(MouseEvent.CLICK, onDownButtonClick);
			}
			
			_bar.mouseEnabled = true;
			_bar.buttonMode = true;
			_bar.addEventListener(MouseEvent.MOUSE_DOWN, onBarMouseDown);
			
			width = size.x;
			height = size.y;
			_width = size.x;
			_height = size.y;
		}
		
		protected function onUpButtonClick(evt: MouseEvent): void
		{
			
		}
		
		protected function onDownButtonClick(evt: MouseEvent): void
		{
			
		}
		
		protected function onBarMouseDown(evt: MouseEvent): void
		{
			GameManager.container.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			GameManager.container.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			_oldBarMouseDownPos = trackMousePosition;
			_oldBarMousePos = barMousePosition;
		}
		
		protected function onMouseMove(evt: MouseEvent): void
		{
			var mouseOffset: Number = trackMousePosition - _oldBarMouseDownPos;
			value = value + mouseOffset;
			
			if(value == 0)
			{
				_oldBarMouseDownPos = _oldBarMousePos;
			}
			else if(value == _maxValue)
			{
				if(_orientation == ScrollBarOrientation.VERTICAL)
				{
					_oldBarMouseDownPos = _trackSprite.height - _bar.height + _oldBarMousePos;
				}
				else
				{
					_oldBarMouseDownPos = _trackSprite.width - _bar.width + _oldBarMousePos;
				}
			}
			else
			{
				_oldBarMouseDownPos = trackMousePosition;
			}
		}
		
		protected function onMouseUp(evt: MouseEvent): void
		{
			GameManager.container.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			GameManager.container.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		public function get orientation(): String
		{
			return _orientation;
		}
		
		public function set orientation(value: String): void
		{
			if(_orientation != value)
			{
				_orientation = value;
				rebuild();
			}
		}
		
		public function get view(): IViewPort
		{
			return _view;
		}
		
		public function set view(value: IViewPort): void
		{
			if(_view != null)
			{
				_view.removeEventListener(Event.RESIZE, onViewResize);
				_view.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
				if(_orientation == ScrollBarOrientation.VERTICAL)
				{
					_view.removeEventListener(ViewEvent.MAX_HEIGHT_CHANGE, onViewResize);
				}
				else
				{
					_view.removeEventListener(ViewEvent.MAX_WIDTH_CHANGE, onViewResize);
				}
			}
			_view = value;
			if(_view != null)
			{
				_view.addEventListener(Event.RESIZE, onViewResize);
				_view.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
				if(_orientation == ScrollBarOrientation.VERTICAL)
				{
					_view.addEventListener(ViewEvent.MAX_HEIGHT_CHANGE, onViewResize);
				}
				else
				{
					_view.addEventListener(ViewEvent.MAX_WIDTH_CHANGE, onViewResize);
				}
			}
			rebuild();
		}
		
		protected function onMouseWheel(evt: MouseEvent): void
		{
			value = value - evt.delta * 3;
		}
		
		protected function onViewResize(evt: Event): void
		{
			rebuild();
		}
		
		public function rebuild(): void
		{
			if(_view != null)
			{
				updateBarSize();
				rebuildUI();
				updateBarPosition();
				updateVisible();
			}
		}
		
		protected function rebuildUI(): void
		{
			if(_orientation == ScrollBarOrientation.VERTICAL)
			{
				if(_upButton != null && _downButton != null)
				{
					_upButton.x = 0;
					_upButton.y = 0;
					_trackSprite.y = _upButton.height;
					_trackSprite.height = _height - _upButton.height - _downButton.height;
				}
				else if(_upButton == null && _downButton != null)
				{
					_trackSprite.y = 0;
					_trackSprite.height = _height - _downButton.height;
					_downButton.x = 0;
					_downButton.y = _height - _downButton.height;
				}
				else if(_upButton != null && _downButton == null)
				{
					_upButton.x = 0;
					_upButton.y = 0;
					_trackSprite.y = _upButton.height;
					_trackSprite.height = _height - _upButton.height;
				}
				else
				{
					_trackSprite.y = 0;
					_trackSprite.height = _height;
				}
				_trackSprite.x = 0;
				_bar.x = 0;
				_bar.y = _value + _trackSprite.y;
				updateBarIconPosition();
			}
			else
			{
				if(_upButton != null && _downButton != null)
				{
					_upButton.y = 0;
					_upButton.x = 0;
					_trackSprite.x = _upButton.width;
					_trackSprite.width = _width - _upButton.width - _downButton.width;
				}
				else if(_upButton == null && _downButton != null)
				{
					_trackSprite.x = 0;
					_trackSprite.width = _width - _downButton.width;
					_downButton.y = 0;
					_downButton.x = _width - _downButton.width;
				}
				else if(_upButton != null && _downButton == null)
				{
					_upButton.y = 0;
					_upButton.x = 0;
					_trackSprite.x = _upButton.width;
					_trackSprite.width = _width - _upButton.width;
				}
				else
				{
					_trackSprite.x = 0;
					_trackSprite.width = _width;
				}
				_trackSprite.y = 0;
				_bar.y = 0;
				_bar.x = _value + _trackSprite.x;
				updateBarIconPosition();
			}
		}
		
		protected function updateBarIconPosition(): void
		{
			if(_barIcon != null)
			{
				if(_orientation == ScrollBarOrientation.VERTICAL)
				{
					_barIcon.y = _bar.y + _bar.height * .5;
				}
				else
				{
					_barIcon.x = _bar.x + _bar.width * .5;
				}
			}
		}
		
		protected function updateBarSize(): void
		{
			var barSize: Number;
			var contentSize: Number;
			var maxSize: Number;
			var trackSize: Number;
			
			if(_orientation == ScrollBarOrientation.VERTICAL)
			{
				contentSize = _view.contentHeight;
				maxSize = _view.maxHeight;
				trackSize = _trackSprite.height;
			}
			else
			{
				contentSize = _view.contentWidth;
				maxSize = _view.maxWidth;
				trackSize = _trackSprite.width;
			}
			
			if(maxSize - contentSize > 0)
			{
				barSize = contentSize / maxSize * trackSize;
				barSize = Math.max(barSize, MIN_BAR_SIZE);
				_maxValue = trackSize - barSize;
				_viewStepScale = (maxSize - contentSize) / _maxValue;
				_scrollStepScale = 1 / _viewStepScale;
			}
			else
			{
				barSize = 0;
				_maxValue = 0;
				_viewStepScale = 0;
				_scrollStepScale = 0;
			}
			
			if(_orientation == ScrollBarOrientation.VERTICAL)
			{
				_bar.height = barSize;
			}
			else
			{
				_bar.width = barSize;
			}
			updateBarIconPosition();
			value = Math.min(_value, _maxValue);
			updateAutoScroll();
			dispatchEvent(new ScrollBarEvent(ScrollBarEvent.RESIZE));
		}
		
		protected function updateBarPosition(): void
		{
			var barSize: Number;
			var barPosition: Number;
			var availableSize: Number;
			
			if(_orientation == ScrollBarOrientation.VERTICAL)
			{
				barSize = _bar.height;
				barPosition = _bar.y;
				
				if(_downButton != null)
				{
					availableSize = height - _downButton.height;
				}
				else
				{
					availableSize = height;
				}
			}
			else
			{
				barSize = _bar.width;
				barPosition = _bar.x;
				
				if(_downButton != null)
				{
					availableSize = width - _downButton.width;
				}
				else
				{
					availableSize = width;
				}
			}
			if(barPosition < 0)
			{
				barPosition = 0;
			}
			else if(barPosition + barSize > availableSize)
			{
				barPosition = availableSize - barSize;
			}
			if(_orientation == ScrollBarOrientation.VERTICAL)
			{
				_bar.y = barPosition;
			}
			else
			{
				_bar.x = barPosition;
			}
			updateBarIconPosition();
		}
		
		protected function updateVisible(): void
		{
			if(_scrollPolicy == ScrollBarPolicy.AUTO)
			{
				if(_maxValue > 0)
				{
					visible = true;
				}
				else
				{
					visible = false;
				}
			}
			else if(_scrollPolicy == ScrollBarPolicy.ON)
			{
				visible = true;
			}
			else
			{
				visible = false;
			}
		}
		
		protected function updateAutoScroll(): void
		{
			if(_autoScroll)
			{
				value = _maxValue;
			}
		}

		public function get value():Number
		{
			return _value;
		}

		public function set value(value:Number):void
		{
			if(_view != null)
			{
				value = Math.max(value, 0);
				value = Math.min(value, _maxValue);
				if(_value != value)
				{
					_value = value;
					rebuildUI();
					updateBarPosition();
				}
				if(_orientation == ScrollBarOrientation.VERTICAL)
				{
					_view.vScrollPosition = _value * _viewStepScale;
				}
				else
				{
					_view.hScrollPosition = _value * _viewStepScale;
				}
			}
		}

		public function get autoScroll():Boolean
		{
			return _autoScroll;
		}

		public function set autoScroll(value:Boolean):void
		{
			_autoScroll = value;
			updateAutoScroll();
		}

		public function get scrollPolicy():String
		{
			return _scrollPolicy;
		}

		public function set scrollPolicy(value:String):void
		{
			_scrollPolicy = value;
			updateVisible();
		}
		
		protected function get trackMousePosition(): Number
		{
			var _pos: Point = MouseUtils.getMousePosition(_trackSprite);
			if(_orientation == ScrollBarOrientation.VERTICAL)
			{
				return _pos.y;
			}
			return _pos.x;
		}
		
		protected function get barMousePosition(): Number
		{
			var _pos: Point = MouseUtils.getMousePosition(_bar);
			if(_orientation == ScrollBarOrientation.VERTICAL)
			{
				return _pos.y;
			}
			return _pos.x;
		}
		
		override public function set height(value:Number):void
		{
			_height = value;
			if(_orientation == ScrollBarOrientation.VERTICAL)
			{
				if(_upButton != null && _downButton != null)
				{
					_upButton.x = 0;
					_upButton.y = 0;
					_trackSprite.y = _upButton.height;
					_trackSprite.height = value - _upButton.height - _downButton.height;
				}
				else if(_upButton == null && _downButton != null)
				{
					_trackSprite.y = 0;
					_trackSprite.height = value - _downButton.height;
					_downButton.x = 0;
					_downButton.y = value - _downButton.height;
				}
				else if(_upButton != null && _downButton == null)
				{
					_upButton.x = 0;
					_upButton.y = 0;
					_trackSprite.y = _upButton.height;
					_trackSprite.height = value - _upButton.height;
				}
				else
				{
					_trackSprite.y = 0;
					_trackSprite.height = value;
				}
				rebuild();
			}
		}
		
		override public function set width(value:Number):void
		{
			_width = value;
			if(_orientation == ScrollBarOrientation.HORIZONTAL)
			{
				if(_upButton != null && _downButton != null)
				{
					_upButton.y = 0;
					_upButton.x = 0;
					_trackSprite.x = _upButton.width;
					_trackSprite.width = value - _upButton.width - _downButton.width;
				}
				else if(_upButton == null && _downButton != null)
				{
					_trackSprite.x = 0;
					_trackSprite.width = value - _downButton.width;
					_downButton.y = 0;
					_downButton.x = value - _downButton.width;
				}
				else if(_upButton != null && _downButton == null)
				{
					_upButton.y = 0;
					_upButton.x = 0;
					_trackSprite.x = _upButton.width;
					_trackSprite.width = value - _upButton.width;
				}
				else
				{
					_trackSprite.x = 0;
					_trackSprite.width = value;
				}
				rebuild();
			}
		}
	}
}