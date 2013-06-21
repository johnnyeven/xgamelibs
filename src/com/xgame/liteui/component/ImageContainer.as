package com.xgame.liteui.component
{
	import com.greensock.TweenLite;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.text.TextFieldAutoSize;
	
	import com.xgame.utils.RequestUtils;
	import com.xgame.utils.StringUtils;
	import com.xgame.utils.UIUtils;
	import com.xgame.liteui.core.Component;
	
	public class ImageContainer extends Component
	{
		private var _loader: Loader;
		private var _source: String;
		public var align: String;
		
		public function ImageContainer(_skin:DisplayObjectContainer=null)
		{
			super(null);
			
			if(_skin != null)
			{
				UIUtils.setCommonProperty(this, _skin);
				UIUtils.remove(_skin);
			}
			
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoadIOError);
			//addChild(_loader);
		}
		
		override public function dispose():void
		{
			super.dispose();
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoadComplete);
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onLoadIOError);
			closeLoader();
			_loader = null;
		}
		
		protected function onLoadComplete(evt: Event): void
		{
			var _loaderInfo: LoaderInfo = evt.target as LoaderInfo;
			if(_loaderInfo.content is Bitmap)
			{
				addChild(_loaderInfo.content);
				TweenLite.from(_loaderInfo.content, .5, {alpha: 0});
			}
			dispatchEvent(new Event(Event.COMPLETE));
			if(parent != null)
			{
				if(align == TextFieldAutoSize.CENTER)
				{
					x = parent.width * .5 - width * .5;
				}
			}
		}
		
		protected function onLoadIOError(evt: IOErrorEvent): void
		{
			trace(evt.text);
		}
		
		private function closeLoader(): void
		{
			try
			{
				_loader.unloadAndStop();
				_loader.close();
			}
			catch(err: Error)
			{
			}
		}

		public function get source():String
		{
			return _source;
		}

		public function set source(value:String):void
		{
			if(_source == value)
			{
				return;
			}
			_source = value;
			closeLoader();
			
			if(!StringUtils.empty(_source))
			{
				var _urlRequest: URLRequest = RequestUtils.getRequestByVersion(_source);
				_loader.load(_urlRequest);
			}
		}
	}
}