package hxm.ui;

/**
 * css-style box model
 */
class BoxArea{

	/**
	 * Get or set the width. Actually calls onWidth, which must be handled by the parent.
	 */
	 public var width(get,set) : Float;

	 /**
	  * Get or set the height. Actually calls onHeight, which must be handled by the parent.
	  */
	 public var height(get,set) : Float;
 
	 /**
	  * Callback when width is get or set. Implement by parent.
	  */
	 public var onWidth : Null<Float> -> Float = null;
 
	 /**
	  * Callback when height is get or set. Implement by parent.
	  */
	 public var onHeight : Null<Float> -> Float = null;

	/**
	 * Create new BoxArea with specified width and height. If a parameter is null, the
	 * current value for that parameter is not changed.
	 * @param width 	The width
	 * @param height 	The height
	 */
	public function new( ?width : Float, ?height : Float ){
		set(width,height)
	}

	/**
	 * Set width and height. If a parameter is null, the
	 * current value for that parameter is not changed.
	 * @param width 	The width
	 * @param height 	The height
	 */
	public function set( width : Null<Float>, height : Null<Float> = null ){
		if (width!=null) this.width = width;
		if (height!=null) this.height = height;
	}

	/**
	 * Size getter and setters (pass-thru to callback)
	 */
	 function get_width() : Float{
		if (onWidth==null) return 0;
		return onWidth(null);
	}
	function set_width( v : Float ) : Float{
		if (onWidth==null) return 0;
		return onWidth(v);
	}
	function get_height() : Float{
		if (onHeight==null) return 0;
		return onHeight(null);
	}
	function set_height( v : Float ) : Float{
		if (onHeight==null) return 0;
		return onHeight(v);
	}

}