package m2d.ui;

import h2d.RenderContext;
import h2d.Graphics;
import h2d.Object;
import h2d.Tile;
import h2d.col.Bounds;

/**
 * Background size options
 */
 enum BackgroundSize {
	Normal;		// Use imageWidth and imageHeight
	Percent;	// Use imageWidth and imageHeight as percentage 0.0 - 1.0
	Fill;		// Image to fill entire area with no gaps. May clip image
	Fit;		// Image to fit inside area. May result in bars
}

/**
 * Background position options
 */
enum BackgroundPosition {
	Normal;			// Use imageX and imageY as pixel values
	Percent;		// Use imageX and imageY as percentage 0.0 - 1.0
	Center;			// Image in center
	Min;			// Image on left or top
	Max;			// Image on right or bottom
}

/**
 * Background for UI elements. User drawTo to render the background to a Graphics object.
 */
class Background extends Graphics{

	/**
	 * The background color as RGB. If an image is set, this is below the image. The color
	 * can be RGB or ARGB. If there is no A component (or it is 0) the color will be fully
	 * opaque. To make the color fully transparent, set color to null;
	 */
	public var fillColor(default,set) : Null<Int> = null;

	/**
	 * The background opacity. This applies to the entire background, including the fillColor and
	 * the image. Note that the fillColor and the image may already have seperate alpha values
	 * as well.
	 */
	public var opacity(get,set) : Float;

	/**
	 * Background image. Set to null to display no image
	 */
	public var image(default,set) : Tile = null;

	/**
	 * Background image alpha. XXX: Not yet supported
	 */
	public var imageAlpha(default,set) : Float = 1;

	/**
	 * Background image size
	 */
	public var imageSize(default,set) : BackgroundSize = Normal;

	/**
	 * If imageSize = Normal, set width of image in pixels. If width is 0, will be auto-calculated.
	 * If imageSize = Percent, set width of image in percentage of natural width (1.0 = 100%)
	 */
	public var imageWidth(default,set) : Float = 0;

	/**
	 * If imageSize = Normal, set height of image in pixels. If height is 0, will be auto-calculated.
	 * If imageSize = Percent, set height of image in percentage of natural height (1.0 = 100%)
	 */
	public var imageHeight(default,set) : Float = 0;

	/**
	 * Type of image positioning to use horizontally
	 */
	public var imagePositionH(default,set) : BackgroundPosition = Center;

	/**
	 * Type of image positioning to use vertically
	 */
	public var imagePositionV(default,set) : BackgroundPosition = Center;

	/**
	 * If imagePositionH = Normal, set X position of image in pixels
	 * If imagePositionH = Percent, set X position of image in percentage of background width (1.0 = 100%)
	 */
	public var imageX(default,set) : Float = 0;

	/**
	 * If imagePositionV = Normal, set Y position of image in pixels
	 * If imagePositionV = Percent, set Y position of image in percentage of background width (1.0 = 100%)
	 */
	public var imageY(default,set) : Float = 0;

	/**
	 * Background image
	 */
	public var imageRepeat(default,set) : Bool = false;

	var bounds : Bounds = new Bounds(); // Area covered by background
	var needRedraw : Bool = true; // Redraw flag

	/**
	 * Constructor stub
	 */
	public function new( ?parent : Object ){
		super( parent );
	}

	/**
	 * Shorthand for setting the color and alpha. Note the alpha will also apply to the image (if set).
	 * Any values that are null will be ignored and current value used. Will also set visible to true.
	 * @param color 	The color
	 * @param alpha 	The alpha
	 */
	public function setFillColor( color : Null<Int>, alpha : Null<Float> = null ){
		if (color != null) this.fillColor = color;
		if (alpha != null) this.alpha = alpha;
		visible = true;
		invalidate();
	}

