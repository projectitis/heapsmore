package m2d.ui;

import h2d.RenderContext;
import h2d.Drawable;
import h2d.Object;
import m2d.Rect;
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
	Static;
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
	 * Positioning. Static (default) is where it would usually appear. Absolute means it does not respect siblings.
	 */
	public var position(default,set) : CanvasPosition = Static;

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
	 * Total target height of this element (excluding margins)
	 */
	public var width : Dimension = new Dimension();

	/**
	 * Total target width of this element (excluding margins)
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
	public var rect(get,never) : Rect;

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

	var parentRect : Rect = new Rect();		// Total available area to all siblings
	var elementRect : Rect = new Rect();	// Total available area to this element
	var marginRect : Rect = new Rect();		// Margin + border + padding + content
	var marginSides : Sides = new Sides();
	var borderRect : Rect = new Rect();		// Border + padding + content
	var paddingRect : Rect = new Rect();	// Padding + content
	var contentRect : Rect = new Rect();	// Content
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

	function get_rect() : Rect{
		return marginRect;
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
		return contentRect.y - marginRect.y;
	}
	function get_bottomSpacing(){
		return marginRect.y2 - contentRect.y2;
	}
	function get_leftSpacing(){
		return contentRect.x - marginRect.x;
	}
	function get_rightSpacing(){
		return marginRect.x2 - contentRect.x2;
	}
	function get_verticalSpacing(){
		return marginRect.height - contentRect.height;
	}
	function get_horizontalSpacing(){
		return marginRect.width - contentRect.width;
	}

	/**
	 * Flag that this element needs a re-sync (and re-draw) next frame
	 */
	public function invalidate(){
		needResync = true;
	}

	/**
	 * Called by the parent to (re)position this canvas within the supplied rect. 
	 * @param sibling	The previous sibling (for relative positioning)
	 * @param rect 		The area available within the parent
	 */
	public function update( r : Rect ){
		this.parentRect.from(r);
		elementRect.from(r);

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
					// Ignore 'floating' elements which are not statically positioned
					if (c.position != Absolute) sibling = c;
				}
			}
			if (sibling!=null){
				// Move element down below the sibling
				// XXX: Different layouts. At the moment only vertical stacking
				var dy : Float = (sibling.y + sibling.rect.height) - this.parentRect.y;
				if (dy>0){
					elementRect.y += dy;
					elementRect.height = Math.max(0,elementRect.height - dy);
				}
				// Adjust for margin collapse
				if (this.margin.collapse || sibling.margin.collapse){
					// Get this top margin and sibling bottom margin
					var tm : Float = margin.top.get(parentRect.width,parentRect.height,ctx.scene.width,ctx.scene.height);
					var bm : Float = sibling.margins.bottom;
					elementRect.y -= Math.min(tm,bm);
					elementRect.height += Math.min(tm,bm);
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
		var l : Float = left.get(parentRect.width,parentRect.height,ctx.scene.width,ctx.scene.height);
		var t : Float = top.get(parentRect.width,parentRect.height,ctx.scene.width,ctx.scene.height);
		var b : Float = bottom.get(parentRect.width,parentRect.height,ctx.scene.width,ctx.scene.height);
		var r : Float = right.get(parentRect.width,parentRect.height,ctx.scene.width,ctx.scene.height);
		var w : Float = width.get(parentRect.width,parentRect.height,ctx.scene.width,ctx.scene.height);
		var h : Float = height.get(parentRect.width,parentRect.height,ctx.scene.width,ctx.scene.height);

		// Left is set...
		if (!left.undefined){
			// Set left
			marginRect.x = elementRect.x + l;
			// Both left and right are set. Ignore width
			if (!right.undefined) marginRect.width = elementRect.width - l - r;
			// Left and width are set. Use width (but limit to parent area)
			else if (!width.undefined) marginRect.width = Math.max(0,Math.min(w,elementRect.width - l));
			// Otherwise fill from left to edge (100%)
			else marginRect.width = elementRect.width - l;
		}
		// Right is set...
		else if (!right.undefined){
			// Right and width are set. Use width (but limit to parent area)
			if (!width.undefined) marginRect.width = Math.max(0,Math.min(w,elementRect.width - r));
			// Otherwise fill from right to edge (100%)
			else marginRect.width = elementRect.width - r;
			// Set left
			marginRect.x = elementRect.x2 - r - marginRect.width;
		}
		// Neither left or right, but width is set..
		else if (!width.undefined){
			// Set left
			marginRect.x = elementRect.x;
			// Use width (but limit to parent area)
			marginRect.width = Math.min(w,elementRect.width);
		}
		// Nothing set...
		else{
			// Set left
			marginRect.x = elementRect.x;
			// Set full width (100%)
			marginRect.width = elementRect.width;
		}

		// Top is set...
		if (!top.undefined){
			// See top
			marginRect.y = elementRect.y + t;
			// Both top and bottom are set. Ignore height
			if (!bottom.undefined) marginRect.height = elementRect.height - t - b;
			// Top and height are set. Use height (but limit to parent area)
			else if (!height.undefined) marginRect.height = Math.max(0,Math.min(h,elementRect.height - t));
			// Otherwise fill from top to edge (100%)
			else marginRect.height = elementRect.height - t;
		}
		// Bottom is set...
		else if (!bottom.undefined){
			// Top and height are set. Use height (but limit to parent area)
			if (!height.undefined) marginRect.height = Math.max(0,Math.min(h,elementRect.height - b));
			// Otherwise fill from bottom to edge (100%)
			else marginRect.height = elementRect.height - b;
			// Set top
			marginRect.y = elementRect.y2 - b - marginRect.height;
		}
		// Neither top or bottom, but height is set..
		else if (!height.undefined){
			// Set top
			marginRect.y = elementRect.y;
			// Use height (but limit to parent area)
			marginRect.height = Math.min(h,elementRect.height);
		}
		// Nothing set...
		else{
			// Set top
			marginRect.y = elementRect.y;
			// Set full width (100%)
			marginRect.height = elementRect.height;
		}

		// Position this element
		this.x = marginRect.x;
		this.y = marginRect.y;
		marginRect.x = 0;
		marginRect.y = 0;

		// Update areas
		borderRect.from( marginRect );
		margin.shrinkRect( borderRect, parentRect.width,parentRect.height,ctx.scene.width,ctx.scene.height);
		paddingRect.from( borderRect );
		border.shrinkRect( paddingRect, parentRect.width,parentRect.height,ctx.scene.width,ctx.scene.height);
		contentRect.from( paddingRect );
		padding.shrinkRect( contentRect, parentRect.width,parentRect.height,ctx.scene.width,ctx.scene.height);
		marginSides.top = borderRect.y - marginRect.y;
		marginSides.right = marginRect.x2 - borderRect.x2;
		marginSides.left = borderRect.x - marginRect.x;
		marginSides.bottom = marginRect.y2 - borderRect.y2;
	}

	/**
	 * Sync operations based on updating the children
	 */
	function sync_children( ctx:RenderContext ){
		// Update the children
		for (child in children){
			if (Std.is(child,Canvas)) cast(child,Canvas).update( contentRect );
		}
	}

	/**
	 * The content rect may have changed, so do any final repositioning based on that.
	 * @param ctx 
	 */
	function sync_reposition( ctx:RenderContext ){
		// Update areas based on content
		paddingRect.from( contentRect );
		padding.growRect( paddingRect, parentRect.width,parentRect.height,ctx.scene.width,ctx.scene.height);
		borderRect.from( paddingRect );
		border.growRect( borderRect, parentRect.width,parentRect.height,ctx.scene.width,ctx.scene.height);
		marginRect.from( borderRect );
		margin.growRect( marginRect, parentRect.width,parentRect.height,ctx.scene.width,ctx.scene.height);
		marginSides.top = borderRect.y - marginRect.y;
		marginSides.right = marginRect.x2 - borderRect.x2;
		marginSides.left = borderRect.x - marginRect.x;
		marginSides.bottom = marginRect.y2 - borderRect.y2;

		// Update the background
		background.update( paddingRect );

		// Update the border
		border.update( borderRect );
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

}