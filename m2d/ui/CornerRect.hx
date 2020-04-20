package m2d.ui;

/**
 * A class to manage the radii of the corners of a box
 */
class CornerRect{

	/**
	 * Size of top
	 */
	public var topLeft(default,set) : Float = 0;

	/**
	 * Size of bottom
	 */
	public var topRight(default,set) : Float = 0;

	/**
	 * Size of left
	 */
	public var bottomLeft(default,set) : Float = 0;

	/**
	 * Size of right
	 */
	public var bottomRight(default,set) : Float = 0;

	/**
	 * Callback when size changes
	 */
	public var onChange : Void -> Void = null;

	/**
	 * Create a new object with the specified values. If only topLeftOrAll is provided, all corners will be
	 * set to topLeftOrAll. If additional values are provided they will set their respective corners. If a 
	 * value is null, the current value for that corner will not be changed.
	 * @param topLeftOrAll	The value for top-left (or for all, if rest are omitted)
	 * @param topRight		The value for top-right (no change if null)
	 * @param bottomLeft 	The value for bottom-left (no change if null)
	 * @param bottomRight 	The value for bottom-right (no change if null)
	 */
	public function new( topLeftOrAll : Float = 0, ?topRight : Float, ?bottomLeft : Float, ?bottomRight : Float ){
		this.setSize( topLeftOrAll, topRight, bottomLeft, bottomRight );
	}

	/**
	 * Set all corners to the specified values. If only topLeftOrAll is provided, all corners will be
	 * set to topLeftOrAll. If additional values are provided they will set their respective corners. If a 
	 * value is null, the current value for that corner will not be changed.
	 * @param topLeftOrAll	The value for top-left (or for all, if rest are omitted)
	 * @param topRight		The value for top-right (no change if null)
	 * @param bottomLeft 	The value for bottom-left (no change if null)
	 * @param bottomRight 	The value for bottom-right (no change if null)
	 **/
	public function setSize( ?topLeftOrAll : Float, ?topRight : Float, ?bottomLeft : Float, ?bottomRight : Float ){
		var callback : Void -> Void = onChange; onChange=null; // Ensures callback called only once
		if ((topRight==null) && (bottomLeft==null) && (bottomRight==null)){
			if (topLeftOrAll!=null) this.topLeft = this.topRight = this.bottomLeft = this.bottomRight = topLeftOrAll;
		}
		else{
			if (topLeftOrAll!=null) this.topLeft = topLeftOrAll;
			if (topRight!=null) this.topRight = topRight;
			if (bottomLeft!=null) this.bottomLeft = bottomLeft;
			if (bottomRight!=null) this.bottomRight = bottomRight;
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
	function set_topLeft( v : Float ) : Float{
		topLeft = v;
		changed();
		return v;
	}
	function set_topRight( v : Float ) : Float{
		topRight = v;
		changed();
		return v;
	}
	function set_bottomLeft( v : Float ) : Float{
		bottomLeft = v;
		changed();
		return v;
	}
	function set_bottomRight( v : Float ) : Float{
		bottomRight = v;
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