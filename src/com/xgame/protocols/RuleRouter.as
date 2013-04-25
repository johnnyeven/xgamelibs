package com.xgame.protocols
{
	import flash.errors.IllegalOperationError;

	public class RuleRouter extends Object
	{
		private var _ruleList: Array;
		private static var _instance: RuleRouter;
		private static var _allowInstance: Boolean = false;
		
		public function RuleRouter()
		{
			super();
			if(!_allowInstance)
			{
				throw new IllegalOperationError("不能直接实例化");
			}
			_ruleList = new Array();
		}
		
		public static function get instance(): RuleRouter
		{
			if(_instance == null)
			{
				_allowInstance = true;
				_instance = new RuleRouter();
				_allowInstance = false;
			}
			return _instance;
		}
		
		public function add(rule: Rule): void
		{
			if(_ruleList.indexOf(rule) > -1)
			{
				return;
			}
			_ruleList.push(rule);
			rule.hook();
		}
		
		public function remove(rule: Rule): void
		{
			var _index: int = _ruleList.indexOf(rule);
			if(_index > -1)
			{
				_ruleList.splice(_index, 1);
				rule.unhook();
				rule = null;
			}
		}
		
		public function refresh(): void
		{
			var _rule: Rule;
			for each(_rule in _ruleList)
			{
				_rule.unhook();
				_rule.hook();
			}
		}
	}
}