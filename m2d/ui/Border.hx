package m2d.ui;

import h2d.Object;
import mxd.Param;

/**
 * One side of a border
 */
class Border{

	/**
	 * Value for border size
	 */
	var s : Param = new Param();

	/**
	 * Top anchor for positioning
	 */
	public var parent(get,set) : Object;

	/**
	 * Size of a BoxColor will never be negative
	 */
	public var size(get,set) : Float;

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
		s.setMinValue(0);
		if (size!=null) this.s.setValue( size );
		if (color!=null) this.color = color;
	}

	/**
	 * Parent
	 */
	function get_parent() : Object{
		return s.parent;
	}
	function set_parent( v : Object ) : Object{
		s.parent = v;
		sizeChanged();
		return v;
	}

	/**
	 * Size
	 */
	function get_size() : Float{
		return s.value;
	}
	function set_size( v : Float ) : Float{
		this.s.setValue( v );
		sizeChanged();
		return v;
	}
	public function setSize( ?v : Float, ?s : String ){
		this.s.setValue( v, s );
		sizeChanged();
	}
	function sizeChanged(){
		if (onChangeSize!=null){
			var callback : Void -> Void = onChangeSize;
			onChangeSize = null;
			callback();
			onChangeSize = callback;
		}
	}

	/**
	 * Color
	 */
	function set_color( c : Int ) : Int{
		this.color = c;
		if (onChangeColor!=null){
			var callback : Void -> Void = onChangeColor;
			onChangeColor = null;
			callback();
			onChangeColor = callback;
		}
		return c;
	}

}