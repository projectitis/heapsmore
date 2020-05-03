package m2d.ui;

import hxd.Math;

/**
 * The units supported by Dimension
 */
enum Unit{
	Pixels;
	ParentWidth;
	ParentHeight;
	ParentMin;
	ParentMax;
	ViewportWidth;
	ViewportHeight;
	ViewportMin;
	ViewportMax;
}

/**
 * An object to decribe an absolute or relative Dimension.
 */
class Dimension{
	/**
	 * Check if this dimension has a value set
	 */
	public var undefined(default,null) : Bool = true;

	var value : Float = 0;
	var unit : Unit = Pixels;
	var min : Dimension = null;
	var max : Dimension = null;

	/**
	 * Callback when dimension changes
	 */
	public var onChange : Void -> Void = null;

	/**
	 * Create a new Dimension
	 * @param v 		The initial value in pixels, or
	 * @param s 		A string with initial value and units. See `setValue` for supported units.
	 */
	public function new( ?v : Float, ?s : String ){
		this.set( v, s );
	}

	/**
	 * Used to set the dimension as undefined (unused). Setting any value will make it no longer undefined.
	 */
	public function unset(){
		unit = Pixels;
		value = 0;
		undefined = true;
		min = null;
		max = null;
		changed();
	}

	/**
	 * Set the value from a float (always a pixel value), or from a string (can be % or other supported unit)
	 * @param v 	The value in pixels, or
	 * @param s 	A string with value and units. If no units, px is assumed. Supported:
	 * 					px (pixels), 
	 * 					% (same as pw),
	 * 					pw (parent width),
	 * 					ph (parent height),
	 * 					p- (parent smalest dim),
	 * 					p+ (parent largest dim),
	 * 					vw (viewport/stage width),
	 * 					vh (viewport/stage height),
	 * 					v- (viewport/stage smallest dim),
	 * 					v+ (viewport/stage largest dim)
	 */
	public function set( ?v : Float, ?s : String ){
		if (v != null){
			unit = Pixels;
			value = v;
			undefined = false;
		}
		else if (s != null){
			s = StringTools.trim(s.toLowerCase());
			// Pixel value
			if (s.substr(-2)=='px'){
				unit = Pixels;
				value = Std.parseFloat(s.substr(0,s.length-2));
			}
			// Relative to parent width
			else if (s.substr(-1)=='%'){
				unit = ParentWidth;	
				value = Std.parseFloat(s.substr(0,s.length-1));
			}
			else if (s.substr(-2)=='pw'){
				unit = ParentWidth;
				value = Std.parseFloat(s.substr(0,s.length-2));
			}
			// Relative to parent height
			else if (s.substr(-2)=='ph'){
				unit = ParentHeight;
				value = Std.parseFloat(s.substr(0,s.length-2));
			}
			// Relative to parent minimum dimension
			else if (s.substr(-2)=='p-'){
				unit = ParentMin;
				value = Std.parseFloat(s.substr(0,s.length-2));
			}
			// Relative to parent maximum dimension
			else if (s.substr(-2)=='p+'){
				unit = ParentMax;
				value = Std.parseFloat(s.substr(0,s.length-2));
			}
			else if (s.substr(-2)=='vw'){
				unit = ViewportWidth;
				value = Std.parseFloat(s.substr(0,s.length-2));
			}
			// Relative to parent height
			else if (s.substr(-2)=='vh'){
				unit = ViewportHeight;
				value = Std.parseFloat(s.substr(0,s.length-2));
			}
			// Relative to parent minimum dimension
			else if (s.substr(-2)=='v-'){
				unit = ViewportMin;
				value = Std.parseFloat(s.substr(0,s.length-2));
			}
			// Relative to parent maximum dimension
			else if (s.substr(-2)=='v+'){
				unit = ViewportMax;
				value = Std.parseFloat(s.substr(0,s.length-2));
			}
			// Default is to just try to parse to float: 230, 56.25
			else{
				unit = Pixels;
				value = Std.parseFloat(s);
			}
			undefined = false;
		}
		else{
			unit = Pixels;
			value = 0;
			undefined = true;
			unsetMin();
			unsetMax();
		}
		changed();
	}

