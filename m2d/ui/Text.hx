package m2d.ui;

import h2d.col.Point;
import h2d.Graphics;
import h2d.Drawable;
import h2d.Font;
import h2d.RenderContext;
import h2d.Tile;
import h2d.TileGroup;
import m2d.ui.Canvas;
import mxd.UIApp;

using StringTools;
using mxd.tools.StringTools;

/**
 * Text alignment options.
 */
enum Align {
	Left;			// Left align
	Right;			// Right align
	Center;			// Center align
	Justify;		// Justify. Partial lines align left
	JustifyRight;	// Justify. Partial lines align right
	JustifyCenter;	// Justify. Partial lines align center
	JustifyFull;	// Justify all lines
}

/**
 * Used internally to classify how to wrap a character
 */
private enum WrapChar {
	WrapNone;	// Do not wrap on this character. e.g. 'A' or 'a'
	WrapAlways;	// Always wrap to next line on this character. e.g. '\n'
	WrapOn;		// Wrap on this character and ignore it. e.g. ' ' or '\t'
	WrapBefore; // Wrap before this character. e.g. '(' 
	WrapAfter;	// Wrap after this character. e.g. '-'
}

/**
 * Used internally to split text into lines based on wrapping
 */
private class TextLine {
	public var text : String;		// the text of this line
	public var width : Float;		// The pixel width of this line
	public var natural : Bool;		// True if this line was naturally wrapped (false if it was forced)

	public function new( text : String, width : Float, natural : Bool ){
		this.text = text;
		this.width = width;
		this.natural = natural;
	}
}

/**
 * Text class
 * Todo:
 * 		Implement scrollH, scrollY, maxScrollH, maxScrollY (see h2d.Mask)
 * 		Change clipping to use mask? Ready for scroll
 */
class Text extends Canvas{

	/**
	 * The font to use
	 */
	public var font(default,set) : Font;

	/**
	 * The text to render
	 */
	public var text(default,set) : String = '';

	/**
	 * The text color
	 */
	public var textColor(default,set) : Int = 0;

	/**
	 * The text alignment
	 */
	public var align(default,set) : Align = Left;

	/**
	 * Get or set the height of the text area in lines of text using the current font and line spacing.
	 * If setting the height this way, ensure that the font, the lines spacing, and the padding and border
	 * have already been set. When getting the height, partial lines are counted (so 12 and-a-bit lines
	 * will return 13).
	 */
	public var heightInLines(get,set) : Int;

	/**
	 * Automatically adjust width while keeping height fixed. If both are set, will make the text area
	 * as big as required to fit the full text.
	 */
	public var autoWidth : Bool = false;

	/**
	 * Automatically adjust height while keeping width fixed. If both are set, will make the text area
	 * as big as required to fit the full text.
	 */
	public var autoHeight : Bool = false;

	/**
	 * Additional spacing between lines. Based on the font lineHeight (1=default)
	 */
	public var lineSpacing(default,set) : Float = 1;

	/**
	 * Additional spacing between characters in pixels. Default is 0
	 */
	public var characterSpacing(default,set) : Float = 0;

	var lines : Array<TextLine> = null;	// processed text with wrapping
	var linesWidth : Float = 0;			// Maximum width of processed text
	var linesHeight : Float = 0;		// Maximum height of processed text
	var glyphs : TileGroup = null;		// The rendered characters
	var ctx : RenderContext = null;

	/**
	 * Create a new TextField instance
	 * @param font 		The font to use
	 * @param parent 	The parent object
	 */
	public function new( ?font : Font, ?parent : h2d.Object ) {
		super(parent);
		this.font = font;
	}

	/**
	 * Set or change the font
	 */
	function set_font( v : Font ) : Font{
		if (font == v) return v;
		if (font!=null){
			if (glyphs!=null) glyphs.remove();
		}
		font = v;
		glyphs = new TileGroup( (font==null)?null:font.tile, this );
		lines = null;
		invalidate();
		return v;
	}
	/*
	function setFontByName( name : String ){
		font = UIApp.getFont(name);
	}
	*/

	/**
	 * Set the text. This also invalidates the wrapped text
	 */
	function set_text( v : String ) : String{
		if (text!=v){
			text = v;
			lines = null;
			invalidate();
		}
		return v;
	}

	/**
	 * Set text align
	 */
	function set_align( v : Align ) : Align{
		align = v;
		invalidate();
		return v;
	}

	/**
	 * Set line spacing
	 */
	function set_lineSpacing( v : Float ) : Float{
		lineSpacing = v;
		invalidate();
		return v;
	}

	/**
	 * Set character spacing
	 */
	function set_characterSpacing( v : Float ) : Float{
		characterSpacing = v;
		invalidate();
		return v;
	}

	/**
	 * Set text color
	 */
	function set_textColor( v : Int ) : Int{
		textColor = v;
		invalidate();
		return v;
	}

