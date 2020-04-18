package m2d.ui;

import m2d.ui.BoxColor;

/**
 * css-style box model
 */
class BoxColorRect{

	public var top : BoxColor = new BoxColor();
	public var bottom : BoxColor = new BoxColor();
	public var left : BoxColor = new BoxColor();
	public var right : BoxColor = new BoxColor();

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
	 * Create with all side sizes at the specified values. If only topOrAll is provided, all sizes will be set to
	 * topOrAll. If additional values are provided they will set their respective sides. If a value is null, the
	 * current value for that side will not be changed.
	 * @param topOrAll		The value for top size (or for all, if rest are omitted)
	 * @param right 		The value for right size
	 * @param bottom 		The value for bottom size
	 * @param left			The value for left size
	 */
	public function new( topOrAll : Float = 0, ?right : Float, ?bottom : Float, ?left : Float ){
		this.setSize( topOrAll, right, bottom, left );
	}

	/**
	 * Set all sizes to the specified values. If only topOrAll is provided, all sides will be set to topOrAll.
	 * If additional values are provided they will set their respective sides. If a value is null, the current
	 * value for that side will not be changed.
	 * @param topOrAll		The size of top (or for all, if rest are omitted)
	 * @param right			The size of right (no change if null)
	 * @param bottom 		The size of bottom (no change if null)
	 * @param left 			The size of left (no change if null)
	 */
	 public function setSize( ?topOrAll : Float, ?right : Float, ?bottom : Float, ?left : Float ){
		if ((left==null) && (bottom==null) && (right==null)){
			if (topOrAll!=null) this.top.size = this.right.size = this.bottom.size = this.left.size = topOrAll;
		}
		else{
			if (topOrAll!=null) this.top.size = topOrAll;
			if (right!=null) this.right.size = right;
			if (bottom!=null) this.bottom.size = bottom;
			if (left!=null) this.left.size = left;
		}
	}

	/**
	 * Set all colors to the specified values. If only topOrAll is provided, all sides will be set to topOrAll.
	 * If additional values are provided they will set their respective sides. If a value is null, the current
	 * value for that side will not be changed.
	 * @param topOrAll		The color of top (or for all, if rest are omitted)
	 * @param right			The color of right (no change if null)
	 * @param bottom 		The color of bottom (no change if null)
	 * @param left 			The color of left (no change if null)
	 */
	 public function setColor( ?topOrAll : Int, ?right : Int, ?bottom : Int, ?left : Int ){
		if ((left==null) && (bottom==null) && (right==null)){
			if (topOrAll!=null) this.top.color = this.right.color = this.bottom.color = this.left.color = topOrAll;
		}
		else{
			if (topOrAll!=null) this.top.color = topOrAll;
			if (right!=null) this.right.color = right;
			if (bottom!=null) this.bottom.color = bottom;
			if (left!=null) this.left.color = left;
		}
	}

	/**
	 * Size getter and setters (pass-thru to callbac)
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