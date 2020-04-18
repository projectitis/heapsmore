package m2d.ui;

/**
 * css-style box model
 */
class BoxColor{

	/**
	 * Size of a BoxColor will never be negative
	 */
	public var size(default,set) : Float = 0;

	/**
	 * Color
	 */
	public var color(default,set) : Int = 0;

	/**
	 * Create new BoxArea with specified width and height
	 * @param width 
	 * @param height 
	 */
	public function new( ?size : Float, ?color : Int ){
		if (size!=null) this.size = size;
		if (color!=null) this.color = color;
	}

	/**
	 * Size
	 */
	 function set_size( v : Float ) : Float{
		this.size = (v<0)?0:v;
		return v;
	}

	/**
	 * Color
	 */
	function set_color( c : Int ) : Int{
		this.color = (c<0)?0:c;
		return c;
	}

}