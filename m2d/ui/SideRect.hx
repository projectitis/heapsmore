package m2d.ui;

import h2d.Object;
import h2d.col.Bounds;
import m2d.ui.Dimension;

/**
 * Rect for UI elements that describes 4 sides. Used internally by UI elements
 */
class SideRect{

	/**
	 * Top side
	 */
	public var top : Dimension = new Dimension();

	/**
	 * Bottom side
	 */
	public var bottom : Dimension = new Dimension();

	/**
	 * Left side
	 */
	public var left : Dimension = new Dimension();

	/**
	 * Right side
	 */
	public var right : Dimension = new Dimension();

	/**
	 * Callback when size changes
	 */
	public var onChange : Void -> Void = null;

	/**
	 * Create a new SideRect
	 */
	public function new(){
		top.onChange = changed;
		bottom.onChange = changed;
		left.onChange = changed;
		right.onChange = changed;
	}

	function changed(){
		if (onChange != null){
			var callback : Void -> Void = onChange;
			onChange = null;
			callback();
			onChange = callback;
		}
	}

	/**
	 * Shorthand for setting all four sides at once
	 * @param v 	The value in pixels, or
	 * @param s 	A string with value and units. If no units, px is assumed. Supported:
	 * 					px (pixels), 
	 * 					% (same as pw),
	 * 					pw (parent width),
	 * 					ph (parent height),
	 * 					p- (parent smalest dim),
	 * 					p+ (parent largest dim),
	 * 					vw (viewport/stage width),
	 * 					vh (viewport/stage height),
	 * 					v- (viewport/stage smallest dim),
	 * 					v+ (viewport/stage largest dim)
	 */
	public function set( ?v : Float, ?s : String ){
		var callback : Void -> Void = onChange;
		onChange = null;

		top.set(v,s);
		right.set(v,s);
		bottom.set(v,s);
		left.set(v,s);

		if (callback != null) callback();
		onChange = callback;
	}

	/**
	 * Shorthand for unsetting all four sides
	 */
	public function unset(){
		var callback : Void -> Void = onChange;
		onChange = null;

		top.unset();
		right.unset();
		bottom.unset();
		left.unset();

		if (callback != null) callback();
		onChange = callback;
	}

	/**
	 * Add this SideRect to the bounds to grow it
	 * @param bounds 	The bounds to apply to
	 */
	public function growBounds( bounds : Bounds, pw : Float, ph : Float, vw : Float, vh : Float ){
		var l : Float = left.get(pw,ph,vw,vh);
		var r : Float = right.get(pw,ph,vw,vh);
		var t : Float = top.get(pw,ph,vw,vh);
		var b : Float = bottom.get(pw,ph,vw,vh);
		bounds.x -= l;
		bounds.width += l + r;
		bounds.y -= t;
		bounds.height += t + b;
	}

	/**
	 * Subtract this SideRect from the bounds to shrink it. Bound width/height can never go -ve
	 * @param bounds 	The bounds to apply to
	 */
	public function shrinkBounds( bounds : Bounds, pw : Float, ph : Float, vw : Float, vh : Float ){
		var l : Float = left.get(pw,ph,vw,vh);
		var r : Float = right.get(pw,ph,vw,vh);
		var t : Float = top.get(pw,ph,vw,vh);
		var b : Float = bottom.get(pw,ph,vw,vh);
		bounds.x += l;
		bounds.width -= l + r;
		bounds.y += t;
		bounds.height -= t + b;
	}

}