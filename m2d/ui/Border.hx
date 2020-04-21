package m2d.ui;

/**
 * One side of a border
 */
class Border{

	/**
	 * Size of a BoxColor will never be negative
	 */
	public var size(default,set) : Float = 0;

	/**
	 * Color
	 */
	public var color(default,set) : Int = 0;

	/**
	 * Callback when size changes
	 */
	public var onChangeSize : Void -> Void = null;

	/**
	 * Callback when color changes
	 */
	public var onChangeColor : Void -> Void = null;

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
		var n = hxd.Math.max(0,v);
		if (this.size != n){
			this.size = n;
			if (onChangeSize!=null){
				var callback : Void -> Void = onChangeSize;
				onChangeSize = null;
				callback();
				onChangeSize = callback;
			}
		}
		return v;
	}

	/**
	 * Color
	 */
	function set_color( c : Int ) : Int{
		if (this.color != c){
			this.color = c;
			if (onChangeColor!=null){
				var callback : Void -> Void = onChangeColor;
				onChangeColor = null;
				callback();
				onChangeColor = callback;
			}
		}
		return c;
	}

}