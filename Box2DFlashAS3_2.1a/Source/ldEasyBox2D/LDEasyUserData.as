/**
 * Change log
 * 
 * 2013-02-03	v1 
 * 		初版发行
 */

package ldEasyBox2D
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;

	import ldEasyBox2D.LDEasyBox2D;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	
	public dynamic class LDEasyUserData
	{
		public var body:b2Body;
		
		private var _fillColor:uint;
		private var _fillAlpha:Number;
		private var _borderThinkness:Number;
		private var _borderColor:uint;
		
		private var _shape:*;
		private var _graphicType:String;
		private var _graphic:Sprite;
		
		public function LDEasyUserData()
		{
			
		}
		public function createGraphic():void
		{
			if(_graphicType!="auto") return;
			_graphic=new Sprite();
			var g:Graphics=_graphic.graphics;
			_shape=body.GetFixtureList().GetShape();
			if(_shape==null) return;

			switch(_shape.GetType())
			{
				case 0:
				{
					g.lineStyle(_borderThinkness,_borderColor);
					g.beginFill(_fillColor,_fillAlpha);
					g.drawCircle(0,0,_shape.GetRadius()*LDEasyBox2D.pixelPerMeter);
					g.endFill();
					break;
				}
				case 1:
				{
					g.lineStyle(_borderThinkness,_borderColor);
					g.beginFill(_fillColor,_fillAlpha);
					
					var vertix : b2Vec2 = _shape.GetVertices()[0];
					g.moveTo(vertix.x*LDEasyBox2D.pixelPerMeter ,vertix.y* LDEasyBox2D.pixelPerMeter);
					for(var i:int=1; i<_shape.GetVertexCount(); i++){
						vertix=_shape.GetVertices()[i];
						g.lineTo(vertix.x*LDEasyBox2D.pixelPerMeter,vertix.y*LDEasyBox2D.pixelPerMeter);
					}
					g.endFill();
					break;
				}
			}
		}
		public function get graphic():Sprite
		{
			if(_graphicType == ""){
				return null;
			}else{
				return _graphic;
			}
		}
		public function setGraphicAuotmatically(fillColor:uint=0x0000FF,fillAlpha:Number=0.5,borderThinkness:Number=1,borderColor:uint=0):void
		{
			_fillColor=fillColor;
			_fillAlpha=fillAlpha;
			_borderColor=borderColor;
			_borderThinkness=borderThinkness;
			_graphicType="auto";
		}
		public function setGraphic(sprite:Sprite):void
		{
			_graphicType="customer";
			_graphic=sprite;
		}
		public function clone():LDEasyUserData
		{
			var ldEUD:LDEasyUserData=new LDEasyUserData();
			if(_graphicType=="auto"){
				ldEUD.setGraphicAuotmatically(_fillColor,_fillAlpha,_borderThinkness,_borderColor);
			}else{
				//ldEUD.setGraphic(_graphic);
			}
			return ldEUD;
		}
			
	}
}