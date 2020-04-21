package m2d.ui;

import h2d.Graphics;
import h2d.Object;
import h2d.RenderContext;

/**
 * css-style box model. Box is very similar to an HTML 'div'.
 * 	Margin
 * 		Border
 * 			Padding
 * 				Content
 * The reference position and size is based on border (like css box-model:border-box). So, if you get box.width
 * it will be the width of the content, padding and border. If you position the box using x and y, it will be
 * positioned based on the top-left corner of the border.
 * Box is intended as a super class to be extended. Call redraw to update the graphics elements of Box (border
 * and background).
 */
class Box extends Object{

	/**
	 * User width
	 */
	var w : Float = 0;

	/**
	 * User height
	 */
	var h : Float = 0;

	/**
	 * Top anchor for positioning
	 */
	var top(default,set) : Null<Float> = null;

	/**
	 * Right anchor for positioning
	 */
	var right(default,set) : Null<Float> = null;

	/**
	 * Bottom anchor for positioning
	 */
	var bottom(default,set) : Null<Float> = null;

	 /**
	  * Left anchor for positioning
	  */
	var left(default,set) : Null<Float> = null;

	/**
	 * The margins of the box.
	 * The margins sit outside the border and determine the spacing between Boxes.
	 */
	public var margin : SideRect = new SideRect();

	/**
	 * The borders of the box.
	 * The border sits outside the padding. Each side has a size and a color.
	 */
	public var border : Borders = new Borders();

	/**
	 * The radius for the corners of background and border. Currently buggy with
	 * background image (ok with background color)
	 */
	public var cornerRadius(default,set) : Float = 0;
	
	/**
	 * The padding of the box. Adjust these directly, or use the padding_ methods.
	 * The padding provides space around the content area. It sits between the content
	 * and the border.
	 */
	public var padding : SideRect = new SideRect();

	/**
	 * The content area of the box. Adjust this directly, or use the content_ methods.
	 * This holds the actual content of the box. The usual behaviour is that no visual
	 * content extends outside this area - i.e. the contents are clipped to this area.
	 */
	public var content : Area = new Area();

	/**
	 * The background of the box (covers padding)
	 */
	public var background : Background = new Background();

	/**
	 * Width of border+padding+content (not margin)
	 **/
	public var width(get,set) : Float;

	/**
	 * Height of border+padding+content (not margin)
	 **/
	public var height(get,set) : Float;

	/**
	 * Set a maximum width limit (includes content+padding+border)
	 **/
	public var maxWidth(default,set) : Null<Float> = null;

	 /**
	 * Set a minimum width limit (includes content+padding+border)
	 **/
	public var minWidth(default,set) : Null<Float> = null;

	/**
	 * Set a maximum height limit (includes content+padding+border)
	 **/
	public var maxHeight(default,set) : Null<Float> = null;

	/**
	 * Set a minimum height limit (includes content+padding+border)
	 **/
	public var minHeight(default,set) : Null<Float> = null;

	/**
	 * The graphics object to draw the background to
	 */
	var backgroundCanvas : Graphics;

	/**
	 * The graphics object to draw the border to
	 */
	var borderCanvas : Graphics;

	/**
	 * Flag to indicate parameters have changed and a redraw is required
	 */
	var boxNeedsRedraw : Bool = false;

	/**
	 * Create a new box
	 * @param width 	Width of box
	 * @param height 	Height of box
	 **/
	public function new( ?width : Float, ?height : Float, ?parent : Object ){
		super(parent);
		backgroundCanvas = new Graphics( this );
		borderCanvas = new Graphics( this );
		content.onChange = contentChange;
		padding.onChange = boxChange;
		border.onChangeSize = boxChange;
		background.onChange = bgChange;
		content.setSize( width, height );

	}

	function set_cornerRadius( v : Float ) : Float{
		if (cornerRadius!=v){
			cornerRadius = hxd.Math.max(0,v);
			boxNeedsRedraw = true;
		}
		return v;
	}

	/**
	 * MIN and MAX
	 */
	function set_maxWidth( v : Float ) : Float{
		if (maxWidth!=v){
			maxWidth = hxd.Math.max(0,v);
			contentChange(); // Force resize to apply new limit
		}
		return v;
	}
	function set_minWidth( v : Float ) : Float{
		if (minWidth!=v){
			minWidth = hxd.Math.max(0,v);
			contentChange(); // Force resize to apply new limit
		}
		return v;
	}
	function set_maxHeight( v : Float ) : Float{
		if (maxHeight!=v){
			maxHeight = hxd.Math.max(0,v);
			contentChange(); // Force resize to apply new limit
		}
		return v;
	}
	function set_minHeight( v : Float ) : Float{
		if (minHeight!=v){
			minHeight = hxd.Math.max(0,v);
			contentChange(); // Force resize to apply new limit
		}
		return v;
	}

