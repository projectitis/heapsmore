package m2d.ui;

import h2d.Object;
import m2d.ui.BoxArea;
import m2d.ui.BoxRect;
import m2d.ui.BoxColorRect;

/**
 * css-style box model
 * 	Margin
 * 		Border
 * 			Padding
 * 				Content
 * In most cases, the reference position and size is based on border (like css box-model:border-box). So, if
 * you get box.width it will be the width of the content, padding and border. If you position the box using x
 * and y, it will be positioned based on the top-left corner of the border.
 * Box only contains values and does not do any rendering of it's own. The sub-class (or other) is responsible
 * for that.
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
	 * The margins of the box. Adjust these directly, or use the margin_ methods.
	 * The margins sit outside the border and determine the spacing between Boxes.
	 */
	public var margin : BoxRect = new BoxRect();

	/**
	 * The borders of the box. Adjust these directly, or use the border_ methods.
	 * The border sits outside the padding. Each side has a size and a color.
	 */
	public var border : BoxColorRect = new BoxColorRect();

	/**
	 * The padding of the box. Adjust these directly, or use the padding_ methods.
	 * The padding provides space around the content area. It sits between the content
	 * and the border.
	 */
	public var padding : BoxRect = new BoxRect();

	/**
	 * The content area of the box. Adjust this directly, or use the content_ methods.
	 * This holds the actual content of the box. The usual behaviour is that no visual
	 * content extends outside this area - i.e. the contents are clipped to this area.
	 */
	public var content : BoxArea = new BoxArea();

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
	 * Create a new box
	 * @param width 	Width of box
	 * @param height 	Height of box
	 **/
	public function new( ?width : Float, ?height : Float, ?parent : Object ){
		content.onChange = contentChange;
		padding.onChange = boxChange;
		border.onChangeSize = boxChange;
		content.setSize( width, height );
		super(parent);
	}

	/**
	 * MIN and MAX
	 */
	function set_maxWidth( v : Float ) : Float{
		if (maxWidth!=v){
			maxWidth = (v<0)?0:v;
			contentChange(); // Force resize to apply new limit
		}
		return v;
	}
	function set_minWidth( v : Float ) : Float{
		if (minWidth!=v){
			minWidth = (v<0)?0:v;
			contentChange(); // Force resize to apply new limit
		}
		return v;
	}
	function set_maxHeight( v : Float ) : Float{
		if (maxHeight!=v){
			maxHeight = (v<0)?0:v;
			contentChange(); // Force resize to apply new limit
		}
		return v;
	}
	function set_minHeight( v : Float ) : Float{
		if (minHeight!=v){
			minHeight = (v<0)?0:v;
			contentChange(); // Force resize to apply new limit
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

}