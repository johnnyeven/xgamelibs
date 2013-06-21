package utils.liteui.component
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Bounce;
	import com.greensock.easing.Strong;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Shape;
	
	import utils.enum.ProgressBarType;
	import utils.liteui.core.Component;
	
	public class ProgressBar extends Component
	{
		public var type: int = ProgressBarType.MASK;
		protected var _mask: Shape;
		protected var _trackObject: DisplayObject;
		protected var _barObject: DisplayObject;
		protected var _barWidth: Number = 0;
		private var _percent: Number = 0;
		
		public function ProgressBar(_skin:DisplayObjectContainer=null, _type: int = 0)
		{
			super(_skin);
			_trackObject = getSkin("track");
			_barObject = getSkin("bar");
			
			type = _type;
		}
		
		public function initProgressBar(): void
		{
			if(type == ProgressBarType.MASK)
			{
				_mask = new Shape();
				_mask.graphics.beginFill(0, 1);
				_mask.graphics.drawRect(0, 0, 0, 1);
				_mask.graphics.endFill();
				addChild(_mask);
				_barObject.mask = _mask;
				_mask.x = _barObject.x;
				_mask.y = _barObject.y;
				_mask.height = _barObject.height;
			}
			else if(type == ProgressBarType.SCALE)
			{
				_barWidth = _barObject.width;
				_barObject.width = 0;
			}
			else
			{
				if(_barObject is MovieClip)
				{
					(_barObject as MovieClip).gotoAndStop(1);
				}
			}
			update();
		}
		
		public function get percent():Number
		{
			return _percent;
		}

		public function set percent(value:Number):void
		{
			_percent = value;
			update();
		}
		
		private function update(): void
		{
			if(_percent > 1)
			{
				_percent = 1;
			}
			else if(_percent < 0 || isNaN(_percent))
			{
				_percent = 0;
			}
			if(type == ProgressBarType.MASK)
			{
				TweenLite.to(_mask, .5, {width: _percent * _barObject.width, ease: Strong.easeOut});
			}
			else if(type == ProgressBarType.SCALE)
			{
				TweenLite.to(_barObject, .5, {width: _percent * _barWidth, ease: Strong.easeOut});
			}
			else
			{
				if(_barObject is MovieClip)
				{
					TweenLite.to((_barObject as MovieClip), 1, {frame: Math.floor(_percent * 100), ease: Bounce.easeOut});
				}
			}
		}
	}
}