package m2d.ui;

import h2d.RenderContext;
import h2d.Drawable;
import h2d.Object;
import h2d.col.Bounds;
import m2d.ui.Background;
import m2d.ui.Border;
import m2d.ui.Dimension;
import m2d.ui.MarginRect;
import m2d.ui.SideRect;
import m2d.ui.Sides;

/**
 * The units supported by Canvas
 */
enum CanvasUnit{
	Pixels;
	ParentWidth;
	ParentHeight;
	ParentMin;
	ParentMax;
	ViewportWidth;
	ViewportHeight;
	ViewportMin;
	ViewportMax;
}

/**
 * Position supported by the canvas
 */
enum CanvasPosition{
	Relative;
	Absolute;
}

/**
 * Base-class for all UI components. Manages sizing and positioning.
 */
class Canvas extends Drawable{

	/**
	 * The background of the canvas. Set a colour or image (or both).
	 */
	public var background : Background;

	/**
	 * Border
	 */
	public var border : Border;

	/**
	 * Positioning. Relative (default) is where it would usually appear. Absolute means it does not respect siblings.
	 */
	public var position(default,set) : CanvasPosition = Relative;

	/**
	 * Offset from the top of the parent
	 */
	public var top : Dimension = new Dimension();

	/**
	 * Offset from the left of the parent
	 */
	public var left : Dimension = new Dimension();

	/**
	 * Offset from the right of the parent
	 */
	 public var right : Dimension = new Dimension();

	/**
	 * Offset from the bottom of the parent
	 */
	public var bottom : Dimension = new Dimension();

	/**
	 * Total target height of this element (excluding margins). If width is not set, 100% (100pw) is used
	 */
	public var width : Dimension = new Dimension();

	/**
	 * Total target width of this element (excluding margins). If height is not set, height is determined by child elements
	 */
	public var height : Dimension = new Dimension();

	/**
	 * Margin
	 */
	public var margin : MarginRect = new MarginRect();

	/**
	 * Padding
	 */
	public var padding : SideRect = new SideRect();

	/**
	 * The total area covered by this element (excluding margins)
	 */
	public var bounds(get,never) : Bounds;

	/**
	 * The size of each margin
	 */
	public var margins(get,never) : Sides;

	/**
	 * Convenience properties for subclasses
	 */
	var topSpacing(get,never) : Float;			// Top padding + border + margin
	var bottomSpacing(get,never) : Float;		// Bottom		"
	var leftSpacing(get,never) : Float;			// Left			"
	var rightSpacing(get,never) : Float;		// Right		"
	var verticalSpacing(get,never) : Float;		// Top and bottom padding + border + margin
	var horizontalSpacing(get,never) : Float;	// Left and right 		"

	var parentBounds : Bounds = new Bounds();		// Total available area to all siblings
	var elementBounds : Bounds = new Bounds();		// Total available area to this element
	var marginBounds : Bounds = new Bounds();		// Margin + border + padding + content
	var marginSides : Sides = new Sides();
	var borderBounds : Bounds = new Bounds();		// Border + padding + content
	var paddingBounds : Bounds = new Bounds();		// Padding + content
	var contentBounds : Bounds = new Bounds();		// Content
	var needResync : Bool = false;
	var needRedraw : Bool = false;

	/**
	 * Create new canvas object
	 * @param parent 	The parent. Usually another Canvas object (or subclass)
	 */
	public function new( ?parent : Object ){
		super(parent);

		background = new Background( this );
		border = new Border( this );
		border.onChange = invalidate;
		top.onChange = invalidate;
		left.onChange = invalidate;
		bottom.onChange = invalidate;
		right.onChange = invalidate;
		width.onChange = invalidate;
		height.onChange = invalidate;
		margin.onChange = invalidate;
		border.onChange = invalidate;
		padding.onChange = invalidate;
	}

	function get_bounds() : Bounds{
		return marginBounds;
	}

	function set_position( v : CanvasPosition ) : CanvasPosition{
		position = v;
		invalidate();
		return v;
	}

	function get_margins() : Sides{
		return marginSides;
	}

	function get_topSpacing(){
		return contentBounds.y - marginBounds.y;
	}
	function get_bottomSpacing(){
		return marginBounds.yMax - contentBounds.yMax;
	}
	function get_leftSpacing(){
		return contentBounds.x - marginBounds.x;
	}
	function get_rightSpacing(){
		return marginBounds.xMax - contentBounds.xMax;
	}
	function get_verticalSpacing(){
		return marginBounds.height - contentBounds.height;
	}
	function get_horizontalSpacing(){
		return marginBounds.width - contentBounds.width;
	}

	/**
	 * Flag that this element needs a re-sync (and re-draw) next frame
	 */
	public function invalidate(){
		needResync = true;
	}

	/**
	 * Called by the parent to (re)position this canvas within the supplied bounds. 
	 * @param bounds 		The area available within the parent
	 */
	public function update( bounds : Bounds ){
		this.parentBounds.load(bounds);
		elementBounds.load(bounds);

		invalidate();
	}
	