	/**
	 * Shorthand for setting background image. Will also set visible to true. To set different
	 * H and V positions, use the imagePositionH and imagePositionV properties directly. Any null
	 * values will be ignored and current value used.
	 * @param tile 		The image tile. if null, will keep current image.
	 * @param size 		The size type
	 * @param width 	The width, if size is Normal or Percent
	 * @param height 	The height, if size is Normal or Percent
	 * @param position 	The position type for both H and V
	 * @param x 		The x position, if position is Normal or Percent
	 * @param y 		The y position, if position is Normal or Percent
	 */
	public function setImage( image : Tile, size : BackgroundSize = null, width : Null<Float> = null, height : Null<Float> = null, position : Null<BackgroundPosition> = null, x : Null<Float> = null, y : Null<Float> = null ){
		if (image != null) this.image = image;
		if (size != null) this.imageSize = size;
		if (width != null) this.imageWidth = width;
		if (height != null) this.imageHeight = height;
		if (position != null) this.imagePositionH = this.imagePositionV = position;
		if (x != null) this.imageX = x;
		if (y != null) this.imageY = y;
		visible = true;
		invalidate();
	}

	/**
	 * Setters
	 */
	function set_fillColor( v : Null<Int> ) : Null<Int>{
		if (fillColor != v){
			fillColor = v;
			invalidate();
		}
		return v;
	}
	function set_opacity( v : Float ) : Float{
		alpha = v;
		invalidate();
		return v;
	}
	function get_opacity() : Float{
		return alpha;
	}
	override function set_visible( v : Bool ) : Bool{
		super.set_visible(v);
		invalidate();
		return v;
	}
	function set_image( v : Tile ) : Tile{
		if (image != v){
			image = v;
			invalidate();
		}
		return v;
	}
	function set_imageAlpha( v : Float ) : Float{
		if (imageAlpha != v){
			imageAlpha = hxd.Math.clamp(v);
			invalidate();
		}
		return v;
	}
	function set_imageSize( v : BackgroundSize ) : BackgroundSize{
		if (imageSize != v){
			imageSize = v;
			invalidate();
		}
		return v;
	}
	function set_imageWidth( v : Float ) : Float{
		if (imageWidth != v){
			imageWidth = v;
			invalidate();
		}
		return v;
	}
	function set_imageHeight( v : Float ) : Float{
		if (imageHeight != v){
			imageHeight = v;
			invalidate();
		}
		return v;
	}
	function set_imagePositionH( v : BackgroundPosition ) : BackgroundPosition{
		if (imagePositionH != v){
			imagePositionH = v;
			invalidate();
		}
		return v;
	}
	function set_imagePositionV( v : BackgroundPosition ) : BackgroundPosition{
		if (imagePositionV!=v){
			imagePositionV = v;
			invalidate();
		}
		return v;
	}
	function set_imageX( v : Float ) : Float{
		if (imageX != v){
			imageX = v;
			invalidate();
		}
		return v;
	}
	function set_imageY( v : Float ) : Float{
		if (imageY != v){
			imageY = v;
			invalidate();
		}
		return v;
	}
	function set_imageRepeat( v : Bool ) : Bool{
		if (imageRepeat != v){
			imageRepeat = v;
			invalidate();
		}
		return v;
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
	public function update( r : Bounds ){
		this.bounds.load(r);
		this.x = this.bounds.x;
		this.y = this.bounds.y;

		invalidate();
	}

	/**
	 * Draw the background at the specified width and height 
	 * @param ctx	The render context
	 */
	override public function draw( ctx : RenderContext ) {
		super.draw( ctx );
		if (!needRedraw) return;
		needRedraw = false;

		this.clear();
		if (!visible) return;
		if (bounds.isEmpty()) return;

		// XXX: Make radius editable
		// XXX: Change to top-radius, left-radius etc
		var radius : Float = 0;

		if (fillColor!=null){
			var a : Float = ((fillColor>>24) & 255)/255;
			if (a==0) a = 1;
			this.beginFill( fillColor, a );
			if (radius>0) this.drawRoundedRect(0,0,bounds.width,bounds.height,radius);
			else this.drawRect(0,0,bounds.width,bounds.height);
			this.endFill();
		}
		if (image!=null){
			var sx : Float;
			var sy : Float;
			var w : Float;
			var h : Float;
			var x : Float;
			var y : Float;
			switch (imageSize){
				case Fit: {
					sx = sy = Math.min(bounds.width/image.width, bounds.height/image.height);
					w = image.width*sx;
					h = image.height*sy;
					x = calculateImagePosH( w, bounds.width );
					y = calculateImagePosV( h, bounds.height );
				}
				case Fill: {
					sx = sy = Math.max(bounds.width/image.width, bounds.height/image.height);
					w  = image.width*sx;
					h  = image.height*sy;
					x  = calculateImagePosH( w, bounds.width );
					y  = calculateImagePosV( h, bounds.height );
				}
				case Normal: {
					w = calculateImageWidth();
					h = calculateImageHeight();
					sx = w/image.width;
					sy = h/image.height;
					x = calculateImagePosH( w, bounds.width );
					y = calculateImagePosV( h, bounds.height );
				}
				case Percent: {
					w = calculateImageWidthPC( bounds.width, bounds.height );
					h = calculateImageHeightPC( bounds.width, bounds.height );
					sx  = w/image.width;
					sy  = h/image.height;
					x = calculateImagePosH( w, bounds.width );
					y = calculateImagePosV( h, bounds.height );
				}
			}
			this.beginTileFill(x,y,sx,sy,image);
			if (imageRepeat){
				this.tileWrap = true;
				if (radius>0) this.drawRoundedRect(0,0,bounds.width,bounds.height,radius);
				else this.drawRect(0,0,bounds.width,bounds.height);
			}
			else{
				if (x<0){
					w += x;
					x = 0;
				}
				if (y<0){
					h += y;
					y = 0;
				}
				if ((x+w)>bounds.width){
					w = bounds.width-x;
				}
				if ((y+h)>bounds.height){
					h = bounds.height-y;
				}
				this.tileWrap = false;
				if (radius>0) this.drawRoundedRect(x,y,w,h,radius);
				else this.drawRect(x,y,w,h);
			}
			this.endFill();
		}
	}

	function calculateImagePosH( iw : Float, w : Float ) : Float{
		switch (imagePositionH){
			// Left align
			case Min: return 0;
			// Right align
			case Max: return w-iw;
			// Center
			case Center: return (w - iw) / 2;
			// Pixel position
			case Normal: return imageX;
			// Percentage
			case Percent: return (w - iw) * ((imageX<0)?0:(imageX>1)?1:imageX);
		}
	}

	function calculateImagePosV( ih : Float, h : Float ) : Float{
		switch (imagePositionV){
			// Top align
			case Min: return 0;
			// Bottom align
			case Max: return h-ih;
			// Center
			case Center: return (h - ih) / 2;
			// Pixel position
			case Normal: return imageY;
			// Percentage
			case Percent: return (h - ih) * ((imageY<0)?0:(imageY>1)?1:imageY);
		}
	}

	function calculateImageWidth() : Float{
		if (imageWidth>0) return imageWidth;
		if (imageHeight>0) return image.width/image.height*imageHeight;
		return image.width;
	}

	function calculateImageHeight() : Float{
		if (imageHeight>0) return imageHeight;
		if (imageWidth>0) return image.height/image.width*imageWidth;
		return image.height;
	}

	function calculateImageWidthPC( w : Float, h : Float ) : Float{
		if (imageWidth>0) return imageWidth * w;
		if (imageHeight>0) return (imageHeight * h) * (image.width/image.height);
		return image.width;
	}

	function calculateImageHeightPC( w : Float, h : Float ) : Float{
		if (imageHeight>0) return imageHeight * h;
		if (imageWidth>0) return (imageWidth * w) * (image.height/image.width);
		return image.height;
	}

}