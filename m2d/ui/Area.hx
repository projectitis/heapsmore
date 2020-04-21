package m2d.ui;

/**
 * Area with width and height. Used internally by UI elements.
 */
class Area{

	/**
	 * Get or set the width. Actually calls onWidth, which must be handled by the parent.
	 */
	public var width(default,set) : Float;

	/**
	 * Get or set the height. Actually calls onHeight, which must be handled by the parent.
	 */
	public var height(default,set) : Float;
 
	/**
	 * Callback when size changes
	 */
	public var onChange : Void -> Void = null;

	/**
	 * Create new BoxArea with specified width and height. If a parameter is null, the
	 * current value for that parameter is not changed.
	 * @param width 	The width
	 * @param height 	The height
	 */
	public function new( ?width : Float, ?height : Float ){
		setSize(width,height);
	}

	/**
	 * Set width and height. If a parameter is null, the
	 * current value for that parameter is not changed.
	 * @param width 	The width
	 * @param height 	The height
	 */
	public function setSize( width : Null<Float>, height : Null<Float> = null ){
		var callback : Void -> Void = onChange; onChange = null; // Ensures callback called only once
		if (width!=null) this.width = width;
		if (height!=null) this.height = height;
		// Ensure callback is not recursively called
		if (callback != null){
			callback();
			onChange = callback;
		}
	}

	/**
	 * Size getter and setters (pass-thru to callback)
	 */
	function set_width( v : Float ) : Float{
		width = (v<0)?0:v;
		changed();
		return v;
	}
	function set_height( v : Float ) : Float{
		height = (v<0)?0:v;
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