	/**
	 * Positioning
	 */
	function set_top( v : Null<Float> ) : Null<Float>{
		if (this.top != v){
			this.top = v;
			positionChange();
		}
		return v;
	}
	function set_right( v : Null<Float> ) : Null<Float>{
		if (this.right != v){
			this.right = v;
			positionChange();
		}
		return v;
	}
	function set_bottom( v : Null<Float> ) : Null<Float>{
		if (this.bottom != v){
			this.bottom = v;
			positionChange();
		}
		return v;
	}
	function set_left( v : Null<Float> ) : Null<Float>{
		if (this.left != v){
			this.left = v;
			positionChange();
		}
		return v;
	}

	/**
	 * The size of the content has changed directly
	 **/
	function contentChange(){
		var callback : Void -> Void = content.onChange; content.onChange = null; // Ensure we don't recurse

		// Content size has been changed. Ensure size ok
		var ex : Float = padding.left + padding.right + border.left.size + border.right.size;
		var v : Float = content.width;
		if ((minWidth!=null) && ((v+ex) < minWidth)) v = minWidth-ex;
		if ((maxWidth!=null) && ((v+ex) > maxWidth)) v = Math.max(0,maxWidth-ex);
		content.width = v;
		w = v + ex;

		ex = padding.top + padding.bottom + border.top.size + border.bottom.size;
		v = content.height;
		if ((minHeight!=null) && ((v+ex) < minHeight)) v = minHeight-ex;
		if ((maxHeight!=null) && ((v+ex) > maxHeight)) v = Math.max(0,maxHeight-ex);
		content.height = v;
		h = v + ex;

		content.onChange = callback;
		boxNeedsRedraw = true;
	}
	/**
	 * The size of the box (padding, border) has changed, so adjust content according to w,h
	 */
	function boxChange(){
		var callback : Void -> Void = content.onChange; content.onChange = null; // Ensure we don't recurse

		// Content size has been changed. Ensure size ok
		var ex : Float = padding.left + padding.right + border.left.size + border.right.size;
		var v : Float = w - ex;
		if ((minWidth!=null) && ((v+ex) < minWidth)) v = minWidth-ex;
		if ((maxWidth!=null) && ((v+ex) > maxWidth)) v = Math.max(0,maxWidth-ex);
		content.width = v;

		ex = padding.top + padding.bottom + border.top.size + border.bottom.size;
		v = h - ex;
		if ((minHeight!=null) && ((v+ex) < minHeight)) v = minHeight-ex;
		if ((maxHeight!=null) && ((v+ex) > maxHeight)) v = Math.max(0,maxHeight-ex);
		content.height = v;

		content.onChange = callback;
		boxNeedsRedraw = true;
	}

	/**
	 * Called when the background is changed
	 */
	function bgChange(){
		boxNeedsRedraw = true;
	}

	/**
	 * Called when the position is updated
	 */
	function positionChange(){

	}

	/**
	 * BORDER methods
	 **/
	function get_width() : Float{
		return content.width + padding.left + padding.right + border.left.size + border.right.size;
	}
	function set_width( v : Float ) : Float{
		content.width = v - (padding.left + padding.right + border.left.size + border.right.size);
		w = content.width;
		return v;
	}
	function get_height() : Float{
		return content.height + padding.top + padding.bottom + border.top.size + border.bottom.size;
	}
	function set_height( v : Float ) : Float{
		content.height = v - (padding.top + padding.bottom + border.top.size + border.bottom.size);
		h = content.height;
		return v;
	}

	/**
	 * Draw the border and background
	 * XXX: Border
	 */
	function boxRedraw(){
		border.drawTo( borderCanvas, width, height, cornerRadius );

		backgroundCanvas.x = border.left.size;
		backgroundCanvas.y = border.top.size;
		background.drawTo( backgroundCanvas, content.width+padding.left+padding.right, content.height+padding.top+padding.bottom, cornerRadius );

		boxNeedsRedraw = false;
	}
	override function draw(ctx:RenderContext) {
		super.draw(ctx);
		if (boxNeedsRedraw) boxRedraw();
	}

}