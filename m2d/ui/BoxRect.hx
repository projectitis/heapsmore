package m2d.ui;

/**
 * css-style box model
 */
class BoxRect{

	/**
	 * Size of top
	 */
	public var top(default,set) : Float = 0;

	/**
	 * Size of bottom
	 */
	public var bottom(default,set) : Float = 0;

	/**
	 * Size of left
	 */
	public var left(default,set) : Float = 0;

	/**
	 * Size of right
	 */
	public var right(default,set) : Float = 0;

	/**
	 * Callback when size changes
	 */
	public var onChange : Void -> Void = null;

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
		this.setSize( topOrAll, right, bottom, left );
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
	public function setSize( ?topOrAll : Float, ?right : Float, ?bottom : Float, ?left : Float ){
		var callback : Void -> Void = onChange; onChange=null; // Ensures callback called only once
		if ((left==null) && (bottom==null) && (right==null)){
			if (topOrAll!=null) this.top = this.right = this.bottom = this.left = topOrAll;
		}
		else{
			if (topOrAll!=null) this.top = topOrAll;
			if (right!=null) this.right = right;
			if (bottom!=null) this.bottom = bottom;
			if (left!=null) this.left = left;
		}
		// Ensure callback is not recursively called
		if (callback != null){
			callback();
			onChange = callback;
		}
	}

	/**
	 * Size setters
	 */
	function set_top( v : Float ) : Float{
		top = v;
		changed();
		return v;
	}
	function set_right( v : Float ) : Float{
		right = v;
		changed();
		return v;
	}
	function set_bottom( v : Float ) : Float{
		bottom = v;
		changed();
		return v;
	}
	function set_left( v : Float ) : Float{
		left = v;
		changed();
		return v;
	}
	inline function changed(){
		if (onChange != null){
			var callback : Void -> Void = onChange;
			onChange = null;
			callback();
			onChange = callback;
		}
	}

}