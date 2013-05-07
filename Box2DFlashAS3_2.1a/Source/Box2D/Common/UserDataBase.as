package Box2D.Common
{
	import flash.display.DisplayObject;

	public class UserDataBase extends Object
	{
		public var name: String;
		public var graphic: DisplayObject;
		
		public function UserDataBase(vars: Object = null)
		{
			super();
			if(vars != null)
			{
				setter(vars);
			}
		}
		
		protected function setter(vars: Object): void
		{
			if(vars.hasOwnProperty("name"))
			{
				name = vars.name;
			}
			if(vars.hasOwnProperty("graphic"))
			{
				graphic = vars.graphic;
			}
		}
	}
}