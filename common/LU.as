package common{

	// Language Utilities
	public class LU{

                /* for each property of obj2 undefined in obj1, copy the key/value pair to obj1 (recursively) */
                public static function defaults(obj1:Object, obj2:Object):Object{
                        if(obj1 === null){ return obj2; }
			if(obj2 === null){ return obj1; }

                        for(var key:String in obj2){
				if(obj1[key] is Object){
					obj1[key] = Utils.defaults(obj1[key],obj2[key]);
				} else if(obj1[key] === undefined){
                                        obj1[key] = obj2[key];
                                }
                        }
                        return obj1;
                }

		public static function trace(... args):void{
			var str:String = '';
			for(var i:Number = 0; i < args.length; i++){
				str += Utils.to_str(args[i]);
			}
		}

		public static function arr_to_str(a:Array, options:Object=null):String{
			options = Utils.defaults(options,{
				sep : ', '
			});
			var str:String = "[";
			for(var i:Number = 0; i < a.length; i++){
				str += Utils.to_str(a[i]) + options.sep;
			}
			str += ']';
			return str;
		}

		public static function to_str(x:*):String{
			if(x is Object){
				return Utils.obj_to_str(x);
			} else if(x is Array){
				return Utils.arr_to_str(x);
			} else if(x is String){
				return x;
			} else {
				try{
					return x.toString();
				} catch (e:Error){
					return 'cannot convert object to string';
				}
			}
			return 'o noes bad nues'; // shouldn't ever get here
		}

		public static function obj_to_str(o:Object, options:Object=null):String{
			if(o == null){ return ''; }
			options = Utils.defaults(options, {
				key_val_sep : ' : ',
				entry_sep : '\n'
			});
			var str:String = '';
			for(var x:String in o){
				str += x + options.key_val_sep + o[x] + options.entry_sep;
			}
			return str;
		}
	}
}