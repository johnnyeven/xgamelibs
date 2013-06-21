package utils.liteui.component
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import utils.StringUtils;
	import utils.events.TreeEvent;
	import utils.liteui.core.Component;
	import utils.liteui.layouts.HorizontalTileLayout;
	import utils.liteui.layouts.Margin;
	import utils.resource.ResourcePool;
	
	public class TreeNode extends Component
	{
		private var _rootNode: TreeView;
		private var _parentNode: TreeNode;
		private var _expandStatus: Boolean = false;
		private var _caption: Label;
		private var _listIcon: DisplayObject;
		private var _seperator: DisplayObject;
		private var _clickArea: Sprite;
		private var _childNode: Vector.<TreeNode>;
		private var _childContainer: Sprite;
		private var _childContainerLayout: HorizontalTileLayout;
		public static var padding: Margin = new Margin(8, 0, 8, 0);
		public static var indent: uint = 10;
		
		public function TreeNode(_caption: String = null, _parent: TreeNode = null, _root: TreeView = null)
		{
			super();
			_childNode = new Vector.<TreeNode>();
			_childContainer = new Sprite();
			_childContainerLayout = new HorizontalTileLayout(_childContainer);
			
			this._caption = new Label();
			this._caption.color = 0x0099FF;
			this._caption.size = 12;
			this._caption.x = indent;
			this._caption.y = padding.top;
			addChild(this._caption);
			
			if(!StringUtils.empty(_caption))
			{
				this._caption.text = _caption;
			}
			if(_parent != null)
			{
				_parentNode = _parent;
			}
			if(_root != null)
			{
				_rootNode = _root;
			}
			
			_seperator = ResourcePool.getResource("ui.TreeView.Seperator");
			
			addChild(_seperator);
			
			_clickArea = new Sprite();
			addChild(_clickArea);
			
			_clickArea.addEventListener(MouseEvent.CLICK, onAreaClick);
		}
		
		override protected function onMouseOver(evt:MouseEvent):void
		{
			_clickArea.alpha = .1;
		}
		
		override protected function onMouseOut(evt:MouseEvent):void
		{
			_clickArea.alpha = 0;
		}
		
		private function onAreaClick(evt: MouseEvent): void
		{
			if(_childNode.length > 0)
			{
				if(_expandStatus)
				{
					_expandStatus = false;
					collspand();
				}
				else
				{
					_expandStatus = true;
					expand();
				}
			}
			else
			{
				var _treeEvent: TreeEvent = new TreeEvent(TreeEvent.TREE_NODE_CLICK, true);
				_treeEvent.caption = caption;
				
				dispatchEvent(_treeEvent);
			}
		}
		
		public function add(child: TreeNode): void
		{
			if(_childNode.indexOf(child) == -1)
			{
				child.rootNode = _rootNode;
				child.parentNode = this;
				
				_childNode.push(child);
				_childContainer.addChild(child);
				update();
			}
		}
		
		public function remove(child: TreeNode): void
		{
			var index: int = _childNode.indexOf(child);
			if(index != -1)
			{
				_childNode.splice(index, 1);
				_childContainer.removeChild(child);
				update();
			}
		}
		
		public function get availableHeight(): Number
		{
			return padding.top + _caption.height + padding.bottom;
		}

		public function get rootNode():TreeView
		{
			return _rootNode;
		}

		public function set rootNode(value:TreeView):void
		{
			_rootNode = value;
			update();
		}
		
		public function get parentNode():TreeNode
		{
			return _parentNode;
		}
		
		public function set parentNode(value:TreeNode):void
		{
			_parentNode = value;
		}

		public function get caption(): String
		{
			return _caption.text;
		}

		public function set caption(value: String):void
		{
			_caption.text = value;
			update();
		}
		
		public function get color(): uint
		{
			return _caption.color;
		}
		
		public function set color(value: uint):void
		{
			_caption.color = value;
		}
		
		public function get size(): uint
		{
			return _caption.size;
		}
		
		public function set size(value: uint):void
		{
			_caption.size = value;
			update();
		}
		
		public function update(): void
		{
			if(_rootNode != null)
			{
				_clickArea.graphics.clear();
				_clickArea.graphics.beginFill(0xFFFFFF, 1);
				_clickArea.graphics.drawRect(0, 0, _rootNode.innerWidth, availableHeight);
				_clickArea.graphics.endFill();
				_clickArea.alpha = 0;
				
				_seperator.x = -seperatorOffset;
				_seperator.y = availableHeight - _seperator.height;
				_seperator.width = _rootNode.innerWidth;
			}
			_caption.x = indent;
			_caption.y = padding.top;
			
			_childContainer.x = indent;
			_childContainer.y = availableHeight;
			
			autoFixListIcon();
			
			if(_expandStatus && _childNode.length > 0)
			{
				_childContainerLayout.update();
				
				var _child: TreeNode;
				for each(_child in _childNode)
				{
					_child.update();
				}
			}
		}
		
		public function get seperatorOffset(): Number
		{
			if(_parentNode != null)
			{
				return _parentNode.seperatorOffset + indent;
			}
			else
			{
				return 0;
			}
		}
		
		private function autoFixListIcon(): void
		{
			if(_childNode.length > 0)
			{
				if(_listIcon == null)
				{
					_listIcon = ResourcePool.getResource("ui.TreeView.Icon");
					addChild(_listIcon);
				}
				_listIcon.x = 0;
				_listIcon.y = (availableHeight - _listIcon.height) * .5;
			}
			else
			{
				if(_listIcon != null)
				{
					removeChild(_listIcon);
					_listIcon = null;
				}
			}
		}
		
		public function expand(): void
		{
			addChild(_childContainer);
			_rootNode.update();
		}
		
		public function collspand(): void
		{
			removeChild(_childContainer);
			_rootNode.update();
		}
	}
}