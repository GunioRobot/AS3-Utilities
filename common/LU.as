package common{

	import flash.utils.*;
	import flash.sampler.*;

	// Language Utilities
	public class LU{

                /* copy all properties of 'passed' into a copy of 'defaults' */
		/* treats properties that are objects recursively */
		/* returns a new object, leaving both arguments unmodified */
                public static function defaults(defaults:Object, passed:Object):Object{
			defaults = (defaults === null)
				? {}
				: LU.copy(defaults);

			if(passed === null) return defaults;

                        for(var key:String in passed){
				if(getQualifiedClassName(passed[key]) == getQualifiedClassName({})){
					defaults[key] = LU.defaults(defaults[key], passed[key]);
				} else{
                                        defaults[key] = passed[key];
                                }
                        }
			return defaults;
                }

		/* return a recursive copy of an object */
		public static function copy(o:Object):Object{
			var nu:Object = {}
			for(var x:String in o){
				if(getQualifiedClassName(o[x]) == getQualifiedClassName(nu)) nu[x] = LU.copy(o[x]);
				else nu[x] = o[x];
			}
			return nu;
		}

		public static function print(... args):void{
			var str:String = '';
			for(var i:Number = 0; i < args.length; i++){
				str += LU.to_str(args[i]);
			}
			trace(str);
		}

		public static function arr_to_str(a:Array, options:Object=null):String{
			options = LU.defaults(options,{
				sep : ', '
			});
			var str:String = "[";
			for(var i:Number = 0; i < a.length; i++){
				str += LU.to_str(a[i]) + options.sep;
			}
			str += ']';
			return str;
		}

		public static function to_str(x:*, options:Object=null):String{
//			trace('converting', getQualifiedClassName(x), 'to str');
			switch(true){
				case x is Array:
//					trace('\tarray')
					return LU.arr_to_str(x, options);
				case x is String:
//					trace('\tstring');
					return x;
				case x is Number:
//					trace('\tnumber');
					return x.toString();
				case x is StackFrame:
//					trace('\tstackframe');
					return x.name;
				case x is Object:
//					trace('\tobject');
					return LU.obj_to_str(x, options);
				case x == null:
					return 'null'
				default:
					return getQualifiedClassName(x) + ' is an unhandled type';
			}
			return 'o noes bad nues'; // shouldn't ever get here
		}

		public static function obj_to_str(o:Object, options:Object=null):String{
			if(o == null){ return 'null'; }
			options = LU.defaults(options, {
				'tabs' : -1,
				'key_val_sep' : ' : ',
				'entry_sep' : '\n'
			});
			trace('entry sep: ', options.entry_sep);
			options.tabs++;
			var tabs:String = ''; for(var i:Number = 0; i < options.tabs; i++){ tabs += '\t'; }
			var str:String = '';
			for(var x:String in o){
				str += x + options.key_val_sep + LU.to_str(o[x],options) + options.entry_sep;
			}
			return str;
		}
	}
}