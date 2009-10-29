package astar{
	import common.Utils;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.text.TextField;

	public class AStarNode extends Sprite{

		public var size:Number;
		public var cost_from_origin:Number = 0;
		public var guess_to_dest:Number = 0;
		public var cell_x:Number;
		public var cell_y:Number;
		public var _parent:AStarNode;

		private var _is_dest:Boolean;
		private var _is_origin:Boolean;
		private var _walkable:Boolean;
		private var _state:String;

		// display states
		public static const DEST:String = "Destination";
		public static const ORIGIN:String = "Origin";
		public static const OPEN:String = "Open";
		public static const CLOSED:String = "Closed";
		public static const PATH:String = "Path";
		public static const OPEN_LIST:String = "Open_list";
		public static const CLOSED_LIST:String = "Closed_list";

		private static const states:Object = {
			"Destination":{
				color: 0x336699,
				alpha: .8
			},
			"Origin":{
				color: 0xFFFFFF,
				alpha: .7
			},
			"Open_list":{
				color: 0x22FF00,
				alpha: .1
			},
			"Closed_list":{
				color: 0x555555,
				alpha: .8
			},
			"Path":{
				color: 0x6699CC,
				alpha: .6
			},
			"Open":{
				color: 0x594234,
				alpha: 1
			},
			"Closed":{
				color: 0x332211,
				alpha: 1
			}
		}

		public function AStarNode(options:Object=null){
			options = Utils.defaults(options,{
				state : AStarNode.OPEN,
				size: 10
			});
			this.size = options.size;
			this.state = options.state;
		}

		public function draw(options:Object=null):void{
		    	options = Utils.defaults(options, AStarNode.states[this._state]);
			this.graphics.clear();
//			this.graphics.beginFill(options.color, options.alpha);
			this.graphics.beginFill(options.color, 1);
			this.graphics.drawRect(0,0,this.size,this.size);
			this.graphics.endFill();
			if(this.parent_node != null){
				this.graphics.beginFill(0xFFFFFF,.5);
				this.graphics.drawCircle(this.size/2,this.size/2,2);
				this.graphics.endFill();
				this.graphics.lineStyle(.3, 0xFFFFFF, .5);
				this.graphics.moveTo(this.size/2, this.size/2);
				var x:Number = this.cell_x <= this.parent_node.cell_x
					? (this.cell_x < this.parent_node.cell_x
						? 0
						: this.size/2)
					: this.size;
				var y:Number = this.cell_y <= this.parent_node.cell_y
					? (this.cell_y < this.parent_node.cell_y
						? 0
						: this.size/2)
					: this.size;
				this.graphics.lineTo(x,y);
			}
		}

		public function get walkable():Boolean{
			return this._state != AStarNode.CLOSED;
		}

		public function get cost_plus_guess():Number{
			return this.cost_from_origin + guess_to_dest;
		}

		public function get parent_node():AStarNode{
			return this._parent;
		}

		public function set parent_node(n:AStarNode):void{
			this._parent = n;
			this.cost_from_origin = n.cost_from_origin + this.cost_to_neighbor(n);
		}

		// assumes n is a coterminal neighbor
		public function diagonal_to(n:AStarNode):Boolean{
			return n.cell_x != this.cell_x && n.cell_y != this.cell_y;
		}

		public function cost_to_neighbor(n:AStarNode):Number{
			return this.diagonal_to(n) ? 14 : 10;
		}

		public function set state(state:String):void{
			this._state = state;
			this.draw();
		}

		public function get state():String{
			return this._state;
		}

		public function in_state(state:String):Boolean{
			return this._state == state;
		}
	}
}