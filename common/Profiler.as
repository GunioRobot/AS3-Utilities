package common{

	import flash.sampler.*;
	import common.LU;

	public class Profiler{

		private static var _instance:Profiler;
		private static var _func_info:Object = {} // func_name : {info_obj} pairs
		private static var _first_sample_time:Number = -1;
		private static var _last_sample_time:Number = -1;

		// _func_info[obj] fields
		private static const EXEC_TIME:String = 'exec_time';
		private static const EXEC_PERCENT:String = 'exec_percent'; // EXEC_TIME / (_last_sample_time - _first_sample_time)
		private static const NAME:String = 'name';

		public static function nouveau(options:Object=null):Profiler{
			options = LU.defaults(options, {
				'start_profiling' : true
			});
//			LU.print(options);
			if(_instance == null)
				return new Profiler(options.start_profiling)
			return _instance;
		}

		// use Profiler.nouveau to get a reference to a single global instance
		public function Profiler(start_profiling:Boolean=true):void{
			start_profiling && start();
		}

		public function print():void{
			_profile_functions();
			_print_profile();
		}

		// try assigning getSamples to an array to avoid the second for loop
		private function _profile_functions():void{
 			for each(var s:Sample in getSamples()){
				if(_last_sample_time == -1) _last_sample_time = _first_sample_time = s.time;
				_process_sample(s);
			}

			var profile_duration:Number = _last_sample_time - _first_sample_time;
			trace('profile duration', profile_duration/1000);
			for each(var f:Object in _func_info){
				f[Profiler.EXEC_PERCENT] = f[Profiler.EXEC_TIME] / profile_duration;
			}
		}

		// print the sorted list of functions
		private function _print_profile():void{
			trace("Listing functions, longest to shortest running time");
			var sum:Number = 0;
			for each(var f:Object in _get_functions()){
				sum += f[Profiler.EXEC_PERCENT];
				trace(f[Profiler.EXEC_TIME]/1000, '\t\t',int(f[Profiler.EXEC_PERCENT]*1000),'\t\t', f[NAME]);
			}
			trace('total percent: ', sum);
		}

		// returns an array of the objects in _func_info, sorted in descending order of running time
		private function _get_functions():Array{
			var functions:Array = [];
			for each(var info_obj:Object in _func_info){
				functions.push(info_obj);
			}
			functions.sortOn(Profiler.EXEC_PERCENT, Array.NUMERIC | Array.DESCENDING);
			return functions;
		}

		// update _func_info with data from sample
		private function _process_sample(s:Sample):void{
			var duration:Number = s.time - _last_sample_time;
//			trace('processing samples');
			for each(var sf:StackFrame in s.stack){
//				trace(sf.name);
				_func_info[sf.name] == null
					? _func_info[sf.name] = {'name': sf.name, 'exec_time': duration}
					: _func_info[sf.name][Profiler.EXEC_TIME] += duration;
			}
			_last_sample_time = s.time;
		}

		public function start():void{
			startSampling();
		}

		public function stop():void{
			stopSampling();
		}
	}
}