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
	 * Same as border.width. Change size of content while keeping x,y the same
	 **/
	public var width(get,set) : Float;

	/**
	 * Same as border.height. Change size of content while keeping x,y the same
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
		content.onWidth = this.contentWidth;
		content.onHeight = this.contentHeight;
		padding.onWidth = this.paddingWidth;
		padding.onHeight = this.paddingHeight;
		border.onWidth = this.borderWidth;
		border.onHeight = this.borderHeight;
		padding.onWidth = this.marginWidth;
		padding.onHeight = this.marginHeight;
		content.set( width, height );
		super(parent);
	}

	/**
	 * MIN and MAX
	 */
	function set_maxWidth( v : Float ) : Float{
		if (maxWidth!=v){
			maxWidth = (v<0)?0:v;
			width = width; // Force resize to apply new limit
		}
		return v;
	}
	function set_minWidth( v : Float ) : Float{
		if (minWidth!=v){
			minWidth = (v<0)?0:v;
			width = width; // Force resize to apply new limit
		}
		return v;
	}
	function set_maxHeight( v : Float ) : Float{
		if (maxHeight!=v){
			maxHeight = (v<0)?0:v;
			height = height; // Force resize to apply new limit
		}
		return v;
	}
	function set_minHeight( v : Float ) : Float{
		if (minHeight!=v){
			minHeight = (v<0)?0:v;
			height = height; // Force resize to apply new limit
		}
		return v;
	}

	/**
	 * CONTENT callbacks
	 **/
	function contentWidth( v : Null<Float> ) : Float{
		if (v==null){
			// getter
			return content.width;
		}
		else{
			// setter
			var ew : Float = padding.left + padding.right + border.left.size + border.right.size;
			var w : Float = v;
			if ((minWidth!=null) && ((w+ew) < minWidth)) w = minWidth-ew;
			if ((maxWidth!=null) && ((w+ew) > maxWidth)) w = Math.max(0,maxWidth-ew);
			content.width = (w<0)?0:w;
			return v;
		}
	}
	function contentHeight( v : Null<Float> ) : Float{
		if (v==null){
			// getter
			return content.height;
		}
		else{
			// setter. Apply max- min- height limits
			var eh : Float = padding.top + padding.bottom + border.top.size + border.bottom.size;
			var h : Float = v;
			if ((minHeight!=null) && ((h+eh) < minHeight)) h = minHeight-eh;
			if ((maxHeight!=null) && ((h+eh) > maxHeight)) h = Math.max(0,maxHeight-eh);
			content.height = (h<0)?0:h;
			return v;
		}
	}

	/**
	 * PADDING callbacks
	 **/
	function paddingWidth( v : Null<Float> ) : Float{
		if (v==null){
			// getter
			return content.width + padding.left + padding.right;
		}
		else{
			// setter
			content.width = v - padding.left - padding.right;
			return v;
		}
	}
	function paddingHeight( v : Null<Float> ) : Float{
		if (v==null){
			// getter
			return content.height + padding.top + padding.bottom;
		}
		else{
			// setter
			content.height = v - padding.top - padding.bottom;
			return v;
		}
	}

	/**
	 * BORDER methods
	 **/
	function get_width() : Float{
		return border.width;
	}
	function set_width( v : Float ) : Float{
		border.width = v;
		return v;
	}
	function get_height() : Float{
		return border.height;
	}
	function set_height( v : Float ) : Float{
		border.height = v;
		return v;
	}
	function borderWidth( v : Null<Float>) : Float{
		if (v==null){
			// Getter
			return padding.width + border.left.size + border.right.size;
		}
		else{
			// Setter
			var cv : Float = v;
			if (maxWidth!=null) cv = Math.min(maxWidth,cv);
			if (minWidth!=null) cv = Math.max(minWidth,cv);
			content.width = cv - padding.left - padding.right - border.left.size - border.right.size;
			return v;
		}
	}
	function borderHeight( v : Null<Float>) : Float{
		if (v==null){
			// Getter
			return padding.height + border.top.size + border.bottom.size;
		}
		else{
			// Setter
			var cv : Float = v;
			if (maxHeight!=null) cv = Math.min(maxHeight,cv);
			if (minHeight!=null) cv = Math.max(minHeight,cv);
			content.height = cv - padding.top - padding.bottom - border.top.size - border.bottom.size;
			return v;
		}
	}

	/**
	 * MARGIN getters and setters
	 **/
	function marginWidth( v : Null<Float>) : Float{
		if (v==null){
			// Getter
			return border.width + margin.left + margin.right;
		}
		else{
			// Setter
			content.width = v - padding.left - padding.right - border.left.size - border.right.size - margin.left - margin.right;
			return v;
		}
	}
	function marginHeight( v : Null<Float>) : Float{
		if (v==null){
			// Getter
			return border.height + margin.top + margin.bottom;
		}
		else{
			// Setter
			content.height = v - padding.top - padding.bottom - border.top.size - border.bottom.size - margin.top - margin.bottom;
			return v;
		}
	}

}