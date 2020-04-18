package m2d.ui;

import h2d.Drawable;
import m2d.ui.Box;
import h2d.Font;
import h2d.RenderContext;
import h2d.Tile;
import h2d.TileGroup;

/**
 * Text alignment options.
 */
enum Align {
	Left;
	Right;
	Center;
	Justify;
	JustifyRight;
	JustifyCenter;
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
 * An improved TextArea class. features:
 *		Justify alignment
 *		Clipping
 *		Better text wrap
 *		Auto-width, auto-height, or fixed size
 */
class TextArea extends Box{

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
	public var color(default,set) : Int = 0;

	/**
	 * The text alignment
	 */
	public var align(default,set) : Align = Align.Left;

	/**
	 * Automatically adjust width while keeping height fixed. If both are set, will make the text area
	 * as big as required to fit the full text.
	 */
	public var autoWidth : Bool = true;

	/**
	 * Automatically adjust height while keeping width fixed. If both are set, will make the text area
	 * as big as required to fit the full text.
	 */
	public var autoHeight : Bool = true;

	/**
	 * Additional spacing between lines
	 */
	public var lineSpacing(default,set) : Int = 0;

	/**
	 * processed text with wrapping
	 */
	var lines : Array<TextLine> = null;

	/**
	 * Maximum width of processed text
	 */
	var linesWidth : Float = 0;

	/**
	 * Maximum height of processed text
	 */
	var linesHeight : Float = 0;

	/**
	 * The rendered characters
	 */
	var glyphs : TileGroup = null;

	/**
	 * Flag to indicate that text calculations needs to update
	 */
	var needsUpdate : Bool = false;

	/**
	 * Flag to indicate that text nees to be redrawn
	 */
	var needsRedraw : Bool = true;

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
		glyphs.visible = false;
		lines = null;
		needsUpdate = true;
		return v;
	}

	/**
	 * Set the text. This also invalidates the wrapped text
	 */
	function set_text( v : String ) : String{
		if (text!=v){
			text = v;
			lines = null;
			needsUpdate = true;
		}
		return v;
	}

	/**
	 * Set text align
	 */
	function set_align( v : Align ) : Align{
		if (align!=v){
			align = v;
			needsUpdate = true;
		}
		return v;
	}

	/**
	 * Set line spacing
	 */
	 function set_lineSpacing( v : Int ) : Int{
		if (lineSpacing!=v){
			lineSpacing = v;
			needsUpdate = true;
		}
		return v;
	}

	/**
	 * Set color
	 */
	 function set_color( v : Int ) : Int{
		if (color!=v){
			color = v;
			needsUpdate = true;
		}
		return v;
	}

	/**
	 * Override width property so that if it is set, the autoWidth feature is disabled. 
	 */
	override function set_width( v : Float ) : Float{
		autoWidth = false;
		return super.set_width(v);
	}

	/**
	 * Override height property so that if it is set, the autoHeight feature is disabled. 
	 */
	override function set_height( v : Float ) : Float{
		autoHeight = false;
		return super.set_height(v);
	}

	/**
	 * Ensure that if someone tries to read the width that we update first
	 */
	override function borderWidth( v : Null<Float>) : Float{
		if (needsUpdate) update();
		return super.borderWidth(v);
	}

	/**
	 * Ensure that if someone tries to read the height that we update first
	 */
	override function borderHeight( v : Null<Float>) : Float{
		if (needsUpdate) update();
		return super.borderHeight(v);
	}

