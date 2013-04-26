package com.xgame.common.display
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class ResourceData
	{
		/**
		 * 原始位图
		 */
		protected var _bitmap: BitmapData;
		protected var _bitmapArray: Vector.<Vector.<BitmapData>>;
		protected var _currentAction: int = 0;
		protected var _frameLine: uint = 1;
		protected var _frameTotal: uint = 1;
		protected var _fps: Number = 0;
		private var _rect: Rectangle;
		private var _frameWidth: uint = 0;
		private var _frameHeight: uint = 0;
		
		public function ResourceData()
		{
		}
		
		/**
		 * 分解后的位图
		 */
		public function get bitmapArray():Vector.<Vector.<BitmapData>>
		{
			return _bitmapArray;
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
		 * 当前的动作
		 */
		public function get currentAction():int
		{
			return _currentAction;
		}
		
		/**
		 * 分解原始位图切成小片
		 */
		private function prepareBitmapArray(): Vector.<Vector.<BitmapData>>
		{
			if(_bitmap != null)
			{
				var bmArray: Vector.<Vector.<BitmapData>> = new Vector.<Vector.<BitmapData>>();
				for(var y: uint = 0; y < _frameLine; y++)
				{
					var line: Vector.<BitmapData> = new Vector.<BitmapData>();
					for(var x: uint = 0; x < _frameTotal; x++)
					{
						var bm: BitmapData = new BitmapData(_frameWidth, _frameHeight, true, 0x00000000);
						var rect: Rectangle = new Rectangle(x * _frameWidth, y * _frameHeight, _frameWidth, _frameHeight);
						bm.copyPixels(_bitmap, rect, new Point(), null, null, true);
						line.push(bm);
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
		public function getResource(data: BitmapData, frameLine: uint = 1, frameTotal: uint = 1, fps: Number = 0): void
		{
			_frameLine = frameLine;
			_frameTotal = frameTotal;
			_frameWidth = int(data.width / _frameTotal);
			_frameHeight = int(data.height / _frameLine);
			_fps = fps;
			_bitmap = data;
			
			_bitmapArray = prepareBitmapArray();
			if(_bitmapArray != null)
			{
				_bitmap = null;
			}
		}
		
		/**
		 * 输出图形到界面上
		 */
		public function render(target: Bitmap, line: uint, frame: uint): void
		{
			if(_bitmapArray != null)
			{
				target.bitmapData = _bitmap;
			}
			else
			{
				target.bitmapData = _bitmapArray[line][frame];
			}
		}
		
		/**
		 * 清理
		 */
		public function dispose(): void
		{
			_bitmap = null;
			for(var y: uint = 0; y < _frameLine; y++)
			{
				for(var x: uint = 0; x < _frameTotal; x++)
				{
					_bitmapArray[y][x].dispose();
				}
				_bitmapArray[y].splice(0, _frameTotal);
			}
			_bitmapArray.splice(0, _frameLine);
			_bitmapArray = null;
			_rect = null;
		}
	}
}