package m2d.ui;

import haxe.DynamicAccess;
import h2d.Graphics;
import h2d.Object;
import h2d.RenderContext;
import hxd.Math;
import mxd.Param;
import mxd.UIApp;

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
	 * Width, height
	 */
	var w : Param;
	var h : Param;

	/**
	 * Positioning
	 */
	var t : Param;
	var b : Param;
	var l : Param;
	var r : Param;

	/**
	 * Top anchor for positioning
	 */
	var top(get,set) : Float;

	/**
	 * Right anchor for positioning
	 */
	var right(get,set) : Float;

	/**
	 * Bottom anchor for positioning
	 */
	var bottom(get,set) : Float;

	 /**
	  * Left anchor for positioning
	  */
	var left(get,set) : Float;

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
	public var maxWidth(get,set) : Null<Float>;

	 /**
	 * Set a minimum width limit (includes content+padding+border)
	 **/
	public var minWidth(get,set) : Null<Float>;

	/**
	 * Set a maximum height limit (includes content+padding+border)
	 **/
	public var maxHeight(get,set) : Null<Float>;

	/**
	 * Set a minimum height limit (includes content+padding+border)
	 **/
	public var minHeight(get,set) : Null<Float>;

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
		w = new Param(parent);
		h = new Param(parent);
		t = new Param(parent);
		b = new Param(parent);
		l = new Param(parent);
		r = new Param(parent);
		backgroundCanvas = new Graphics( this );
		borderCanvas = new Graphics( this );
		content.onChange = sizeChanged;
		padding.parent = this;
		padding.onChange = sizeChanged;
		border.parent = this;
		border.onChangeSize = sizeChanged;
		margin.parent = this;
		background.onChange = bgChanged;
		content.setSize( width, height );
	}

	/**
	 * Hook function to get new parent
	 */
	override function onAdd() {
		super.onAdd();
		w.parent = parent;
		h.parent = parent;
		t.parent = parent;
		r.parent = parent;
		b.parent = parent;
		l.parent = parent;
		padding.parent = parent;
		margin.parent = parent;
		border.parent = parent;
		sizeChanged();
	}

	/**
	 * Corner radius
	 */
	function set_cornerRadius( v : Float ) : Float{
		if (cornerRadius!=v){
			cornerRadius = Math.max(0,v);
			boxNeedsRedraw = true;
		}
		return v;
	}

	/**
	 * MIN and MAX
	 */
	function get_maxWidth() : Null<Float>{
		return this.w.maxValue;
	}
	function set_maxWidth( v : Null<Float> ) : Null<Float>{
		this.w.setMaxValue( v );
		sizeChanged();
		return v;
	}
	function get_minWidth() : Null<Float>{
		return this.w.minValue;
	}
	function set_minWidth( v : Null<Float> ) : Null<Float>{
		this.w.setMinValue( v );
		sizeChanged();
		return v;
	}
	function get_maxHeight() : Null<Float>{
		return this.h.maxValue;
	}
	function set_maxHeight( v : Null<Float> ) : Null<Float>{
		this.h.setMaxValue( v );
		sizeChanged();
		return v;
	}
	function get_minHeight() : Null<Float>{
		return this.h.minValue;
	}
	function set_minHeight( v : Null<Float> ) : Null<Float>{
		this.h.setMinValue( v );
		sizeChanged();
		return v;
	}

	/**
	 * Positioning
	 */
	function get_top() : Null<Float>{
		return this.t.value;
	}
	function set_top( v : Null<Float> ) : Null<Float>{
		this.t.setValue(v);
		positionChanged();
		return v;
	}
	function get_right() : Null<Float>{
		return this.r.value;
	}
	function set_right( v : Null<Float> ) : Null<Float>{
		this.r.setValue(v);
		positionChanged();
		return v;
	}
	function get_bottom() : Null<Float>{
		return this.b.value;
	}
	function set_bottom( v : Null<Float> ) : Null<Float>{
		this.b.setValue(v);
		positionChanged();
		return v;
	}
	function get_left() : Null<Float>{
		return this.l.value;
	}
	function set_left( v : Null<Float> ) : Null<Float>{
		this.l.setValue(v);
		positionChanged();
		return v;
	}

	/**
	 * The size of the box (padding, border) has changed, so adjust content according to w,h
	 */
	function sizeChanged(){
		var callback : Void -> Void = content.onChange; content.onChange = null; // Ensure we don't recurse

		// Content size has been changed. Ensure size ok
		content.width = Math.max( 0, this.w.value-(padding.left + padding.right + border.left.size + border.right.size) );
		content.height = Math.max( 0, this.h.value-(padding.top + padding.bottom + border.top.size + border.bottom.size) );

		content.onChange = callback;
		boxNeedsRedraw = true;
	}

	/**
	 * Called when the background is changed
	 */
	function bgChanged(){
		boxNeedsRedraw = true;
	}

	/**
	 * Called when the position is updated
	 */
	function positionChanged(){

	}

	/**
	 * WIDTH and HEIGHT
	 **/
	function get_width() : Float{
		return content.width + padding.left + padding.right + border.left.size + border.right.size;
	}
	function set_width( v : Float ) : Float{
		this.w.setValue(v);
		sizeChanged();
		return v;
	}
	function get_height() : Float{
		return content.height + padding.top + padding.bottom + border.top.size + border.bottom.size;
	}
	function set_height( v : Float ) : Float{
		this.h.setValue(v);
		sizeChanged();
		return v;
	}
	/**
	 * Set the width. Alternative to setting width directly, but supports widths with units
	 * @param v 	If supplied, the width in pixels
	 * @param s 	If supplied, the width in any supported unit. See mxd.Param for supported units.
	 */
	public function setWidth( ?v : Float, ?s : String ){
		this.w.setValue(v,s);
		sizeChanged();
	}
	public function setHeight( ?v : Float, ?s : String ){
		this.h.setValue(v,s);
		sizeChanged();
	}


	/**
	 * Set the properties of theis UI object from data (usually JSON). Normal usage is something like:
	 * `var data : haxe.DynamicAccess<Dynamic> = haxe.Json.parse( jsonText );`
	 * `myBox.fromData( data );`
	 * This UI object supports the following properties:
	 * 		width, height				250, "50%"
	 * 		x, y						250, "50%"
	 * 		top, left, right, bottom	250, "50%"
	 * 		maxWidth, maxHeight			250, "50%"
	 * 		minWidth, minHeight			250, "50%"
	 * 		alpha						0.0 - 1.0
	 * 		background (see m2d.ui.Background)
	 * 		padding (see m2d.SideRect)
	 * 		border (see m2d.Borders)
	 * 		margin (see m2d.SideRect)
	 * @param data 		The data
	 */
	public function fromData( data : haxe.DynamicAccess<Dynamic> ){
		var callback : Void -> Void = content.onChange; content.onChange = null; // Ensure we don't recurse

		// Apply style data to this object
		this.applyStyle( data );

		// Create children
		if (data.exists('children')){
			var children : Array<DynamicAccess<Dynamic>> = data.get('children');
			for (child in children){
				if (!child.exists('type')) throw('Property \'type\' not found');
				switch (cast(child.get('type'),String)){
					case 'Box':
						var b : Box = new Box( this );
						b.fromData( child );
					case 'TextArea':
						var t : TextArea = new TextArea( this );
						t.fromData( child );
						trace('width: ${t.width}, height: ${t.height}');
				}
			}
		}

		content.onChange = callback;
		sizeChanged();
	}

	/**
	 * This method does the actual work of applying the style data to this object. Subclasses should
	 * override this (but call super.applyStyle first).
	 * @param data 		The data
	 */
	function applyStyle( data : haxe.DynamicAccess<Dynamic> ){
		if (data == null) return;

		var t : Dynamic;
		var s : String;
		var f : Float;

		if (data.exists('style')){
			var styles : Array<String> = cast(data.get('style'),String).split(',');
			for (name in styles){
				this.applyStyle(UIApp.getStyle( StringTools.trim(name) ));
			}
		}
		if (data.exists('alpha')) this.alpha = Std.parseFloat(cast(data.get('alpha'),String));
		if (data.exists('visible')) this.visible = cast(data.get('visible'),String).toLowerCase()=='true';
		if (data.exists('rotation')){
			t = data.get('rotation');
			if (Std.is(t,Int) || Std.is(t,Float)) this.rotation = cast(t,Float);
			else{
				s = cast(t,String);
				if (s.substr(-3)=='deg') this.rotation = Math.degToRad( Std.parseFloat(s.substr(0,s.length-3)) );
				else if (s.substr(-3)=='rad') this.rotation = Std.parseFloat(s.substr(0,s.length-3));
				else this.rotation = Std.parseFloat(s);
			}
		}
		if (data.exists('scale')) this.scale( Std.parseFloat(cast(data.get('scale'),String)) );
		if (data.exists('scale-x')) this.scaleX = Std.parseFloat(cast(data.get('scale-x'),String));
		if (data.exists('scale-y')) this.scaleY = Std.parseFloat(cast(data.get('scale-y'),String));
		if (data.exists('x')) this.l.setValue( cast(data.get('x'),String) );
		if (data.exists('y')) this.t.setValue( cast(data.get('y'),String) );
		if (data.exists('top')) this.t.setValue( cast(data.get('top'),String) );
		if (data.exists('right')) this.r.setValue( cast(data.get('right'),String) );
		if (data.exists('bottom')) this.b.setValue( cast(data.get('bottom'),String) );
		if (data.exists('left')) this.l.setValue( cast(data.get('left'),String) );
		if (data.exists('width')) this.w.setValue(cast(data.get('width'),String));
		if (data.exists('max-width')) this.w.setMaxValue(cast(data.get('max-width'),String));
		if (data.exists('min-width')) this.w.setMinValue(cast(data.get('min-width'),String));
		if (data.exists('height')) this.h.setValue(cast(data.get('height'),String));
		if (data.exists('max-height')) this.h.setMaxValue(cast(data.get('max-height'),String));
		if (data.exists('min-height')) this.h.setMinValue(cast(data.get('min-height'),String));
		if (data.exists('background')) this.background.fromData( data.get('background') );
		if (data.exists('padding')) this.padding.fromData( data.get('padding') );
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