	/**
	 * Update everything ready for a redraw
	 */
	function update(){
		// Process text to account for wrapping
		if (lines==null){
			lines = new Array();
			linesWidth = 0;
			var mw : Int = autoWidth?2147483647:Math.floor(content.width);	// Max width
			var lw : Float = 0;					// Line width
			var ch : Null<FontChar>;			// Character
			var cc : Int = -1;					// Current character's code
			var cc_prev : Int = -1;				// Previous character's code
			var si : Int = 0;					// Start index
			var ei : Int = 0;					// End index
			var ei_wc : WrapChar = WrapOn;		// Wrap type for end index
			var ei_w : Float = 0;				// Width of line at end index
			var wc : WrapChar = WrapNone;		// Wrap type for current char
			var wc_prev : WrapChar = WrapNone;	// Wrap type for previous char
			var i = 0;
			while( i < text.length ) {
				cc_prev = cc;
				wc_prev = wc;
				cc = text.charCodeAt(i);
				wc = getWrapChar(cc);
//trace('$i: ${String.fromCharCode(cc)}');
				// Increase width by character stride if glyph exists
				ch = font.getChar(cc);
				if (ch!=null) lw += ch.width + ch.getKerningOffset(cc_prev);
				// Mark line ending if we should
				if (wc_prev==WrapNone) {
					if (wc!=WrapNone){
						ei = i;
						ei_wc = wc;
						ei_w = lw;
//trace('  Set line end (last was WrapNone, this is not)');
					}
				}
				else if (wc_prev==WrapAfter) {
					ei = i;
					ei_wc = WrapBefore;
					ei_w = lw - ((ch!=null)?(ch.width + ch.getKerningOffset(cc_prev)):0);
//trace('  Set line end (last was WrapAfter)');
				}
				if (((lw>mw) && (ei>0)) || (wc == WrapAlways)){
					// Wrap here
//trace('    Line from $si to $ei. ei_wc is $ei_wc, wc is $wc');
					lines.push( new TextLine( text.substring(si,ei), ei_w, (ei_wc==WrapAlways) ) );
					linesWidth = Math.max(linesWidth,ei_w);
					// Determine next character to start from
					if ((ei_wc==WrapAlways) || (ei_wc==WrapOn)) i = ei+1;
					else i = ei;
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
			// Rest of string
			if ((i-1)>si){
//trace('    Remaining line from $si to $i');				
				lines.push( new TextLine( text.substring(si,i), lw, true) );
				linesWidth = Math.max(linesWidth,lw);
			}
			// Calculate text width and height (note: last line doesn't have line spacing applied)
			linesHeight = lines.length * (font.lineHeight + lineSpacing) - lineSpacing;
			if (autoWidth) content.width = linesWidth;
			if (autoHeight) content.height = linesHeight;
		}
//for (l in lines) trace(l.text+'\t\t'+l.width);
//trace('Width: ${Math.ceil(content.width)} Height:${Math.ceil(content.height)}');
		needsUpdate = false;
		needsRedraw = true;
	}

	/**
	 * Return true if character is a character that we can break on
	 * @param c 	The character code
	 * @return Bool	True if whitespace
	 */
	 function getWrapChar( c : Int ) : WrapChar {
		if (c=='\n'.code) return WrapAlways;
		if ((c=='-'.code) || (c=='+'.code) || (c=='='.code) || (c=='.'.code) || (c==','.code) || (c=='/'.code) || (c=='\\'.code)) return WrapAfter;
		//if ((c=='('.code) || (c=='['.code) || (c=='{'.code) || (c=='<'.code)) return WrapBefore;
		if ((c<33) || (c==127)) return WrapOn;
		return WrapNone;
	}

	/**
	 * Called to redraw all glyph tiles
	 */
	function redraw(){
		glyphs.clear();
		glyphs.setDefaultColor( color, 1 );
		var mw : Float = Math.floor(content.width);		// Max width
		var mh : Float = Math.floor(content.height);	// Max height
		var x : Float;
		var y : Float = -8;
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
		// Step lines
		for (line in lines){
			x = 0;
			i = 0;
			cc = -1;
			tdw = 0;
			// Adjust start x based on alignment 
			js = 0;
			switch (align){
				case Right: x = mw - line.width;
				case Center: x = (mw - line.width) / 2;
				case Justify: {
					if (!line.natural) js = (mw - line.width) / numSpaces(line.text);
				}
				case JustifyRight: {
					if (line.natural) x = mw - line.width;
					else js = (mw - line.width) / numSpaces(line.text);
				}
				case JustifyCenter: {
					if (line.natural) x = (mw - line.width) / 2;
					else js = (mw - line.width) / numSpaces(line.text);
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
			}
			y += font.lineHeight + lineSpacing;
			if (y>=mh) break; // If overflow y, stop
		}
	}

	/**
	 * Return the number of spaces in the string
	 * @param s 	The string
	 * @return Int	The number of spaces
	 */
	function numSpaces( s : String ) : Int{
		var c : Int = 0;
		for (i in 0...s.length) if (StringTools.fastCodeAt(s,i)==' '.code) c++;
trace('$c spaces found');
		return c;
	}

	/**
	 * Called by system when TextArea is redrawn
	 */
	override function draw(ctx:RenderContext) {
		if (needsUpdate) update();
		if (!needsRedraw) return;
		if (font==null) return;

		redraw();

		glyphs.x = border.left.size + padding.left;
		glyphs.y = border.top.size + padding.top;
		glyphs.draw( ctx );
		glyphs.visible = true;

		needsRedraw = false;
	}

}