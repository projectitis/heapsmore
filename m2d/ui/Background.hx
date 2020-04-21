package m2d.ui;

import h2d.Graphics;
import h2d.Tile;

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
class Background{

	/**
	 * The background color as RGB. If an image is set, this is below the image. The color
	 * can be RGB or ARGB. If there is no A component (or it is 0) the color will be fully
	 * opaque. To make the color fully transparent, set color to null;
	 */
	public var color(default,set) : Null<Int> = null;

	/**
	 * The background alpha. This applies to the entire background, including the color and
	 * the image. Note that the color and the image may already have seperate alpha values
	 * as well.
	 */
	 public var alpha(default,set) : Float = 1;
 
	/**
	 * Flag to switch background on or off
	 */
	public var visible(default,set) : Bool = false;

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

	/**
	 * Callback when something changes
	 */
	public var onChange : Void -> Void = null;

	/**
	 * Constructor stub
	 */
	public function new(){}

	/**
	 * Shorthand for setting the color and alpha. Note the alpha will also apply to the image (if set).
	 * Any values that are null will be ignored and current value used. Will also set visible to true.
	 * @param color 	The color
	 * @param alpha 	The alpha
	 */
	public function setColor( color : Null<Int>, alpha : Null<Float> = null ){
		var callback : Void -> Void = onChange; onChange = null; // prevent callback until the end
		if (color != null) this.color = color;
		if (alpha != null) this.alpha = alpha;
		visible = true;
		onChange = callback;
		if (onChange != null) onChange();
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
		var callback : Void -> Void = onChange; onChange = null; // prevent callback until the end
		if (image != null) this.image = image;
		if (size != null) this.imageSize = size;
		if (width != null) this.imageWidth = width;
		if (height != null) this.imageHeight = height;
		if (position != null) this.imagePositionH = this.imagePositionV = position;
		if (x != null) this.imageX = x;
		if (y != null) this.imageY = y;
		visible = true;
		onChange = callback;
		if (onChange != null) onChange();
	}

	/**
	 * Setters
	 */
	function set_color( v : Null<Int> ) : Null<Int>{
		if (v==null) color =  null;
		else color = v;
		changed();
		return v;
	}
	function set_alpha( v : Float ) : Float{
		alpha = (v<0)?0:(v>1)?1:v;
		changed();
		return v;
	}
	function set_visible( v : Bool ) : Bool{
		visible = v;
		changed();
		return v;
	}
	function set_image( v : Tile ) : Tile{
		image = v;
		changed();
		return v;
	}
	function set_imageAlpha( v : Float ) : Float{
		imageAlpha = (v<0)?0:(v>1)?1:v;
		changed();
		return v;
	}
	function set_imageSize( v : BackgroundSize ) : BackgroundSize{
		imageSize = v;
		changed();
		return v;
	}
	function set_imageWidth( v : Float ) : Float{
		imageWidth = v;
		changed();
		return v;
	}
	function set_imageHeight( v : Float ) : Float{
		imageHeight = v;
		changed();
		return v;
	}
	function set_imagePositionH( v : BackgroundPosition ) : BackgroundPosition{
		imagePositionH = v;
		changed();
		return v;
	}
	function set_imagePositionV( v : BackgroundPosition ) : BackgroundPosition{
		imagePositionV = v;
		changed();
		return v;
	}
	function set_imageX( v : Float ) : Float{
		imageX = v;
		changed();
		return v;
	}
	function set_imageY( v : Float ) : Float{
		imageY = v;
		changed();
		return v;
	}
	function set_imageRepeat( v : Bool ) : Bool{
		imageRepeat = v;
		changed();
		return v;
	}
	inline function changed(){
		if (onChange!=null){
			var callback : Void -> Void = onChange;
			onChange = null;
			callback();
			onChange = callback;
		}
	}

	/**
	 * Draw the background onto the canvas at the specified width and height 
	 * @param canvas 	The Graphics object to draw to
	 * @param width 	The width of the background
	 * @param height 	The height of the background
	 */
	public function drawTo( canvas : Graphics, width : Float, height : Float, radius : Float = 0 ) {
		canvas.clear();
		if (!visible) return;

		canvas.alpha = this.alpha;
		if (color!=null){
			var a : Float = ((color>>24) & 255)/255;
			if (a==0) a = 1;
			canvas.beginFill( color, a );
			if (radius>0) canvas.drawRoundedRect(0,0,width,height,radius);
			else canvas.drawRect(0,0,width,height);
			canvas.endFill();
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
					sx = sy = Math.min(width/image.width, height/image.height);
					w = image.width*sx;
					h = image.height*sy;
					x = calculateImagePosH( w, width );
					y = calculateImagePosV( h, height );
				}
				case Fill: {
					sx = sy = Math.max(width/image.width, height/image.height);
					w  = image.width*sx;
					h  = image.height*sy;
					x  = calculateImagePosH( w, width );
					y  = calculateImagePosV( h, height );
				}
				case Normal: {
					w = calculateImageWidth();
					h = calculateImageHeight();
					sx = w/image.width;
					sy = h/image.height;
					x = calculateImagePosH( w, width );
					y = calculateImagePosV( h, height );
				}
				case Percent: {
					w = calculateImageWidthPC( width, height );
					h = calculateImageHeightPC( width, height );
					sx  = w/image.width;
					sy  = h/image.height;
					x = calculateImagePosH( w, width );
					y = calculateImagePosV( h, height );
				}
			}
			canvas.beginTileFill(x,y,sx,sy,image);
			if (imageRepeat){
				canvas.tileWrap = true;
				if (radius>0) canvas.drawRoundedRect(0,0,width,height,radius);
				else canvas.drawRect(0,0,width,height);
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
				if ((x+w)>width){
					w = width-x;
				}
				if ((y+h)>height){
					h = height-y;
				}
				canvas.tileWrap = false;
				if (radius>0) canvas.drawRoundedRect(x,y,w,h,radius);
				else canvas.drawRect(x,y,w,h);
			}
			canvas.endFill();
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