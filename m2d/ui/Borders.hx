package m2d.ui;

import h2d.Graphics;

/**
 * Describes for borders. used internally by UI elements
 */
class Borders{

	/**
	 * The top size/color pair
	 */
	public var top : Border = new Border();

	/**
	 * The bottom size/color pair
	 */
	public var bottom : Border = new Border();

	/**
	 * The left size/color pair
	 */
	public var left : Border = new Border();

	/**
	 * The right size/color pair
	 */
	public var right : Border = new Border();

	/**
	 * Visibility flag
	 */
	 public var visible(default,set) : Bool = true;
 
	/**
	 * Callback when size is changed
	 */
	public var onChangeSize : Void -> Void = null;

	/**
	 * Callback when color is changed (also when visibility is changed)
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

	/**
	 * Visible
	 */
	 function set_visible( v : Bool ) : Bool{
		if (this.visible != v){
			this.visible = v;
			changeColor();
		}
		return v;
	}

	/**
	 * Draw the background onto the canvas at the specified width and height 
	 * @param canvas 	The Graphics object to draw to
	 * @param width 	The width of the background
	 * @param height 	The height of the background
	 * @param radius 	The inner corner radius
	 */
	public function drawTo( canvas : Graphics, width : Float, height : Float, radius : Float = 0 ) {
		canvas.clear();
		if (!visible) return;

		var a : Float;

		// Top border
		if (top.size>0){
			a = mxd.utils.Color.getAlpha( top.color, true );
			canvas.moveTo(0,0);
			canvas.beginFill( top.color, a );
			canvas.lineTo(width,0);
			canvas.lineTo(width-right.size,top.size);
			canvas.lineTo(left.size,top.size);
			canvas.lineTo(0,0);
			canvas.endFill();
		}
		// Right border
		if (right.size>0){
			a = mxd.utils.Color.getAlpha( right.color, true );
			canvas.moveTo(width,0);
			canvas.beginFill( right.color, a );
			canvas.lineTo(width,height);
			canvas.lineTo(width-right.size,height-bottom.size);
			canvas.lineTo(width-right.size,top.size);
			canvas.lineTo(width,0);
			canvas.endFill();
		}
		// Bottom border
		if (bottom.size>0){
			a = mxd.utils.Color.getAlpha( bottom.color, true );
			canvas.moveTo(0,height);
			canvas.beginFill( bottom.color, a );
			canvas.lineTo(width,height);
			canvas.lineTo(width-right.size,height-bottom.size);
			canvas.lineTo(left.size,height-bottom.size);
			canvas.lineTo(0,height);
			canvas.endFill();
		}
		// Left border
		if (left.size>0){
			a = mxd.utils.Color.getAlpha( left.color, true );
			canvas.moveTo(0,0);
			canvas.beginFill( left.color, a );
			canvas.lineTo(0,height);
			canvas.lineTo(left.size,height-bottom.size);
			canvas.lineTo(left.size,top.size);
			canvas.lineTo(0,0);
			canvas.endFill();
		}
	}

}