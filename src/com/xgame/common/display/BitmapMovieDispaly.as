package com.xgame.common.display
{
	import com.xgame.common.behavior.Behavior;
	import com.xgame.configuration.GlobalContextConfig;
	
	import flash.geom.Rectangle;

	public class BitmapMovieDispaly extends BitmapDisplay
	{
		protected var _currentFrame: uint;
		protected var _prevFrame: uint;
		protected var _totalFrame: uint;
		protected var _isLoop: Boolean;
		protected var _isEnd: Boolean;
		protected var _lastFrameTime: uint;
		protected var _playTime: uint;
		
		public function BitmapMovieDispaly(behavior: Behavior = null)
		{
			super(behavior);
			_currentFrame = 0;
			_prevFrame = 0;
			_totalFrame = 0;
			_isLoop = false;
			_isEnd = false;
			_lastFrameTime = GlobalContextConfig.Timer;
		}
		
		protected function updateFPS(): void
		{
			_totalFrame = _graphic.frameTotal;
			_playTime = _graphic.fps == 0 ? 0 : (1000 / _graphic.fps);
		}
		
		override protected function rebuild():void
		{
			super.rebuild();
			updateFPS();
		}
		
		protected function step(): Boolean
		{
			if(_graphic == null || _graphic.fps == 0)
			{
				return false;
			}
			if(GlobalContextConfig.Timer - _lastFrameTime > _playTime && !_isEnd)
			{
				_lastFrameTime = GlobalContextConfig.Timer;
				_prevFrame = _currentFrame;
				
				if(_currentFrame >= _totalFrame - 1)
				{
					_isLoop ? _currentFrame = 0 : _isEnd = true;
				}
				else
				{
					_currentFrame++;
				}
			}
			return true;
		}
		
		override protected function updateActionPre():void
		{
			step();
		}

		public function get currentFrame():uint
		{
			return _currentFrame;
		}

		public function set currentFrame(value:uint):void
		{
			_currentFrame = value;
		}

		public function get prevFrame():uint
		{
			return _prevFrame;
		}

		public function get isLoop():Boolean
		{
			return _isLoop;
		}

		public function set isLoop(value:Boolean):void
		{
			_isLoop = value;
			if(value)
			{
				_isEnd = false;
			}
		}

		public function get isKeepStatic(): Boolean
		{
			return !_isLoop && _isEnd;
		}
		
		override public function get rect():Rectangle
		{
			_rect.x = _currentFrame * _graphic.frameWidth;
			_rect.y = 0;
			_rect.width = _graphic.frameWidth;
			_rect.height = _graphic.frameHeight;
			return _rect;
		}
		
		override public function get renderLine():uint
		{
			return 0;
		}
		
		override public function get renderFrame():uint
		{
			return _currentFrame;
		}
	}
}