	/**
	 * Sub-classes should override this to do any calculations required before a call to draw.
	 * The sync method is triggered by setting `needResync=true` from internal methods that require
	 * the element properties to be recalculated.
	 * XXX: Relative borders/margins based on `this` rather than parent?
	 * @param ctx 	The render context
	 */
	override function sync( ctx:RenderContext ) {
		var nr : Bool = needResync; // Incase sync flags are changed during sync
		if (needResync){
			needResync = false;
			needRedraw = true;

			sync_pre( ctx );

			sync_layout( ctx );
			sync_position( ctx );
			sync_children( ctx );

			sync_main( ctx );
		}

		super.sync( ctx );

		if (nr){
			sync_reposition( ctx );
			sync_post( ctx );
		}
	}

	/**
	 * Override to perform any initial sync operations 
	 */
	function sync_pre( ctx:RenderContext ){}

	/**
	 * Override to perform main sync operations after layout, position and children have been updated
	 */
	function sync_main( ctx:RenderContext ){}

	/**
	 * Override to perform any final sync operations
	 */
	function sync_post( ctx:RenderContext ){}

	/**
	 * Sync operations that adjust size and position based on previous sibling. This is
	 * used to stack elements in layouts.
	 */
	function sync_layout( ctx:RenderContext ){
		// Get previous sibling
		if (position != Absolute){
			var c : Canvas = null;
			var sibling : Canvas = null;
			for (child in parent.children){
				if (child == this) break;
				if (Std.is(child,Canvas)){
					c = cast(child,Canvas);
					// Ignore 'floating' elements which are not relatively positioned
					if (c.position != Absolute) sibling = c;
				}
			}
			if (sibling!=null){
				// Move element down below the sibling
				// XXX: Different layouts. At the moment only vertical stacking
				var dy : Float = (sibling.y + sibling.bounds.height) - this.parentBounds.y;
				if (dy>0){
					elementBounds.y += dy;
					elementBounds.height = Math.max(0,elementBounds.height - dy);
				}
				// Adjust for margin collapse
				if (this.margin.collapse || sibling.margin.collapse){
					// Get this top margin and sibling bottom margin
					var tm : Float = margin.top.get(parentBounds.width,parentBounds.height,ctx.scene.width,ctx.scene.height);
					var bm : Float = sibling.margins.bottom;
					elementBounds.y -= Math.min(tm,bm);
					elementBounds.height += Math.min(tm,bm);
				}
			}
		}
	}

	/**
	 * Sync operations that calculate the position and size of this element. This sets all the various rects
	 * (content, padding, border, margin) based on the position and size properties of the element.
	 * Sub-classes are able to adjust the size of contentRect, which are then picked up in sync_reposition.
	 */
	function sync_position( ctx:RenderContext ){
		// Precalcuate dimensions
		var l : Float = left.get(parentBounds.width,parentBounds.height,ctx.scene.width,ctx.scene.height);
		var t : Float = top.get(parentBounds.width,parentBounds.height,ctx.scene.width,ctx.scene.height);
		var b : Float = bottom.get(parentBounds.width,parentBounds.height,ctx.scene.width,ctx.scene.height);
		var r : Float = right.get(parentBounds.width,parentBounds.height,ctx.scene.width,ctx.scene.height);
		var w : Float = width.get(parentBounds.width,parentBounds.height,ctx.scene.width,ctx.scene.height);
		var h : Float = height.get(parentBounds.width,parentBounds.height,ctx.scene.width,ctx.scene.height);

		// Left is set...
		if (!left.undefined){
			// Set left
			marginBounds.x = elementBounds.x + l;
			// Both left and right are set. Ignore width
			if (!right.undefined) marginBounds.width = elementBounds.width - l - r;
			// Left and width are set. Use width (but limit to parent area)
			else if (!width.undefined && !width.auto) marginBounds.width = Math.max(0,Math.min(w,elementBounds.width - l));
			// Otherwise fill from left to edge (100%)
			else marginBounds.width = elementBounds.width - l;
		}
		// Right is set...
		else if (!right.undefined){
			// Right and width are set. Use width (but limit to parent area)
			if (!width.undefined && !width.auto) marginBounds.width = Math.max(0,Math.min(w,elementBounds.width - r));
			// Otherwise fill from right to edge (100%)
			else marginBounds.width = elementBounds.width - r;
			// Set left
			marginBounds.x = elementBounds.xMax - r - marginBounds.width;
		}
		// Neither left or right, but width is set..
		else if (!width.undefined && !width.auto){
			// Set left
			marginBounds.x = elementBounds.x;
			// Use width (but limit to parent area)
			marginBounds.width = Math.min(w,elementBounds.width);
		}
		// Nothing set...
		else{
			// Set left
			marginBounds.x = elementBounds.x;
			// Set full width (100%)
			marginBounds.width = elementBounds.width;
		}

		// Top is set...
		if (!top.undefined){
			// See top
			marginBounds.y = elementBounds.y + t;
			// Both top and bottom are set. Ignore height
			if (!bottom.undefined) marginBounds.height = elementBounds.height - t - b;
			// Top and height are set. Use height (but limit to parent area)
			else if (!height.undefined && !height.auto) marginBounds.height = Math.max(0,Math.min(h,elementBounds.height - t));
			// Otherwise fill from top to edge (100%)
			else marginBounds.height = elementBounds.height - t;
		}
		// Bottom is set...
		else if (!bottom.undefined){
			// Top and height are set. Use height (but limit to parent area)
			if (!height.undefined && !height.auto) marginBounds.height = Math.max(0,Math.min(h,elementBounds.height - b));
			// Otherwise fill from bottom to edge (100%)
			else marginBounds.height = elementBounds.height - b;
			// Set top
			marginBounds.y = elementBounds.yMax - b - marginBounds.height;
		}
		// Neither top or bottom, but height is set..
		else if (!height.undefined && !height.auto){
			// Set top
			marginBounds.y = elementBounds.y;
			// Use height (but limit to parent area)
			marginBounds.height = Math.min(h,elementBounds.height);
		}
		// Nothing set...
		else{
			// Set top
			marginBounds.y = elementBounds.y;
			// Set full width (100%)
			marginBounds.height = elementBounds.height;
		}

		// Position this element
		this.x = marginBounds.x;
		this.y = marginBounds.y;
		marginBounds.x = 0;
		marginBounds.y = 0;

		// Update areas
		borderBounds.load( marginBounds );
		margin.shrinkBounds( borderBounds, parentBounds.width,parentBounds.height,ctx.scene.width,ctx.scene.height);
		paddingBounds.load( borderBounds );
		border.shrinkBounds( paddingBounds, parentBounds.width,parentBounds.height,ctx.scene.width,ctx.scene.height);
		contentBounds.load( paddingBounds );
		padding.shrinkBounds( contentBounds, parentBounds.width,parentBounds.height,ctx.scene.width,ctx.scene.height);
		marginSides.top = borderBounds.y - marginBounds.y;
		marginSides.right = marginBounds.xMax - borderBounds.xMax;
		marginSides.left = borderBounds.x - marginBounds.x;
		marginSides.bottom = marginBounds.yMax - borderBounds.yMax;
	}

