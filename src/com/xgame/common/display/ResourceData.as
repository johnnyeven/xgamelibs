package com.xgame.common.display
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.errors.IllegalOperationError;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	public class ResourceData
	{
		/**
		 * 原始位图
		 */
		protected var _bitmap: BitmapData;
		protected var _bitmapDictionary: Dictionary;
		protected var _actionDataDictionary: Dictionary;
		protected var _frameArray: Vector.<Vector.<BitmapFrame>>;
		protected var _frameLine: uint = 1;
		protected var _frameTotal: uint = 1;
		protected var _fps: Number = 0;
		protected var _currentAction: int = -1;
		private var _rect: Rectangle;
		private var _frameWidth: uint = 0;
		private var _frameHeight: uint = 0;
		
		public function ResourceData()
		{
			_bitmapDictionary = new Dictionary();
			_actionDataDictionary = new Dictionary();
		}
		
		/**
		 * 分解后的位图
		 */
		public function get bitmapArray():Vector.<Vector.<BitmapFrame>>
		{
			return _frameArray;
		}
		
		/**
		 * 单元宽度
		 */
		public function get frameWidth():uint
		{
			return _frameWidth;
		}
		
		/**
		 * 单元高度
		 */
		public function get frameHeight():uint
		{
			return _frameHeight;
		}
		
		/**
		 * 动作帧频
		 */
		public function get fps():Number
		{
			return _fps;
		}
		
		/**
		 * @private
		 */
		public function set fps(value:Number):void
		{
			_fps = value;
		}
		
		/**
		 * 绘制的矩形区域大小
		 */
		public function get rect():Rectangle
		{
			return _rect;
		}
		
		/**
		 * 动作的总帧数
		 */
		public function get frameTotal():uint
		{
			return _frameTotal;
		}
		
		/**
		 * 素材的总行数，对于角色来说是方向总数
		 */
		public function get frameLine():uint
		{
			return _frameLine;
		}
		
		/**
		 * 分解原始位图切成小片
		 */
		private function prepareBitmapArray(): Vector.<Vector.<BitmapFrame>>
		{
			if(_bitmap != null)
			{
				var frameConfig: Array;
				try
				{
					frameConfig = _bitmap["frameConfig"] as Array;
				}
				catch(err: Error)
				{
					frameConfig = null;
				}
				var bmArray: Vector.<Vector.<BitmapFrame>> = new Vector.<Vector.<BitmapFrame>>();
				for(var y: uint = 0; y < _frameLine; y++)
				{
					var line: Vector.<BitmapFrame> = new Vector.<BitmapFrame>();
					for(var x: uint = 0; x < _frameTotal; x++)
					{
						var bm: BitmapData = new BitmapData(_frameWidth, _frameHeight, true, 0x00000000);
						var rect: Rectangle = new Rectangle(x * _frameWidth, y * _frameHeight, _frameWidth, _frameHeight);
						bm.copyPixels(_bitmap, rect, new Point(), null, null, true);
						
						var _frame: BitmapFrame = new BitmapFrame();
						_frame.bitmapData = bm;
						
						if(frameConfig != null)
						{
							_frame.offsetX = frameConfig[y][x].offsetX;
							_frame.offsetY = frameConfig[y][x].offsetY;
							_frame.label = frameConfig[y][x].label;
						}
						else
						{
							_frame.offsetX = 0;
							_frame.offsetY = 0;
							_frame.label = "";
						}
						line.push(_frame);
					}
					bmArray.push(line);
				}
				return bmArray;
			}
			else
			{
				return null;
			}
		}
		
		/**
		 * 获取资源
		 */
		public function getResource(data: BitmapData, action: int = 0, frameLine: uint = 1, frameTotal: uint = 1, fps: Number = 0): void
		{
			_frameLine = frameLine;
			_frameTotal = frameTotal;
			_frameWidth = int(data.width / _frameTotal);
			_frameHeight = int(data.height / _frameLine);
			_fps = fps;
			_bitmap = data;
			
			_bitmapDictionary[action] = prepareBitmapArray();
			_actionDataDictionary[action] = new ActionData(action, frameTotal, frameLine, fps);
//			_bitmap.dispose();
			_bitmap = null;
		}
		
		/**
		 * 输出图形到界面上
		 */
		public function render(target: Bitmap, line: uint, frame: uint): void
		{
			if(_frameArray != null)
//			{
//				target.bitmapData = null;
//			}
//			else
			{
				target.bitmapData = _frameArray[line][frame].bitmapData;
			}
		}
		
		/**
		 * 清理
		 */
		public function dispose(): void
		{
			if(_bitmap != null)
			{
//				_bitmap.dispose();
				_bitmap = null;
			}
			for(var i: String in _bitmapDictionary)
			{
				for(var y: uint = 0; y < _frameLine; y++)
				{
					for(var x: uint = 0; x < _frameTotal; x++)
					{
						_bitmapDictionary[i][y][x].dispose();
					}
					_bitmapDictionary[i][y].splice(0, _frameTotal);
				}
				_bitmapDictionary[i].splice(0, _frameLine);
				delete _bitmapDictionary[i];
				_bitmapDictionary[i] = null;
			}
			for(i in _actionDataDictionary)
			{
				delete _actionDataDictionary[i];
				_actionDataDictionary[i] = null;
			}
			_rect = null;
		}

		public function get currentAction():int
		{
			return _currentAction;
		}

		public function set currentAction(value:int):void
		{
			if(_currentAction != value)
			{
				_currentAction = value;
				if(_bitmapDictionary[value] != null)
				{
					_frameArray = _bitmapDictionary[value];
					var actionData: ActionData = _actionDataDictionary[value];
					if(actionData != null)
					{
						_frameLine = actionData.lineTotal;
						_frameTotal = actionData.frameTotal;
						_fps = actionData.fps;
					}
					else
					{
						throw new IllegalOperationError("该动作位图资源与配置数据不一致");
					}
				}
			}
		}

	}
}