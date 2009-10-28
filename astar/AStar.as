package astar{
	import flash.events.Event;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import AStarNode;

	public class AStar extends MovieClip{

		[SWF(width='1000', height='600', framerate='30')]

		public var nodes:Array; // 1d array of nodes
		public var node_grid:Array; // 2d array of nodes
		public const node_size:Number = 20;

		private	var cols:Number;
		private var rows:Number;

		private var open:Array;
		private var closed:Array;
		private var neighbors:Array;
		private var neighbor:AStarNode;
		private var choice:AStarNode;
		private var origin:AStarNode;
		private var dest:AStarNode;

		public function AStar():void{
			this.generate_map();
			this.addEventListener(MouseEvent.CLICK, take_a_walk);
		}

		private function take_a_walk(e:Event):void{
			var orig_point:Point = new Point(int(Math.random()*this.cols),int(Math.random()*this.rows));
			var dest_point:Point = new Point(int(Math.random()*this.cols),int(Math.random()*this.rows));
			this.dest = this.node_grid[dest_point.x][dest_point.y];
			this.origin = this.node_grid[orig_point.x][orig_point.y];
			dest.state = AStarNode.DEST;
			origin.state = AStarNode.ORIGIN;
			this.find_path(origin,dest);
		}


		private function generate_map():void{
			this.cols = Math.floor(this.stage.stageWidth / this.node_size)
			this.rows = Math.floor(this.stage.stageHeight / this.node_size);


			// generate an empty map
			this.nodes = []; this.node_grid = []; var node:AStarNode;
			for(var x:Number = 0; x < this.cols; x++){
				this.node_grid[x] = [];
				for(var y:Number = 0; y < this.rows; y++){
					node = new AStarNode({size:this.node_size});
					node.cell_x = x;
					node.cell_y = y;
					node.x = x*this.node_size;
					node.y = y*this.node_size;
					this.node_grid[x].push(node);
					this.nodes.push(node);
					this.addChild(node);
				}
			}

			// generate some obstacles
			var num_obstacles:Number = int(Math.random()*10+10)
			var min_nodes_per:Number = 10;
			var max_nodes_per:Number = 20;
			for(var i:Number = 0; i < -1/* num_obstacles*/; i++){
				x = int(Math.random()*this.cols);
				y = int(Math.random()*this.rows);
				var num_obs:Number = int(Math.random()*((max_nodes_per - min_nodes_per) + min_nodes_per));
				for(var j:Number = 0; j < num_obs; j++){
					try{
						this.node_grid[x][y+j].state = AStarNode.CLOSED;
					} catch (e:Error){}
				}
			}
		}

		private function manhattan_dist(p0:Point, p1:Point):Number{
			return Math.abs(p0.x-p1.x) + Math.abs(p0.y - p1.y);
		}

		private function find_path(origin:AStarNode, dest:AStarNode):void{
			this.open = [origin];
			this.closed = [];
			this.addEventListener(Event.ENTER_FRAME, find_path_frame);
		}

		private function find_path_frame(e:Event):void{
			if(this.open.length == 0) this.finished_finding();

			// pick the lowest cost node on the open list
			this.choice = this.open[0];
			trace('picking next node from open list to try');
			for(var i:Number = 1; i < this.open.length; i++){
				trace(open[i].cost_plus_guess);
				this.choice = choice.cost_plus_guess > open[i].cost_plus_guess ? open[i] : choice;
				this.choice.state = AStarNode.PATH;
			}

			if(this.choice == this.dest) this.finished_finding();

			for(i = 0; i < this.open.length; i++){
				if(this.open[i] == this.choice){
					this.open = this.open.slice(0,i).concat(this.open.slice(i+1));
					break;
				}
			}
			this.choice.state = AStarNode.CLOSED_LIST;
			this.closed.push(this.choice);
			this.neighbors = this.get_neighbors(this.choice);

			for(i = 0; i < this.neighbors.length; i++){
				this.neighbor = neighbors[i];

				if(this.closed.indexOf(this.neighbor) >= 0) continue;

				if(this.open.indexOf(this.neighbor) != -1){ // known noders
					if(this.choice.cost_from_origin + this.choice.cost_to_neighbor(this.neighbor) < this.neighbor.cost_from_origin){
						this.neighbor.parent_node = this.choice;
					}
				} else { // unseen noders
					this.neighbor.parent_node = this.choice;
					this.neighbor.guess_to_dest = this.manhattan_dist(new Point(this.neighbor.cell_x,this.neighbor.cell_y), new Point(this.dest.cell_x, this.dest.cell_y))*10;
					this.neighbor.state = AStarNode.OPEN_LIST;
					this.open.push(this.neighbor);
				}
			}
		}

		public function finished_finding():void{
			this.removeEventListener(Event.ENTER_FRAME, find_path_frame);
			for(var node:AStarNode = this.dest; node != null && !node.in_state(AStarNode.ORIGIN); node = node._parent){
				try{node.state = AStarNode.PATH;}catch(e:Error){}
			}
		}

		private function get_neighbors(n:AStarNode, options:Object=null):Array{
			options = Utils.defaults(options, {
				are_walkable: true
			});
			var neighbors:Array = []; var neighbor:AStarNode;
			for(var x:Number = -1; x < 2; x++){
				for(var y:Number = -1; y < 2; y++){
					try{
						neighbor = this.node_grid[n.cell_x + x][n.cell_y + y];
						if(options.are_walkable && neighbor.walkable && neighbor != n){
							neighbors.push(neighbor);
						}
					} catch(e:Error){}
				}
			}
			return neighbors;
		}
	}
}