	/**
	 * Sync operations based on updating the children
	 */
	function sync_children( ctx:RenderContext ){
		// Update the children
		var mx : Float = 0;
		var my : Float = 0;
		var c : Canvas = null;
		for (child in children){
			if (Std.is(child,Canvas)){
				c = cast(child,Canvas);
				c.update( contentBounds );
				c.sync( ctx );
				mx = Math.max(mx,c.bounds.xMax);
				my = Math.max(my,c.bounds.yMax);
			}
		}
		if (height.auto) contentBounds.height = my;
		if (width.auto) contentBounds.width = mx;
	}

	/**
	 * The content bounds may have changed, so do any final repositioning based on that.
	 * @param ctx 
	 */
	function sync_reposition( ctx:RenderContext ){
		// Update areas based on content
		paddingBounds.load( contentBounds );
		padding.growBounds( paddingBounds, parentBounds.width,parentBounds.height,ctx.scene.width,ctx.scene.height);
		borderBounds.load( paddingBounds );
		border.growBounds( borderBounds, parentBounds.width,parentBounds.height,ctx.scene.width,ctx.scene.height);
		marginBounds.load( borderBounds );
		margin.growBounds( marginBounds, parentBounds.width,parentBounds.height,ctx.scene.width,ctx.scene.height);
		marginSides.top = borderBounds.y - marginBounds.y;
		marginSides.right = marginBounds.xMax - borderBounds.xMax;
		marginSides.left = borderBounds.x - marginBounds.x;
		marginSides.bottom = marginBounds.yMax - borderBounds.yMax;

		// Update the background
		background.update( paddingBounds );

		// Update the border
		border.update( borderBounds );
	}

	/**
	 * Apply mask to render context
	 * @param ctx 		The render context
	 * @param bounds 	The bounds
	 */
	function mask( ctx : RenderContext, bounds : Bounds ) {
		ctx.flush();
		ctx.pushRenderZone( bounds.x, bounds.y, bounds.width, bounds.height );
	}

	/**
	 * Remove the mask
	 * @param ctx The render context
	 */
	public static function unmask( ctx : RenderContext ) {
		ctx.flush();
		ctx.popRenderZone();
	}

	/**
	 * Sub-classes should override this to draw the UI element. Any size calculations
	 * etc should be done in sync, and not as part of draw.
	 * @param ctx 	The render context
	 */
	override function draw( ctx:RenderContext ) {
		var nr : Bool = needRedraw; // Incase flags are changed during draw
		if (needRedraw){
			needRedraw = false;
			draw_pre( ctx );
		}

		super.draw(ctx);

		if (nr) draw_post( ctx );
	}

	/**
	 * Override to perform any initial draw operations
	 */
	function draw_pre( ctx:RenderContext ){}

	/**
	 * Override to perform any final draw operations
	 */
	function draw_post( ctx:RenderContext ){}

	override function drawRec( ctx : h2d.RenderContext ) @:privateAccess {
		mask( ctx, parentBounds );
		super.drawRec(ctx);
		unmask(ctx);
	}

}