	/**
	 * Calculate and return the value based
	 * @param pw 	The parent width
	 * @param ph 	The parent height
	 * @param vw 	The viewport width
	 * @param vh 	The viewport height
	 */
	public function get( pw : Float, ph : Float, vw : Float, vh : Float ) : Float{
		var v : Float;
		switch (unit){
			case Pixels: v = this.value;
			case ParentWidth: v = pw * value * 0.01;
			case ParentHeight: v = ph * value * 0.01;
			case ParentMin: v = Math.min(pw,ph) * value * 0.01;
			case ParentMax: v = Math.max(pw,ph) * value * 0.01;
			case ViewportWidth: v = vw * value * 0.01;
			case ViewportHeight: v = vh * value * 0.01;
			case ViewportMin: v = Math.min(vw,vh) * value * 0.01;
			case ViewportMax: v = Math.max(vw,vh) * value * 0.01;
		}
		if (min!=null) v = Math.max(min.get(pw,ph,vw,vh),v);
		if (max!=null) v = Math.min(max.get(pw,ph,vw,vh),v);
		return v;
	}

	/**
	 * Set the minimum value. This is also a Dimension with it's own unit
	 * @param v 	The pixel value, or
	 * @param s 	A value with a different unit
	 */
	public function setMin( ?v : Float, ?s : String ){
		if ((v==null) && (s==null)) min = null;
		else if (min==null) min = new Dimension(v,s);
		else min.set( v, s );
		changed();
	}

	/**
	 * Remove the minimum value
	 */
	public function unsetMin(){
		min = null;
		changed();
	}

	/**
	 * Calculate and return the minimum value
	 * @param pw 	The parent width
	 * @param ph 	The parent height
	 * @param vw 	The viewport width
	 * @param vh 	The viewport height
	 */
	public function getMin( pw : Float, ph : Float, vw : Float, vh : Float ) : Float{
		if (min==null) return 0;
		return min.get(pw,ph,vw,vh);
	}

	/**
	 * Check if the dimension has a minimum value set
	 * @return Bool		True if a minimum value is set, otherwise false
	 */
	public function hasMin() : Bool{
		return (min!=null);
	}

	/**
	 * Set the maximum value. This is also a Dimension with it's own unit
	 * @param v 	The pixel value, or
	 * @param s 	A value with a different unit
	 */
	 public function setMax( ?v : Float, ?s : String ){
		if ((v==null) && (s==null)) max = null;
		else if (max==null) max = new Dimension(v,s);
		else max.set( v, s );
		changed();
	}

	/**
	 * Remove the maximum value
	 */
	 public function unsetMax(){
		max = null;
		changed();
	}

	/**
	 * Calculate and return the maximum value
	 * @param pw 	The parent width
	 * @param ph 	The parent height
	 * @param vw 	The viewport width
	 * @param vh 	The viewport height
	 */
	public function getMax( pw : Float, ph : Float, vw : Float, vh : Float ) : Float{
		if (max==null) return 0;
		return max.get(pw,ph,vw,vh);
	}

	/**
	 * Check if the dimension has a maximum value set
	 * @return Bool		True if a maximum value is set, otherwise false
	 */
	public function hasMax() : Bool{
		return (max!=null);
	}

	/**
	 * Called internall to fire callback when something changes
	 */
	function changed(){
		if (onChange!=null){
			// This dickery prevents the callback being called recursively (e.g. if
			// the callback makes a change to this dimension again).
			var callback : Void -> Void = onChange;
			onChange = null;
			callback();
			onChange = callback;
		}
	}

	/**
	 * Trace this object
	 * @param name 	A name to identify this object in the trace
	 */
	public function trace( name : String = 'Dimension' ){
		trace('$name: $value $unit');
	}

}

