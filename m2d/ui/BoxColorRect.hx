package m2d.ui;

import m2d.ui.BoxColor;

/**
 * css-style box model
 */
class BoxColorRect{

	/**
	 * The top size/color pair
	 */
	public var top : BoxColor = new BoxColor();

	/**
	 * The bottom size/color pair
	 */
	public var bottom : BoxColor = new BoxColor();

	/**
	 * The left size/color pair
	 */
	public var left : BoxColor = new BoxColor();

	/**
	 * The right size/color pair
	 */
	public var right : BoxColor = new BoxColor();
 
	/**
	 * Callback when size is changed
	 */
	public var onChangeSize : Void -> Void = null;

	/**
	 * Callback when color is changed
	 */
	public var onChangeColor : Void -> Void = null;

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
		this.top.onChangeColor = changeColor;
		this.right.onChangeColor = changeColor;
		this.bottom.onChangeColor = changeColor;
		this.left.onChangeColor = changeColor;
		this.top.onChangeSize = changeSize;
		this.right.onChangeSize = changeSize;
		this.bottom.onChangeSize = changeSize;
		this.left.onChangeSize = changeSize;
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
		var callback : Void -> Void = onChangeSize; onChangeSize = null; // Ensures callback called only once
		if ((left==null) && (bottom==null) && (right==null)){
			if (topOrAll!=null){
				this.top.size = this.right.size = this.bottom.size = this.left.size = topOrAll;
			}
		}
		else{
			if (topOrAll!=null) this.top.size = topOrAll;
			if (right!=null) this.right.size = right;
			if (bottom!=null) this.bottom.size = bottom;
			if (left!=null) this.left.size = left;
		}
		// Ensure callback is not recursively called
		if (callback != null){
			callback();
			onChangeSize = callback;
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
		var callback : Void -> Void = onChangeColor; onChangeColor = null; // Ensures callback called only once
		if ((left==null) && (bottom==null) && (right==null)){
			if (topOrAll!=null) this.top.color = this.right.color = this.bottom.color = this.left.color = topOrAll;
		}
		else{
			if (topOrAll!=null) this.top.color = topOrAll;
			if (right!=null) this.right.color = right;
			if (bottom!=null) this.bottom.color = bottom;
			if (left!=null) this.left.color = left;
		}
		// Ensure callback is not recursively called
		if (callback != null){
			callback();
			onChangeColor = callback;
		}
	}

	/**
	 * Callback when color changes
	 */
	function changeColor(){
		// Ensure callback is not recursively called
		if (onChangeColor != null){
			var callback : Void -> Void = onChangeColor;
			onChangeColor = null;
			callback();
			onChangeColor = callback;
		}
	}

	/**
	 * Callback when size changes
	 */
	 function changeSize(){
		// Ensure callback is not recursively called
		if (onChangeSize != null){
			var callback : Void -> Void = onChangeSize;
			onChangeSize = null;
			callback();
			onChangeSize = callback;
		}
	}

}