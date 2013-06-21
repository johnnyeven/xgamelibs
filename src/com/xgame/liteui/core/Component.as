package com.xgame.liteui.core
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import com.xgame.utils.UIUtils;
	import com.xgame.liteui.layouts.BaseLayout;
	
	public class Component extends Sprite
	{
		private var _isDispose: Boolean;
		private var _enabled: Boolean;
		private var _eventListener: Dictionary;
		private var _skin: DisplayObjectContainer;
		private var _changeWatcherList: Array;
		protected var _filterColor: Number = 0x000000;
		protected var _filterEnabled: Boolean = true;
		protected var _skinChildIndex: Dictionary;
		protected var _skinChildIndexList: Array;
		protected var _layout: BaseLayout;
		public var mediator: Mediator;
		
		public function Component(_skin: DisplayObjectContainer = null)
		{
			super();
			
			_isDispose = false;
			_enabled = true;
			_skinChildIndex = new Dictionary();
			_skinChildIndexList = new Array();
			_changeWatcherList = new Array();
			this._skin = _skin;
			if(this._skin != null)
			{
				UIUtils.setCommonProperty(this, _skin);
				while(this._skin.numChildren > 0)
				{
					var _child: DisplayObject = this._skin.getChildAt(0);
					addChild(_child);
					
					_skinChildIndex[_child.name] = _child;
					_skinChildIndexList.push(_child.name);
					
					if(_child is InteractiveObject)
					{
						(_child as InteractiveObject).mouseEnabled = false;
					}
				}
			}
			
			addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
			addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
		}
		
		public function sortChildIndex(): void
		{
			for(var i: uint = 0; i<_skinChildIndexList.length; i++)
			{
				setChildIndex(_skinChildIndex[_skinChildIndexList[i]], i);
			}
		}
		
		public function updateChildByName(_childName: String, _child: DisplayObject): void
		{
			_skinChildIndex[_childName] = _child;
		}
		
		public function getUI(_componentClass: Class, _skinName: String): Sprite
		{
			var _skin: DisplayObject = getSkin(_skinName);
			if(_skin != null)
			{
				var _ui: Sprite = new _componentClass(_skin) as Sprite;
				addChild(_ui);
				updateChildByName(_skinName, _ui);
				return _ui;
			}
			return null;
		}
		
		public function getUIByDisplay(_componentClass: Class, _display: DisplayObject): Sprite
		{
			if(_display != null)
			{
				var _ui: Sprite = new _componentClass(_display) as Sprite;
				addChild(_ui);
				updateChildByName(_display.name, _ui);
				return _ui;
			}
			return null;
		}
		
		protected function getSkin(_skinName: String): DisplayObject
		{
			var _child: DisplayObject = getChildByName(_skinName);
			if(_child != null)
			{
				return _child;
			}
			//throw new Error("getSkin(_skinName): " + _skinName + " 未定义");
			return null;
		}
		
		protected function onMouseOver(evt: MouseEvent): void
		{
			
		}
		
		protected function onMouseOut(evt: MouseEvent): void
		{
			
		}
		
		protected function setFilter(): void
		{
		}
		
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
			
			if(_eventListener == null)
			{
				_eventListener = new Dictionary();
			}
			
			var _listener: Vector.<Function>;
			if(_eventListener[type] != null)
			{
				_listener = _eventListener[type] as Vector.<Function>;
				var _index: int = _listener.indexOf(listener);
				if(_index == -1)
				{
					_listener.push(listener);
				}
				else
				{
					_listener[_index] = listener;
				}
				_eventListener[type] = _listener;
			}
			else
			{
				_listener = new Vector.<Function>();
				_listener.push(listener);
				_eventListener[type] = _listener;
			}
		}
		
		public function dispose(): void
		{
			if(_isDispose)
			{
				return;
			}
			if(parent != null)
			{
				parent.removeChild(this);
			}
			removeChangeWatcher();
			removeEventListeners();
			removeChildren();
			
			if(_layout != null)
			{
				_layout.dispose();
			}
			_layout = null;
			
			_isDispose = true;
		}
		
		public function removeChangeWatcher(): void
		{
			while(_changeWatcherList.length > 0)
			{
				_changeWatcherList.pop().unwatch();
			}
		}
		
		public function removeEventListeners(): void
		{
			if(_eventListener != null)
			{
				for(var type: String in _eventListener)
				{
					removeEventListenerType(type);
				}
				_eventListener = null;
			}
		}
		
		protected function removeEventListenerType(type: String): void
		{
			var _listener: Vector.<Function> = _eventListener[type] as Vector.<Function>;
			
			for(var i:uint = 0; i < _listener.length; i++)
			{
				removeEventListener(type, _listener[i]);
			}
		}

		public function get filterColor():Number
		{
			return _filterColor;
		}

		public function set filterColor(value:Number):void
		{
			_filterColor = value;
			setFilter();
		}

		public function get filterEnabled():Boolean
		{
			return _filterEnabled;
		}

		public function set filterEnabled(value:Boolean):void
		{
			_filterEnabled = value;
			setFilter();
		}

		public function get layout():BaseLayout
		{
			return _layout;
		}

		public function set layout(value:BaseLayout):void
		{
			_layout = value;
		}


	}
}