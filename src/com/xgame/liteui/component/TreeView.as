package utils.liteui.component
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	
	import utils.enum.ScrollBarOrientation;
	import utils.liteui.core.Component;
	import utils.liteui.layouts.HorizontalTileLayout;
	import utils.liteui.layouts.Margin;
	import utils.resource.ResourcePool;
	
	public class TreeView extends Component
	{
		private var _container: Container;
		private var _scrollBar: ScrollBar;
		private var _padding: Margin;
		private var _node: Vector.<TreeNode>;
		
		public function TreeView()
		{
			super();
			
			_container = new Container();
			_container.layout = new HorizontalTileLayout(_container);
			_scrollBar = getUIByDisplay(ScrollBar, ResourcePool.getResource("ui.VScrollBar")) as ScrollBar;
			_scrollBar.orientation = ScrollBarOrientation.VERTICAL;
			_scrollBar.x = _container.contentWidth - _scrollBar.width;
			_scrollBar.y = _container.y;
			_scrollBar.height = _container.contentHeight;
			_scrollBar.view = _container;
			
			_padding = new Margin(0, 0, 0, 0);
			_node = new Vector.<TreeNode>();
			
			addChild(_container);
			addChild(_scrollBar);
		}
		
		public function add(child: TreeNode): void
		{
			if(_node.indexOf(child) == -1)
			{
				child.rootNode = this;
				
				_node.push(child);
				_container.add(child);
				update();
			}
		}
		
		public function remove(child: TreeNode): void
		{
			var index: int = _node.indexOf(child);
			if(index != -1)
			{
				_node.splice(index, 1);
				_container.remove(child);
				update();
			}
		}
		
		override public function set width(value:Number):void
		{
			_container.contentWidth = value;
			_scrollBar.x = _container.contentWidth - _scrollBar.width;
			_scrollBar.y = _container.y;
			update();
		}
		
		override public function set height(value:Number):void
		{
			_scrollBar.height = value;
			_container.contentHeight = value;
			_scrollBar.height = _container.contentHeight;
			update();
		}
		
		override public function get width():Number
		{
			return _container.contentWidth;
		}
		
		override public function get height():Number
		{
			return _container.contentHeight;
		}
		
		public function get innerWidth(): Number
		{
			return _container.contentWidth - _padding.left - _padding.right;
		}
		
		public function get innerHeight(): Number
		{
			return _container.contentHeight - _padding.top - _padding.bottom;
		}

		public function get padding():Margin
		{
			return _padding;
		}

		public function set padding(value:Margin):void
		{
			_padding = value;
			update();
		}

		public function get node():Vector.<TreeNode>
		{
			return _node;
		}

		public function update(): void
		{
			var _child: TreeNode;
			for each(_child in _node)
			{
				_child.update();
			}
			
			_container.layout.update();
			_scrollBar.rebuild();
		}
	}
}