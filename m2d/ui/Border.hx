package m2d.ui;

import h2d.RenderContext;
import h2d.Graphics;
import h2d.Object;
import m2d.ui.BorderDimension;

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

	var rect : Rect = new Rect(); // Area covered by border (to outside)
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
	 * Add this BorderRect to the rect to grow it
	 * @param rect 	The rect to apply to
	 */
	public function growRect( rect : Rect, pw : Float, ph : Float, vw : Float, vh : Float ){
		var l : Float = left.get(pw,ph,vw,vh);
		var r : Float = right.get(pw,ph,vw,vh);
		var t : Float = top.get(pw,ph,vw,vh);
		var b : Float = bottom.get(pw,ph,vw,vh);
		rect.x -= l;
		rect.width += l + r;
		rect.y -= t;
		rect.height += t + b;
	}

	/**
	 * Subtract this BorderRect from the rect to shrink it
	 * @param rect 	The rect to apply to
	 */
	public function shrinkRect( rect : Rect, pw : Float, ph : Float, vw : Float, vh : Float ){
		var l : Float = left.get(pw,ph,vw,vh);
		var r : Float = right.get(pw,ph,vw,vh);
		var t : Float = top.get(pw,ph,vw,vh);
		var b : Float = bottom.get(pw,ph,vw,vh);
		rect.x += l;
		rect.width -= l + r;
		rect.y += t;
		rect.height -= t + b;
	}

	/**
	 * Flag that this element needs a re-sync (and re-draw) next frame
	 */
	public function invalidate(){
		needRedraw = true;
	}

	/**
	 * Called by the parent to reposition or resize the background
	 * @param rect 		The area to position within
	 */
	public function update( r : Rect ){
		this.rect.from(r);
		this.x = this.rect.x;
		this.y = this.rect.y;

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
		if (rect.empty()) return;

		var l : Float = left.get(rect.width,rect.height,ctx.scene.width,ctx.scene.height);
		var t : Float = top.get(rect.width,rect.height,ctx.scene.width,ctx.scene.height);
		var b : Float = bottom.get(rect.width,rect.height,ctx.scene.width,ctx.scene.height);
		var r : Float = right.get(rect.width,rect.height,ctx.scene.width,ctx.scene.height);

		// Top border
		if (!top.undefined){
			this.moveTo(0,0);
			this.beginFill( top.color, top.alpha );
			this.lineTo(rect.width,0);
			this.lineTo(rect.width-r,t);
			this.lineTo(l,t);
			this.lineTo(0,0);
			this.endFill();
		}
		// Right border
		if (!right.undefined){
			this.moveTo(rect.width,0);
			this.beginFill( right.color, right.alpha );
			this.lineTo(rect.width,rect.height);
			this.lineTo(rect.width-r,rect.height-b);
			this.lineTo(rect.width-r,t);
			this.lineTo(rect.width,0);
			this.endFill();
		}
		// Bottom border
		if (!bottom.undefined){
			this.moveTo(0,rect.height);
			this.beginFill( bottom.color, bottom.alpha );
			this.lineTo(rect.width,rect.height);
			this.lineTo(rect.width-r,rect.height-b);
			this.lineTo(l,rect.height-b);
			this.lineTo(0,rect.height);
			this.endFill();
		}
		// Left border
		if (!left.undefined){
			this.moveTo(0,0);
			this.beginFill( left.color, left.alpha );
			this.lineTo(0,rect.height);
			this.lineTo(l,rect.height-b);
			this.lineTo(l,t);
			this.lineTo(0,0);
			this.endFill();
		}
	}

}