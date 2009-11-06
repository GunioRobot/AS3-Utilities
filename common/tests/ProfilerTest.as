package common.tests{

	import flash.display.*;
	import flash.utils.*;

	import common.LU;
	import common.Profiler;

	public class ProfilerTest extends MovieClip{

		private var sprites:Array = [];
		private const SHORT:Number = 1000;
		private const MED:Number = 10000;
		private const LONG:Number = 10000;

		public function ProfilerTest():void{
			var p:Profiler = Profiler.nouveau();

			test(sprite_test2, {'label':'sp2'});
			test(sprite_test1, {'label':'sp1'});

			p.print_and_stop();
		}

		public function sprite_test1():void{
			for(var i:Number = 0; i < MED; i++)
				sprites.push(new Sprite());
			sprites = [];
		}

		public function sprite_test2():void{
			for(var i:Number = 0; i < MED; i++)
				sprites.push(new Sprite());
			sprites = [];
		}

		public function loop_draw_test():void{
			for each(var s:Sprite in this.sprites){
				with(s.graphics){
					beginFill(0xFFFFFF)
					drawCircle(Math.random()*this.stage.stageWidth,Math.random()*this.stage.stageHeight,100);
					endFill()
				}
			}
		}

		public function test(f:Function, options:Object=null):void{
			options = LU.defaults({
				'label' : f
			}, options);
			var start:Number = getTimer()
			f();
			var end:Number = getTimer()
			trace(options.label,' took ', end - start, ' ms');
		}

	}
}