package com.xgame.protocols
{
	import com.xgame.common.interfaces.protocols.IReceiving;
	import com.xgame.core.center.CommandCenter;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class Rule extends EventDispatcher
	{
		private var _ruleName: String;
		protected var _commandCenter: CommandCenter;
		
		public function Rule(name: String)
		{
			super(this);
			_ruleName = name;
			_commandCenter = CommandCenter.instance;
		}
		
		public function hook(): void
		{
			
		}
		
		public function unhook(): void
		{
			
		}
		
		public function validate(protocol: IReceiving): Boolean
		{
			return false;
		}
	}
}