package common{

	// Language Utilities
	public class LU{
		/*
		* copy properties of obj2 into obj1 for all properties of obj2 not existing in obj1
		*/
		public static function defaults(obj1:Object, obj2:Object):Object{
			if(obj1 === null){ return obj2; }

			for(var key:String in obj2){
				if(obj1[key] === undefined){
					obj1[key] = obj2[key];
				}
			}
			return obj1;
		}

		public static function defaulted(current_value:*, default_value:*):*{
		    return (current_value === undefined || current_value === null) ? default_value : current_value;
		}

		public static function trace_obj(o:Object, name:String="Object"):void{
			trace("--- tracing " + name + " properties ---");
			trace(LU.obj_to_string(o));
			trace("---------------------------------------");
		}

		public static function obj_to_string(o:Object):String{
			var str:String = ""
			if(o === null){
				return "Object is null";
			}

			for(var x:* in o){
				str += x + " : " + o[x] + "\n";
			}
			return str;
		}

		public static function deep_trace( obj : *, level : int = 0 ) : void{
			var tabs : String = "";
			for ( var i : int = 0 ; i < level ; i++, tabs += "\t" );
			
			for ( var prop : String in obj ){
				trace( tabs + "[" + prop + "] -> " + obj[ prop ] );
				deep_trace( obj[ prop ], level + 1 );
			}
		}
		
	}
}