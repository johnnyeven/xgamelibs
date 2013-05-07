/**
 * CHANGE LOG
 * 2013-02-15 v5.0
 * 	1.增加pixelPerMeter静态属性，便于缩放屏幕时，修改像素和米的转换关系
 * 	2.修改API函数，与LDEasyNape统一
 * 4.0<<
 * 	添加getBodyAtMouse方法
 * 	添加startDragBody方法
 * 	添加stopDragBody方法
 * >>3.0<<
 * 	添加createPolygon方法
 * 	添加updateWorld方法
 * >>2.0<<
 * 	添加createWrapWall方法
 * >>1.0<<
 * 	Box2D 2.0.1实现LDEasyBox2D
 */

package  ldEasyBox2D
{
	import Box2D.Box2DSeparator.b2Separator;
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Joints.b2MouseJoint;
	import Box2D.Dynamics.Joints.b2MouseJointDef;
	import Box2D.Dynamics.Joints.b2RevoluteJointDef;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2FilterData;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	/**
	 * ...
	 * @author ladeng6666
	 */
	public class LDEasyBox2D 
	{
		private static const VER:String = "LDEasyBox2D v5 2013-02-15";
		private static var world:b2World;
		//当使用startDragBody()方法时，自动实例化这个鼠标关节
		private static var mouseJoint:b2MouseJoint;
		//当需要访问舞台的鼠标坐标时，会用到stage属性
		private static var stage:Stage;
		private static var box2DFps:uint;
		//每米转换成多少像素
		public static var pixelPerMeter:Number = 30;
		
		public function LDEasyBox2D() 
		{
			
		}
		public static function initialize(stage:Stage,box2DFps:uint=30,pixelPerMeter:Number=30):void {
			LDEasyBox2D.stage = stage;
			LDEasyBox2D.box2DFps = box2DFps;
			LDEasyBox2D.pixelPerMeter = pixelPerMeter;
		}
		/**
		 * 创建并返回一个重力为10牛的Box2D世界
		 * @return 返回创建好的Box2D世界
		 * @link http://www.ladeng6666.com/blog/index.php/2012/05/31/%e8%ae%a4%e8%af%86box2d%e4%b8%96%e7%95%8c/
		 */
		public static function createWorld(gravityX:Number=0, gravityY:Number=10):b2World {
			//2.声明重力
			var gravity:b2Vec2 = new b2Vec2(gravityX, gravityY);
			//3.睡着的对象是否模拟
			var doSleep:Boolean = true;
			//4.创建b2World世界
			var world:b2World = new b2World(gravity, doSleep);
			LDEasyBox2D.world = world;
			return world;
		}
		/**
		 * 更新Box2D世界。世界里刚体的useData也会同步更新；用startDragBody创建的鼠标关节也会自动更新
		 * @param	world，承载所有刚体的Box2D世界
		 * @link	http://www.ladeng6666.com/blog/index.php/2012/06/05/%e6%8e%89%e8%90%bd%e7%9a%84%e8%8b%b9%e6%9e%9c-b2body%e5%88%9a%e4%bd%93/
		 */
		public static function updateWorld():void {
			world.Step(1 / box2DFps, 10, 10);
			world.ClearForces();
			world.DrawDebugData();
			
			for (var body:b2Body = world.GetBodyList(); body; body=body.GetNext()) {
				if (body.GetUserData() != null) {
					var graphic:DisplayObject = body.GetUserData().graphic;
					//根据刚体的坐标个角度，更新绑定的userData
					graphic.x = body.GetPosition().x * pixelPerMeter;
					graphic.y = body.GetPosition().y * pixelPerMeter;
					graphic.rotation = body.GetAngle() * 180 / Math.PI;
				}
			}
			if (mouseJoint != null) {
				var mouseVector:b2Vec2 = new b2Vec2(stage.mouseX / pixelPerMeter, stage.mouseY / pixelPerMeter);
				mouseJoint.SetTarget(mouseVector);
			}
		}
		/**
		 * 创建Box2D Debug对象，调试Box2D应用
		 * @param	world Box2D的世界
		 * @return Sprite，用来绘制Box2D调试图的sprite对象
		 * @link	http://www.ladeng6666.com/blog/index.php/2012/06/05/%E6%8E%89%E8%90%BD%E7%9A%84%E8%8B%B9%E6%9E%9C-b2body%E5%88%9A%E4%BD%93/
		 */
		public static function createDebug(debugSprite: Sprite):b2DebugDraw 
		{
			var debugDraw:b2DebugDraw = new b2DebugDraw();
			debugDraw.SetSprite(debugSprite);
			debugDraw.SetDrawScale(pixelPerMeter);
			debugDraw.SetFillAlpha(0.5);
			debugDraw.SetLineThickness(1.0);
			debugDraw.SetFlags(b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit);
			
			world.SetDebugDraw(debugDraw);
			return debugDraw;
		}
		/**
		 * 创建并返回一个矩形的b2Body刚体对象
		 * @param	world 承载所有刚体和关节的世界
		 * @param	posX 刚体的x坐标，以像素为单位
		 * @param	posY 刚体的y坐标，以像素为单位
		 * @param	boxWidth 刚体的宽度，以像素为单位
		 * @param	boxHeight 刚体的高度，以像素为单位
		 * @param	isStatic 刚体是否静止不动，默认为false
		 * @param	userData 刚体的外观，默认为null
		 * @return b2Body，创建好的矩形刚体
		 * @link http://www.ladeng6666.com/blog/index.php/2012/06/05/%E6%8E%89%E8%90%BD%E7%9A%84%E8%8B%B9%E6%9E%9C-b2body%E5%88%9A%E4%BD%93/
		 * @link	http://www.ladeng6666.com/blog/index.php/2012/06/10/%e5%88%9a%e4%bd%93%e7%9a%84%e4%b8%8a%e8%a1%a3-b2bodydef-userdata/ 
		 */
		public static function createBox(
				posX:Number, 
				posY:Number, 
				boxWidth:Number, 
				boxHeight:Number, 
				isStatic:Boolean = false,
				isFixed: Boolean = false,
				userData:*= null, 
				isSensor:Boolean = false, 
				filter:b2FilterData = null 
			):b2Body {
			//1.创建刚体需求b2BodyDef
			var bodyRequest:b2BodyDef = new b2BodyDef();
			bodyRequest.type = isStatic? b2Body.b2_staticBody:b2Body.b2_dynamicBody;
			bodyRequest.position.Set(posX / pixelPerMeter, posY / pixelPerMeter);//记得米和像素的转换关系
			//Ladeng6666是Flash元件库中的一个图片
			
			//2.创建形状
			var shapeBox:b2PolygonShape = new b2PolygonShape();
			shapeBox.SetAsBox(boxWidth / pixelPerMeter / 2, boxHeight / pixelPerMeter / 2);
			//2.Box2D世界工厂更具需求创建createBody()生产刚体
			var box:b2Body = world.CreateBody(bodyRequest);
			
			//3.创建敢提形状需求b2ShapeDef的子类
			var fixtureRequest:b2FixtureDef = new b2FixtureDef();
			fixtureRequest.density = 3;
			fixtureRequest.friction = 0.3;
			fixtureRequest.restitution = 0.2;
			fixtureRequest.shape = shapeBox;
			fixtureRequest.isSensor = isSensor;
			if (filter != null) {
				fixtureRequest.filter = filter;
			}
			
			//4.b2Body刚体工厂根据需求createShape生产形状		
			
			box.CreateFixture(fixtureRequest);
			
			if (isFixed) {
				fixBodyAt(box, posX, posY);
			}
			setUserData(box, userData);
			return box;
		}
		
		public static function fixBodyAt(body:b2Body,posX:Number, posY:Number,localX:Number=0,localY:Number=0):void {
			//创建马达关节需求
			var revoluteJointDef:b2RevoluteJointDef = new b2RevoluteJointDef();
			//初始化马达关节，设置节点为刚体的圆心，这只bA为空刚体
			revoluteJointDef.Initialize(world.GetGroundBody(), body, new b2Vec2(posX / pixelPerMeter, posY / pixelPerMeter));
			revoluteJointDef.localAnchorB = new b2Vec2(localX / pixelPerMeter, localY / pixelPerMeter);
			//创建马达关节
			world.CreateJoint(revoluteJointDef);
		}
		
		/**
		 * 创建并返回一个圆形敢提，同样所有涉及到坐标的参数都是以像素为单位
		 * @param	world 承载所有刚体的Box2D世界
		 * @param	posX	刚体的x坐标，以像素为单位
		 * @param	posY	刚体的y坐标，以像素为单位
		 * @param	radius	刚体的半径，以像素为单位
		 * @param	isStatic	刚体是否为静止对象，默认为false
		 * @param	userData	刚体的外观，默认为null
		 * @return 返回一个圆形刚体
		 * @link	http://www.ladeng6666.com/blog/index.php/2012/06/07/%e5%88%9b%e5%bb%ba%e5%9c%86%e5%bd%a2%e5%88%9a%e4%bd%93/
		 * @link	http://www.ladeng6666.com/blog/index.php/2012/06/10/%e5%88%9a%e4%bd%93%e7%9a%84%e4%b8%8a%e8%a1%a3-b2bodydef-userdata/
		 */
		public static function createCircle(
				posX:Number, 
				posY:Number, 
				radius:Number, 
				isStatic:Boolean = false, 
				isFixed : Boolean = false,
				userData:LDEasyUserData= null, 
				isSensor:Boolean = false, 
				filter:b2FilterData = null
			):b2Body {
			//1.创建刚体需求b2BodyDef
			var bodyRequest:b2BodyDef = new b2BodyDef();
			bodyRequest.type = isStatic? b2Body.b2_staticBody:b2Body.b2_dynamicBody;
			bodyRequest.position.Set(posX / pixelPerMeter, posY / pixelPerMeter);//记得米和像素的转换关系
			
			//2.创建形状
			var shapeCircle:b2CircleShape = new b2CircleShape();
			shapeCircle.SetRadius(radius/pixelPerMeter);
			//2.Box2D世界工厂更具需求创建createBody()生产刚体
			var circle:b2Body = world.CreateBody(bodyRequest);
			
			//3.创建敢提形状需求b2ShapeDef的子类
			var fixtureRequest:b2FixtureDef = new b2FixtureDef();
			fixtureRequest.density = 3;
			fixtureRequest.friction = 0.3;
			fixtureRequest.restitution = 0.2;
			fixtureRequest.shape = shapeCircle;
			fixtureRequest.isSensor = isSensor;
			if ( filter != null) {
				fixtureRequest.filter = filter;
			}
			
			//4.b2Body刚体工厂根据需求createShape生产形状			
			circle.CreateFixture(fixtureRequest);
			if ( isFixed) {
				fixBodyAt(circle, posX, posY);
			}
			setUserData(circle, userData);
			return circle;
		}
		public static function createRegular(
						posX:Number, 
						posY:Number, 
						radius:Number, 
						verticesCount:uint = 5, 
						rotation:Number = 0, 
						isStatic:Boolean = false, 
						isFixed : Boolean = false,
						userData:LDEasyUserData=null):b2Body {
			//1.创建刚体需求b2BodyDef
			var bodyRequest:b2BodyDef = new b2BodyDef();
			bodyRequest.type = isStatic? b2Body.b2_staticBody:b2Body.b2_dynamicBody;
			bodyRequest.position.Set(posX/30 , posY/30);//记得米和像素的转换关系
			
			//3.创建敢提形状需求b2ShapeDef的子类	
			
			var angle:Number = Math.PI * 2 / verticesCount;//每个顶点之间的角度间隔
			var vertices:Vector.<b2Vec2> = new Vector.<b2Vec2>();
			var vertix:b2Vec2;
			//移动到第一个顶点
			//vertix = new b2Vec2(radius * Math.cos(rotation), radius * Math.sin(rotation);
			//vertix.Multiply(1 / 30);
			
			for (var i:int=0; i< verticesCount; i++){
				//计算每个顶点
				vertix = new b2Vec2(radius * Math.cos( i * angle + rotation), radius * Math.sin( i * angle + rotation));
				vertix.Multiply(1 / 30);
				vertices.push(vertix);
			}
			var regularShape:b2PolygonShape = new b2PolygonShape();
			regularShape.SetAsVector(vertices, verticesCount);
			
			//创建矩形刚体形状需求
			var fixtureRequest:b2FixtureDef = new b2FixtureDef();
			fixtureRequest.density = 3;
			fixtureRequest.friction = 0.3;
			fixtureRequest.restitution = 0.2;
			fixtureRequest.shape = regularShape;
			
			var regularBody:b2Body = world.CreateBody(bodyRequest);
			regularBody.CreateFixture(fixtureRequest);
			
			if ( isFixed) {
				fixBodyAt(regularBody, posX, posY);
			}
			setUserData(regularBody, userData);
			return regularBody;
		}
		/**
		 * 根据一组顶点数据，创建多边形刚体，可以是顺时针绘制，也可以逆时针绘制，但不能出现交叉
		 * @param	world Box2D世界
		 * @param	vertices 顶点数组，顶点之间不能有交叉
		 * @param	isStatic	是否为静止的刚体
		 * @param	fillData	刚体的填充纹理，一个BitmapData对象，请确保整个BitmapData的尺寸大于舞台的尺寸
		 * @param	stage	添加userData的舞台,若不指定该属性,将无法看到刚体的外观
		 * @return 返回一个多边形刚体
		 * @link	http://www.ladeng6666.com/blog/index.php/2012/08/10/box2d%e5%a4%9a%e8%be%b9%e5%bd%a2%e5%88%9a%e4%bd%93%e8%b4%b4%e5%9b%be/
		 */
		public static function createPolygon(
				vertices:Vector.<b2Vec2>,
				isStatic:Boolean = false, 
				fillData:BitmapData = null,
				stage:DisplayObjectContainer = null
			):b2Body {
			//1.创建刚体需求b2BodyDef
			var bodyRequest:b2BodyDef = new b2BodyDef();
			bodyRequest.type = isStatic? b2Body.b2_staticBody:b2Body.b2_dynamicBody;
			bodyRequest.position.Set(0 , 0);//记得米和像素的转换关系
			
			//3.创建敢提形状需求b2ShapeDef的子类	
				//创建矩形刚体形状需求
			var fixtureRequest:b2FixtureDef = new b2FixtureDef();
			fixtureRequest.density = 3;
			fixtureRequest.friction = 0.3;
			fixtureRequest.restitution = 0.2;
			//创建一个Separator对象
			var separator:b2Separator = new b2Separator();
			//验证顶点是否符合创建多边形的标准
			var validate:int = separator.Validate(vertices);
			//如果是顶点因非顺时针不符标准，则反转数组中的顶点顺序
			if (validate == 2) {
				vertices.reverse();
			}else if (validate != 0) {
				//如果不符合多边形标准，跳出
				return null;
			}
			if (fillData != null && stage!=null) {
				var userData:Sprite = new Sprite();
				var commandVector:Vector.<int> = new Vector.<int>();
				var posVector:Vector.<Number> = new Vector.<Number>();
				
				commandVector.push(1);
				posVector.push(vertices[0].x * pixelPerMeter);
				posVector.push(vertices[0].y * pixelPerMeter);
				for (var i:int = 1; i < vertices.length;i++ ) {
					commandVector.push(2)
					posVector.push(vertices[i].x * pixelPerMeter);
					posVector.push(vertices[i].y * pixelPerMeter);
				}
				userData.graphics.beginBitmapFill(fillData);
				userData.graphics.drawPath(commandVector, posVector);
				userData.graphics.endFill();
				stage.addChild(userData);
				
				bodyRequest.userData = userData;
			}
			//2.Box2D世界工厂更具需求创建createBody()生产刚体
			var body:b2Body=world.CreateBody(bodyRequest);
			//将顶点分解成多个凸多边形，组合成复杂的多边形
			separator.Separate(body, fixtureRequest, vertices);
			
			return body;
		}
		/**
		 * 在Box2D世界中创建围绕canvas四周的静态墙体，
		 * @param	world 承载所有刚体的Box2D世界
		 * @param	canvas	要用静态墙体包围的舞台
		 */
		public static function createWrapWall():void {
			
			var w:Number = stage.stageWidth;
			var h:Number = stage.stageHeight;
			var wallThick:Number = 20;//in pixels
			
			createBox( w / 2, 0, w , wallThick, true);
			createBox( w / 2, h, w , wallThick, true);
			createBox( 0, h / 2, wallThick, h , true);
			createBox( w, h / 2, wallThick, h , true);
		}
		/**
		 * 获取Box2D世界中鼠标下的刚体
		 * @return	返回鼠标位置的刚体
		 * @link	http://www.ladeng6666.com/blog/index.php/2012/08/18/drag-b2body-with-mousejointdef/
		 */
		public static function getBodyAtMouse():b2Body {
			//转换鼠标坐标单位，除以30从m该为px
			var mouseVector:b2Vec2 = new b2Vec2(stage.mouseX / pixelPerMeter, stage.mouseY / pixelPerMeter);
			//鼠标下的刚体
			var bodyAtMouse:b2Body = null;
			//queryPoint函数中要用到的回调函数，注意，它必须有一个b2Fixture参数
			function callBack(fixture:b2Fixture):void {
				if ( fixture == null) return;
				//如果fixture不为null，设置为鼠标下的刚体
				bodyAtMouse = fixture.GetBody();
			}
			//利用QueryPoint方法查找鼠标滑过的刚体
			world.QueryPoint(callBack, mouseVector);
			//返回找到的刚体
			return bodyAtMouse;
		}
		/**
		 * 用鼠标关节拖动刚体
		 * @param	world	承载所有刚体和关节的Box2D世界
		 * @param	body		要拖动的刚体
		 * @param	maxForce	鼠标关节允许的最大作用力，默认为1000
		 * @link	http://www.ladeng6666.com/blog/index.php/2012/08/18/drag-b2body-with-mousejointdef/
		 */
		public static function startDragBody(
				body:b2Body,
				maxForce:Number = 1000
			):void {
			if (body == null) return;//如果鼠标下的刚体不为空
			//创建鼠标关节需求
			var mouseJointDef:b2MouseJointDef = new b2MouseJointDef();
			mouseJointDef.bodyA = world.GetGroundBody();//设置鼠标关节的一个节点为空刚体，GetGroundBody()可以理解为空刚体
			mouseJointDef.bodyB = body//设置鼠标关节的另一个刚体为鼠标点击的刚体
			mouseJointDef.target.Set(stage.mouseX / pixelPerMeter, stage.mouseY / pixelPerMeter);//更新鼠标关节拖动的点
			mouseJointDef.maxForce = maxForce;//设置鼠标可以施加的最大的力
			
			//创建鼠标关节
			mouseJoint=world.CreateJoint(mouseJointDef) as b2MouseJoint;
			
		}
		/**
		 * 停止拖动world中的刚体
		 * @param	world
		 * @link	http://www.ladeng6666.com/blog/index.php/2012/08/18/drag-b2body-with-mousejointdef/
		 */
		public static function stopDragBody():void {
			if (mouseJoint != null) {
				world.DestroyJoint(mouseJoint);
			}
		}
		private static function setUserData(body:b2Body, userData:LDEasyUserData):void {
			if(userData!=null){
				userData.body=body;
				userData.createGraphic();
				body.SetUserData(userData);
				updateWorld();
				stage.addChild(userData.graphic);
			}
		}
		public static function version():void {
			trace(VER);
		}
	}

}