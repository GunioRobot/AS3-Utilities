package{
	import flash.geom.Point;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;

	public class Bubbles extends MovieClip{

		public var momentum:Number = 0;
		public var prev_x:Number;
		public var prev_y:Number;

		public var layers:Array = [];
		public const MAX_RAD:Number = 10;
		public const MIN_RAD:Number = 5;
		public const BUBBLE_LIFE:Number = 1500; // ms
		public const NUM_LAYERS:Number = 5;
		public const LAYER_COLORS:Array = [0x515764,0x70788A,0x858EA4,0x8F99B1,0xC3D0F0];

		public const MIN_DIST:Number = 30;
		public const FORCE_FACTOR:Number = .5;

		public var bubble_graphics:Array = [];
		public var bubbles:Array = [];

		public function Bubbles():void{
			for(var i:Number = 0; i < this.NUM_LAYERS; i++){
				this.layers.push(this..addChild(new Sprite()));
			}
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE, this.make_bubbles);
			this.addEventListener(Event.ENTER_FRAME, this.animate_bubbles);
//			this.stage.addEventListener(MouseEvent.CLICK, this.click);
			this.addChild(this.make_circle(50,0xFFFFFF));
			this.prev_x = this.mouseX;
			this.prev_y = this.mouseY;
		}

		public function animate_bubbles(e:Event):void{
			var t:Number = getTimer();
			var scale:Number;
			var sprites:Array;
			for(var i:Number = 0; i < this.bubbles.length; i++){
				scale = (this.BUBBLE_LIFE - (t - this.bubbles[i])) / this.BUBBLE_LIFE;
				this.apply_bubble_forces(i);
				if(scale < .03){
					this.bubbles.shift();
					sprites = this.bubble_graphics.shift();
					for(var j:Number = 0; j < sprites.length; j++){
						this.layers[j].removeChild(sprites[j]);
					}
				}
				this.set_bubble_scale(i,scale);
			}
		}

		public function make_bubbles(e:MouseEvent=null):void{
			var dist:Number = Point.distance(
				new Point(e.stageX,e.stageY),
				new Point(this.prev_x,this.prev_y)
			);
			this.make_bubble(e.stageX,e.stageY,Math.pow(dist,1.1));
			this.prev_x = this.mouseX;
			this.prev_y = this.mouseY;
		}

		// returns an index, i.e. this.bubbles[index] is a reference to the bubble
		public function make_bubble(x:Number, y:Number, size:Number):Number{
			// create bubble layers
			var id:Number = this.bubble_graphics.push([]) - 1;
			var c:Sprite; var max_height:Number;
			for(var i:Number = 0; i < this.NUM_LAYERS; i++){
				c = this.make_circle(
					this.MIN_RAD + ((this.NUM_LAYERS-i)/this.NUM_LAYERS)*(this.MAX_RAD - this.MIN_RAD),
					this.LAYER_COLORS[i]
				);
				if(i == 0){
					max_height = c.height;
				}
				c.x = x;
				c.y = y;
				c.scaleX = c.scaleY = size / max_height;
				this.layers[i].addChild(c);
				this.bubble_graphics[id].push(c);
			}
			return this.bubbles.push(getTimer());
		}

		public function make_circle(radius:Number, color:Number):Sprite{
			var c:Sprite = new Sprite();
			with(c.graphics){
				beginFill(color);
				drawCircle(0,0,radius);
				endFill();
			}
			return c;
		}

		public function set_bubble_scale(id:Number, scale:Number):void{
			scale = Math.min(1,Math.max(0, scale));
			for(var i:Number = 0; i < this.bubble_graphics[id].length; i++){
				this.bubble_graphics[id][i].scaleX = this.bubble_graphics[id][i].scaleY = scale;
			}
		}

		public function set_bubble_position(id:Number, x:Number, y:Number):void{
			for(var i:Number = 0; i < this.NUM_LAYERS; i++){
				this.bubble_graphics[id][i].x = x;
				this.bubble_graphics[id][i].y = y;
			}
		}

		public function apply_bubble_forces(id:Number):void{
			var bx:Number = this.bubble_graphics[id][0].x;
			var by:Number = this.bubble_graphics[id][0].y;
			var dist:Number; var xd:Number; var yd:Number;
			var bdx:Number = 0;
			var bdy:Number = 0;
			this.bubble_graphics.forEach(
				function(item:Array, index:Number, array:Array):void{
					xd = item[0].x - bx;
					yd = item[0].y = by;
					dist = Math.sqrt(Math.pow(xd,2) + Math.pow(yd,2));
					if(dist < this.MIN_DIST){
						trace('dist');
						bdx += (xd / this.MIN_DIST) * this.FORCE_FACTOR;
						bdy += (yd / this.MIN_DIST) * this.FORCE_FACTOR;
					}
				}
			);
//trace('bdx, bdy: ', bdx, ' ', bdy);
			this.set_bubble_position(id, bx + bdx, by + bdy);
		}
	}
}