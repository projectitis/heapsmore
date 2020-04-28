package mxd;

import h2d.Object;
import h2d.Drawable;
import mxd.UIApp;

/**
 * The units supported by Param
 */
enum ParamUnit{
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
 * An object to decribe a 'size' parameter (like width or height). The value can be absolute (i.e. it is a
 * pixel value), or it can be relative to either the parent, or the viewport. The viewport is always
 * `mxd.UIApp.viewport`. Please be aware - if the parent is not set, the viewport is used. 
 */
class Param{
	public var parent : Dynamic = null;

	public var value(get,null) : Float = 0;
	var unit : ParamUnit = Pixels;

	var min : Param = null;
	var max : Param = null;
	public var maxValue(get,set) : Null<Float>;
	public var minValue(get,null) : Null<Float>;

	/**
	 * Constructor
	 * @param parent	The parent 
	 * @param v 		The initial value in pixels, or
	 * @param s 		A string with initial value and units. See `setValue` for supported units.
	 */
	public function new( parent : Dynamic = null ){
		if ((parent != null) && mxd.std.Type.hasInstanceField(parent,['width','height'])) this.parent = parent;
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
	public function setValue( ?v : Float, ?s : String ){
		if (v != null){
			unit = Pixels;
			value = v;
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
		}
	}

	/**
	 * Calculate and return the correct value
	 */
	public function get_value() : Float{
		var v : Float;
		var p : Dynamic = (parent!=null)?parent:UIApp.viewport;
		switch (unit){
			case Pixels:
				v = this.value;
			case ParentWidth:
				if (p==null) return 0;
				v = p.width * value * 0.01;
			case ParentHeight:
				if (p==null) return 0;
				v = p.height * value * 0.01;
			case ParentMin:
				if (p==null) return 0;
				v = Math.min(p.width,p.height) * value * 0.01;
			case ParentMax:
				if (p==null) return 0;
				v = Math.max(p.width,p.height) * value * 0.01;
			case ViewportWidth:
				if (UIApp.viewport==null) return 0;
				v = UIApp.viewport.width * value * 0.01;
			case ViewportHeight:
				if (UIApp.viewport==null) return 0;
				v = UIApp.viewport.height * value * 0.01;
			case ViewportMin:
				if (UIApp.viewport==null) return 0;
				v = Math.min(UIApp.viewport.width,UIApp.viewport.height) * value * 0.01;
			case ViewportMax:
				if (UIApp.viewport==null) return 0;
				v = Math.max(UIApp.viewport.width,UIApp.viewport.height) * value * 0.01;
		}
		if (min!=null){
			min.parent = p;
			v = Math.max(min.value,v);
		}
		if (max!=null){
			max.parent = p;
			v = Math.min(max.value,v);
		}
		return v;
	}

	/**
	 * Set the minimum value. This is actually also a param (so that it can be relative also)
	 * @param v 	The pixel value, or
	 * @param s 	A value with a different unit
	 */
	public function setMinValue( ?v : Float, ?s : String ){
		if ((v==null) && (s==null)){
			min = null;
			return;
		}
		if (min==null) min = new Param(parent);
		min.setValue( v, s );
	}
	function get_minValue() : Null<Float>{
		if (min==null) return null;
		return min.value;
	}
	function set_minValue( v : Null<Float> ) : Null<Float>{
		setMinValue( v );
		return v;
	}

	/**
	 * Set the maximum value. This is actually also a param (so that it can be relative also)
	 * @param v 	The pixel value, or
	 * @param s 	A value with a different unit
	 */
	 public function setMaxValue( ?v : Float, ?s : String ){
		if ((v==null) && (s==null)){
			max = null;
			return;
		}
		if (max==null) max = new Param(parent);
		max.setValue( v, s );
	}
	function get_maxValue() : Null<Float>{
		if (max==null) return null;
		return max.value;
	}
	function set_maxValue( v : Null<Float> ) : Null<Float>{
		setMaxValue( v );
		return v;
	}

}

