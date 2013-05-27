package com.xgame.common.behavior
{
	public class MainPlayerBehavior extends Behavior
	{
		protected var _currentStep: uint;
		protected var _path: Array;
		
		public function MainPlayerBehavior()
		{
			super();
			
			_currentStep = 1;
			installListener();
		}
		
		override public function installListener():void
		{
			
		}
		
		override public function uninstallListener():void
		{
			
		}
		
		public function clearPath(): void
		{
			
		}
	}
}