	/**
	 * Get height of content in lines
	 */
	function get_heightInLines() : Int{
		if (needResync) sync_main( ctx );
		var ls : Float = font.lineHeight*(lineSpacing-1);	// Line spacing
		var ch : Float = contentRect.height + ls;		
		return Math.ceil(ch / (font.lineHeight+ls));
	}

	/**
	 * Set the height of content in lines
	 */
	function set_heightInLines( v : Int ) : Int{
		var ls : Float = font.lineHeight*(lineSpacing-1);	// Line spacing
		height.set( v * (font.lineHeight+ls) - ls + verticalSpacing );
		return v;
	}

	/**
	 * Update everything ready for a redraw. Only called if invalidated
	 */
	override function sync_main( ctx : RenderContext ){
		this.ctx = ctx;

		// Process text to account for wrapping
		lines = new Array();
		linesWidth = 0;
		var mw : Int = Math.floor(contentRect.width);
		if (autoWidth && width.hasMax()){
			mw = Math.floor(width.getMax(parentRect.width,parentRect.height,ctx.scene.width,ctx.scene.height));
		}
trace('    mw: $mw');
		var ls : Float = font.lineHeight*(lineSpacing-1);	// Line spacing
		var cs : Float = characterSpacing;	// Additional character spacing
		var lw : Float = 0;					// Line width
		var lw_prev : Float;				// Line width at previous character
		var ch : Null<FontChar>;			// Character
		var cc : Int = -1;					// Current character's code
		var cc_prev : Int = -1;				// Previous character's code
		var si : Int = 0;					// Start index
		var ei : Int = 0;					// End index
		var ei_wc : WrapChar = WrapOn;		// Wrap type for end index
		var ei_w : Float = 0;				// Width of line at end index
		var wc : WrapChar = WrapNone;		// Wrap type for current char
		var wc_prev : WrapChar = WrapNone;	// Wrap type for previous char
		var skip : Bool = false;
		var i = 0;
		while( i < text.length ) {
			cc_prev = cc;
			wc_prev = wc;
			cc = text.charCodeAt(i);
			wc = getWrapChar(cc);
//trace('$i: ${String.fromCharCode(cc)}');

			// If we've just wrapped, we might skip whitespace at the start of the line
			if (skip){
				if (wc==WrapOn){
					i++;
					si = i;
					continue;
				}
				else if (wc==WrapAlways){
					i++;
					si = i;
					ei = i;
					skip = false;
					continue;
				}
				skip = false;
			}

			// Increase width by character stride if glyph exists
			ch = font.getChar(cc);
			lw_prev = lw;
			if (ch!=null){
				if (lw>0) lw += cs; // Only between characters
				lw += ch.width + ch.getKerningOffset(cc_prev);
			}

			// Mark possible line ending. This happens if this character is a new
			// possible wrap point, or if the previous character was a possible wrap point.
			if (((wc_prev==WrapNone) && (wc!=WrapNone) && (wc!=WrapAfter)) || (wc_prev==WrapAfter)) {
				ei = i;
				ei_wc = wc;
				ei_w = lw_prev;
//trace('  Set line end (last was $wc_prev, this is $wc)');
			}

			// If we've reached maximum width, it's time to wrap
			if (((lw>mw) && (ei>0)) || (wc == WrapAlways)){
				// Wrap here. The last character width should be the width of the glyph, not the whole stride
//trace('    Line from $si to $ei. ei_wc is $ei_wc, wc is $wc');
				lines.push( new TextLine( text.substring(si,ei), ei_w, (ei_wc==WrapAlways) ) );
				linesWidth = Math.max(linesWidth,ei_w);
				// Determine next character to start from
				if ((ei_wc==WrapAlways) || (ei_wc==WrapOn)) i = ei+1;
				else i = ei;
				if (ei_wc==WrapAfter) skip = true;
				si = i;
				lw = 0;
				ei = 0;
				ei_w = 0;
//trace('      Next start at $si');
				wc = WrapNone;
				continue;
			}
			i++;
		} // step chars

		// Rest of string if we haven't hit the maximum width but no chars left
		if ((i-1)>si){
//trace('    Remaining line from $si to $i');				
			lines.push( new TextLine( text.substring(si,i), lw, true) );
			linesWidth = Math.max(linesWidth,lw);
		}

		// Calculate text width and height (note: last line doesn't have line spacing applied)
		linesHeight = lines.length * (font.lineHeight + ls) - ls;
		if (autoWidth) contentRect.width = linesWidth;
		if (autoHeight) contentRect.height = linesHeight;

		needRedraw = true;
	}

	/**
	 * Return true if character is a character that we can break on
	 * @param c 	The character code
	 * @return Bool	True if whitespace
	 */
	 function getWrapChar( c : Int ) : WrapChar {
		if (c=='\n'.code) return WrapAlways;

		if ('-+=.,/\\)]}>'.contains(c)) return WrapAfter;
		if ('([{<'.contains(c)) return WrapBefore;
		if ((c<33) || (c==127)) return WrapOn;
		return WrapNone;
	}

