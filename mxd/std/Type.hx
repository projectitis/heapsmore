package mxd.std;

class Type extends std.Type{

	/**
	 * Check if the specified field or fields exists in the object. Any fields added at runtime are not detected.
	 * @param o         The object to check
	 * @param field     The field as a string, or
	 * @param fields	The fields as an array of string
	 * @return Bool     True if the field exists, otherwise false
	 */
	public static function hasInstanceField( o:Dynamic, ?field : String, ?fields : Array<String> ) : Bool{
		if ((field==null) && (fields==null)) return false;
		if (fields==null) fields = [field];
		var instanceFields = std.Type.getInstanceFields(std.Type.getClass(o));
		var i = -1;
		for (f in instanceFields){
			fields.remove(f);
			if (fields.length==0) return true;
		}
		return false;
	}

}