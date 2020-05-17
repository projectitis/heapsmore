package m2d.ui;

import h2d.RenderContext;
import h2d.Object;
import h2d.col.Bounds;
import m2d.ui.BorderDimension;
import m2d.ui.Graphics;

/**
 * Rect for UI elements that describes 4 borders. Used internally by UI elements
 */
class Border extends Graphics{

	/**
	 * Top side
	 */
	public var top : BorderDimension = new BorderDimension();

	/**
	 * Bottom side
	 */
	public var bottom : BorderDimension = new BorderDimension();

	/**
	 * Left side
	 */
	public var left : BorderDimension = new BorderDimension();

	/**
	 * Right side
	 */
	public var right : BorderDimension = new BorderDimension();

	/**
	 * Callback when size changes
	 */
	public var onChange : Void -> Void = null;

	var bounds : Bounds = new Bounds(); // Area covered by border (to outside)
	var needRedraw : Bool = true; // Redraw flag

	/**
	 * Create a new Border
	 */
	public function new( ?parent : Object ){
		super( parent );
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
		invalidate();
	}

	/**
	 * Shorthand for setting size all four sides at once
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
	 * Shorthand for unsetting size of all four sides at once
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
	 * Shorthand to set side.color for all four sides
	 * @param c 	The color
	 */
	public function setFillColor( c : Int ){
		var callback : Void -> Void = onChange;
		onChange = null;

		top.color = c;
		right.color = c;
		bottom.color = c;
		left.color = c;

		if (callback != null) callback();
		onChange = callback;
	}

	/**
	 * Shorthand to set side.alpha for all four sides
	 * @param a 	The alpha
	 */
	 public function setFillAlpha( a : Float ){
		var callback : Void -> Void = onChange;
		onChange = null;

		top.alpha = a;
		right.alpha = a;
		bottom.alpha = a;
		left.alpha = a;

		if (callback != null) callback();
		onChange = callback;
	}

	/**
	 * Add this BorderRect to the bounds to grow it
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
	 * Subtract this BorderRect from the bounds to shrink it
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

	/**
	 * Flag that this element needs a re-sync (and re-draw) next frame
	 */
	public function invalidate(){
		needRedraw = true;
	}

	/**
	 * Called by the parent to reposition or resize the background
	 * @param bounds 		The area to position within
	 */
	public function update( bounds : Bounds ){
		this.bounds.load( bounds );
		this.x = this.bounds.x;
		this.y = this.bounds.y;

		invalidate();
	}

	/**
	 * Draw the background onto the canvas at the specified width and height 
	 * @param ctx 	The render context
	 */
	override public function draw( ctx : RenderContext ) {
		super.draw( ctx );
		if (!needRedraw) return;
		needRedraw = false;

		this.clear();
		if (!visible) return;
		if (bounds.isEmpty()) return;

		var l : Float = left.get(bounds.width,bounds.height,ctx.scene.width,ctx.scene.height);
		var t : Float = top.get(bounds.width,bounds.height,ctx.scene.width,ctx.scene.height);
		var b : Float = bottom.get(bounds.width,bounds.height,ctx.scene.width,ctx.scene.height);
		var r : Float = right.get(bounds.width,bounds.height,ctx.scene.width,ctx.scene.height);

		// Top border
		if (!top.undefined){
			this.moveTo(0,0);
			this.beginFill( top.color, top.alpha );
			this.lineTo(bounds.width,0);
			this.lineTo(bounds.width-r,t);
			this.lineTo(l,t);
			this.lineTo(0,0);
			this.endFill();
		}
		// Right border
		if (!right.undefined){
			this.moveTo(bounds.width,0);
			this.beginFill( right.color, right.alpha );
			this.lineTo(bounds.width,bounds.height);
			this.lineTo(bounds.width-r,bounds.height-b);
			this.lineTo(bounds.width-r,t);
			this.lineTo(bounds.width,0);
			this.endFill();
		}
		// Bottom border
		if (!bottom.undefined){
			this.moveTo(0,bounds.height);
			this.beginFill( bottom.color, bottom.alpha );
			this.lineTo(bounds.width,bounds.height);
			this.lineTo(bounds.width-r,bounds.height-b);
			this.lineTo(l,bounds.height-b);
			this.lineTo(0,bounds.height);
			this.endFill();
		}
		// Left border
		if (!left.undefined){
			this.moveTo(0,0);
			this.beginFill( left.color, left.alpha );
			this.lineTo(0,bounds.height);
			this.lineTo(l,bounds.height-b);
			this.lineTo(l,t);
			this.lineTo(0,0);
			this.endFill();
		}
	}

}