	/**
	 * Called to redraw all glyph tiles. Only called if the element is invalidated.
	 */
	override function draw_post( ctx : RenderContext ){
		glyphs.clear();
		if (font==null) return;

		glyphs.setDefaultColor( textColor, 1 );
		var ls : Float = font.lineHeight*(lineSpacing-1);	// Line spacing
		var mw : Float = Math.floor(contentRect.width);			// Max width
		var mh : Float = Math.floor(contentRect.height);		// Max height
		var x : Float;
		var y : Float = 0;
		var cs : Float = 0; 		// Character spacing 
		var js : Float = 0;			// Justify spacing
		var cc : Int;				// Character's code
		var cc_prev : Int;			// Previous character's code
		var ch : Null<FontChar>; 	// Character
		var ko : Float;				// kerning offset
		var i : Int;
		var t : Tile;				// For partial tiles
		var tdx : Float = 0;		// Difference in tile x
		var tdy : Float = 0;		// Difference in tile y
		var tdw : Float = 0;		// Difference in tile width
		var tdh : Float = 0;		// Difference in tile height
		var ns : Int = 0;			// Number of spaces
		// Step lines
		for (line in lines){
			x = 0;
			i = 0;
			cc = -1;
			tdw = 0;
			cs = characterSpacing;
			// Adjust start x based on alignment 
			js = 0;
			switch (align){
				case Right: x = mw - line.width;
				case Center: x = (mw - line.width) / 2;
				case Justify: {
					if (!line.natural){
						ns = line.text.count(' '.code);
						if (ns==0) cs = (mw - line.width) / (line.text.length-1);
						else js = (mw - line.width) / ns;
					}
				}
				case JustifyRight: {
					if (line.natural) x = mw - line.width;
					else{
						ns = line.text.count(' '.code);
						if (ns==0) cs = (mw - line.width) / (line.text.length-1);
						else js = (mw - line.width) / ns;
					}
				}
				case JustifyCenter: {
					if (line.natural) x = mw - line.width;
					else{
						ns = line.text.count(' '.code);
						if (ns==0) cs = (mw - line.width) / (line.text.length-1);
						else js = (mw - line.width) / ns;
					}
				}
				case JustifyFull: {
					ns = line.text.count(' '.code);
					if (ns==0) cs = (mw - line.width) / (line.text.length-1);
					else js = (mw - line.width) / ns;
				}
				default: {}
			}
			// Step characters in line
			for( i in 0...line.text.length ){
				cc_prev = cc;
				cc = line.text.charCodeAt(i);
				ch = font.getChar(cc);
				if (ch!=null){
					ko = ch.getKerningOffset(cc_prev);
					x += ko;
					tdx = tdy = tdw = tdh = 0;
					// Check for partial x
					if (x<0){
						// Entirely out of view. Skip to next character
						if ((x+ch.t.dx+ch.t.width)<=0){
							x += ch.width;
							continue;
						}
						// Partial character
						else{
							tdx = tdw = -x - ch.t.dx;
						}
					}
					else if ((x+ch.t.dx+ch.t.width)>mw){
						tdw = x+ch.t.dx+ch.t.width - mw;
					}
					// Check for partial y
					if (y<0){
						// Entirely out of view. Skip to next character
						if ((y+font.lineHeight)<=0){
							x += ch.width;
							continue;
						}
						// Partial character
						else{
							tdy = tdh = -y - ch.t.dy;
						}
					}
					if ((y+ch.t.dy+ch.t.height)>mh){
						tdh = y+ch.t.dy+ch.t.height - mh;
					}
					// Add partial tile
					if ((tdw>0) || (tdh>0)){
						t = ch.t.clone();
						t.dx += tdx; t.dy += tdy;
						t.setPosition( t.x+tdx, t.y+tdy );
						t.setSize( t.width-tdw, t.height-tdh );
						glyphs.add( Math.round(x), Math.round(y), t);
					}
					// Add full tile
					else{
						glyphs.add( Math.round(x), Math.round(y), ch.t);
					}
					x += ch.width;
					if (cc == ' '.code) x += js;
					if (x>=mw) break; // If overflow x, skip to next line
				}
				x += cs;
			}
			y += font.lineHeight + ls;
			if (y>=mh) break; // If overflow y, stop
		}

		// Position glyphs at to exact pixel
		var p : Point = new Point( contentRect.x, contentRect.y );
		this.localToGlobal( p );
		p.x = Math.round(p.x);
		p.y = Math.round(p.y);
		this.globalToLocal( p );
		glyphs.x = p.x;
		glyphs.y = p.y;
		// Then draw
		glyphs.draw( ctx );
	}

}