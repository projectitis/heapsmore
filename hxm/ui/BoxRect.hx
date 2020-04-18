package hxm.ui;

/**
 * css-style box model
 */
class BoxRect{

	/**
	 * Size of top
	 */
	public var top : Float = 0;

	/**
	 * Size of bottom
	 */
	public var bottom : Float = 0;

	/**
	 * Size of left
	 */
	public var left : Float = 0;

	/**
	 * Size of right
	 */
	public var right : Float = 0;

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
	 * Create a new BoxRect with the specified values. If only topOrAll is provided, all sides will be
	 * set to topOrAll. If additional values are provided they will set their respective sides. If aa value
	 * is null, the current value for that side will not be changed.
	 * @param topOrAll		The value for top (or for all, if rest are omitted)
	 * @param right			The value for right (no change if null)
	 * @param bottom 		The value for bottom (no change if null)
	 * @param left 			The value for left (no change if null)
	 */
	public function new( topOrAll : Float = 0, ?right : Float, ?bottom : Float, ?left : Float ){
		this.set( topOrAll, right, bottom, left );
	}

	/**
	 * Set all sides to the specified values. If only topOrAll is provided, all sides will be set to topOrAll.
	 * If additional values are provided they will set their respective sides. If aa value is null, the current
	 * value for that side will not be changed.
	 * @param topOrAll		The value for top (or for all, if rest are omitted)
	 * @param right			The value for right (no change if null)
	 * @param bottom 		The value for bottom (no change if null)
	 * @param left 			The value for left (no change if null)
	 */
	public function set( ?topOrAll : Float, ?right : Float, ?bottom : Float, ?left : Float ){
		if ((left==null) && (bottom==null) && (right==null)){
			if (topOrAll!=null) this.top = this.right = this.bottom = this.left = topOrAll;
		}
		else{
			if (topOrAll!=null) this.top = topOrAll;
			if (right!=null) this.right = right;
			if (bottom!=null) this.bottom = bottom;
			if (left!=null) this.left = left;
		}
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