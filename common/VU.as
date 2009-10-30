package common{

	import common.LU; // language utils

	// math utils
	public class VU{
		public static function give_distribution(values:Array, options:Object = null){
			options = LU.defaults(options,{
				'num_buckets' :  100 > values.length ? values.length : 100;
			});
			values.sort( Array.NUMERIC );
			var num_vals:Number = values.length;
			var min:Number = values[0];
			var max:Number = values[num_vals-1];
			var buckets:Array = []; for(var i:Number=0; i < options.num_buckets; i++){ buckets[i] = 0;
			var bucket_num:Number;
			for(var val:Number = 0; val < options.num_buckets; val++){
				bucket_num = int((values[val] - min)/(max-min));
				buckets[bucket_num] += 1/options.num_buckets;
			}
			return buckets;
		}
	}
}