package m2d.ui;

import h2d.filter.Glow;
import h2d.filter.DropShadow;
import h2d.filter.Shader;
import h2d.filter.Blur;
import h2d.RenderContext;
import h2d.col.Point;
import h2d.Graphics;
import h2d.Object;
import hxd.Math;
import mxd.tools.Easing;

class CablePoint extends Point{

	public var a : Float;

	public function new( ?x : Float = 0, ?y : Float = 0 ) {
		super( x, y );
	}
}

class Cable extends Object{

	/**
	 * Enter a maximum length for the cable, in pixels, or 0 for a cable
	 * that will extend to whatever length is required.
	 */
	public var cableLength(default, set) : Float = 0;

	 /**
	  * If the cableLength is dynamic (cableLength=0) set the minium cable length
	  */
	public var cableMinLength(default, set) : Float = 200;

	/**
	 * The thickness (diameter) of the cable. Does not alter the bending properties, just the look.
	 */
	public var cableThickness(default, set) : Float = 5;

	/**
	 * The colour of the cable
	 */
	public var cableColor(default, set) : Int = 0xff9900;

	/**
	 * The alpha of the cable. Usually fully opaque.
	 */
	public var cableAlpha(default, set) : Float = 1;

	/**
	 * The length of the plug (distance it extends toward viewer). Used for rendering shadow.
	 */
	public var plugLength(default, set) : Float = 20;

	/**
	 * The thickness (diameter) of the plug
	 */
	public var plugThickness(default, set) : Float = 10;

	/**
	 * The color of the plug
	 */
	public var plugColor(default, set) : Int = 0xc0c0c0;

	/**
	 * The alpha of the plug
	 */
	public var plugAlpha(default, set) : Float = 1;

	/**
	 * If false, cable will be flat color. If true, cable will use filter to approximate a rounded shading
	 */
	public var shading(default, set) : Bool = false;

	/**
	 * If true, cable and plug will have dropshdow
	 */
	public var shadow(default, set) : Bool = false;

	/**
	 * Shadow color (default black)
	 */
	public var shadowColor(default, set) : Int = 0x000000;

	/**
	 * Shadow transparency (default 25%)
	 */
	public var shadowAlpha(default, set) : Float = 0.25;

	/**
	 * Direction of shadow in radians (default 45deg down/right)
	 */
	public var shadowDirection(default, set) : Float = Math.PI * 0.25;

	/**
	 * User callback. Triggered when any render properties change (such as color), or
	 * if the ends are moved
	 */
	public var onChange : Void->Void;

	var shadowCanvas : Graphics;
	var plugCanvas : Graphics;
	var cableCanvas : Graphics;

	var p1 : CablePoint = new CablePoint();		// cable start (always 0,0)
	var p2 : CablePoint = new CablePoint();		// cable end
	var c1 : CablePoint = new CablePoint();		// bezier control point for cable start
	var c2 : CablePoint = new CablePoint();		// bezier control point for cable end
	var d : Float;								// distance between ends
	var cl : Float;								// actual cable length

	var needsResync : Bool = true;
	var needsRedraw : Bool = true;

	/**
	 * Constructor
	 */
	public function new( ?parent : Object ) {
		super( parent );

		shadowCanvas = new Graphics( this );
		plugCanvas = new Graphics( this );
		cableCanvas = new Graphics( this );

		shadowCanvas.filter = new Blur(2);
	}

	/**
	 * Set the coordinates of the start of the cable
	 * @param x 	X coordinate
	 * @param y 	Y coordinate	
	 */
	public function setStart( x : Float, y : Float ) {
		this.x = x;
		this.y = y;
		changed();
	}

	/**
	 * Set the coordinates of the end of the cable. If the cable is not long enough
	 * to reach, it will move as far toward this point as possible.
	 * @param x 	X coordinate
	 * @param y 	Y coordinate	
	 */
	public function setEnd( x : Float, y : Float ) {
		p2.set( x - this.x, y - this.y );
		changed();
	}

	/**
	 * Shortcut for turning on the shadow and setting all the shado properties. Note that the shadow offset
	 * is determined by the plug length (see `plugLength`)
	 * @param direction 	Shadow direction in radians
	 * @param color 		The shadow color
	 * @param alpha 		The shadow transaparency
	 */
	public function setShadow( direction : Float = Math.PI * 0.25, color : Int = 0x000000, alpha : Float = 0.25 ) {
		var cb : Void->Void = onChange;
		onChange = null;

		shadow = true;
		shadowDirection = direction;
		shadowColor = color;
		shadowAlpha = alpha;

		if ( cb != null ) cb();
		onChange = cb;
	}

	function set_cableLength( v : Float ) : Float {
		cableLength = Math.max( 0, v );
		changed();
		return v;
	}

	function set_cableMinLength( v : Float ) : Float {
		cableMinLength = Math.max( 0, v );
		changed();
		return v;
	}

	function set_cableThickness( v : Float ) : Float {
		cableThickness = Math.max( 0, v );
		changed();
		return v;
	}

	function set_cableColor( v : Int ) : Int {
		cableColor = v;
		changed();
		return v;
	}

	function set_cableAlpha( v : Float ) : Float {
		cableAlpha = Math.clamp(v);
		changed();
		return v;
	}

	function set_plugThickness( v : Float ) : Float {
		plugThickness = Math.max( 0, v );
		changed();
		return v;
	}

	function set_plugLength( v : Float ) : Float {
		plugLength = Math.max( 0, v );
		changed();
		return v;
	}

	function set_plugColor( v : Int ) : Int {
		plugColor = v;
		changed();
		return v;
	}

	function set_plugAlpha( v : Float ) : Float {
		plugAlpha = Math.clamp(v);
		changed();
		return v;
	}

	function set_shadow( v : Bool ) : Bool {
		shadow = v;
		changed();
		return v;
	}

	function set_shading( v : Bool ) : Bool {
		shading = v;
		changed();
		return v;
	}

	function set_shadowColor( v : Int ) : Int {
		shadowColor = v;
		changed();
		return v;
	}

	function set_shadowAlpha( v : Float ) : Float {
		shadowAlpha = Math.clamp(v);
		changed();
		return v;
	}

	function set_shadowDirection( v : Float ) : Float {
		shadowDirection = v;
		changed();
		return v;
	}

	function changed() {
		if ( onChange != null ) {
			var cb : Void->Void = onChange;
			onChange = null;
			cb();
			onChange = cb;
		}
		needsResync = true;
	}

	/**
	 * Calculate bezier control points for the cable
	 * @param ctx 	The render context
	 */
	override function sync( ctx:RenderContext ) {
		super.sync(ctx);

		if (needsResync) {
			needsResync = false;
			needsRedraw = true;

			// Calculate straight line length
			d = Math.sqrt( p2.x * p2.x + p2.y * p2.y );

			// Calculate direction from one end to the other
			p1.a = Math.atan2( p2.y, p2.x );
			p2.a = p1.a + Math.PI;

			// Set cable length
			cl = cableLength;

			// If the cable length is dynamic, adjust it now
			if ( cl <= 0 ) {
				cl = Math.max( cableMinLength, d * 1.5 );
			}
			// If distance is longer than the cable, limit the length
			else if ( d > cl ) {
				p2.x = Math.cos( p1.a ) * cl;
				p2.y = Math.sin( p1.a ) * cl;
				d = cl;
			}

			// Calculate angle from cable end to control points
			var ma : Float = Easing.quadraticEaseIn( p2.x / cl );
			c1.a  = Math.angleLerp( Math.PI * 0.5, p1.a, ma );
			c2.a  = Math.angleLerp( Math.PI * 0.5, p2.a, ma );

			// Now calculate control point position. The equation here has been developed through
			// trial and error to approximate how a cable would hang. It is not physically accurate,
			// but it looks ok.
			var md : Float = (0.3 + Easing.quadraticEaseIn( (cl - d) / cl ) * 0.3) * Easing.quadraticEaseOut( (cl - Math.abs(p2.y)) / cl );
			c1.x = Math.cos( c1.a ) * cl * md;
			c1.y = Math.sin( c1.a ) * cl * md;
			c2.x = p2.x + Math.cos( c2.a ) * cl * md;
			c2.y = p2.y + Math.sin( c2.a ) * cl * md;
		}
	}

	/**
	 * Draw the cable
	 * XXX: Shading
	 * @param ctx 		The render context
	 */
	override function draw( ctx:RenderContext ) {
		super.draw(ctx);

		if (needsRedraw) {
			needsRedraw = false;

			shadowCanvas.clear();
			plugCanvas.clear();
			cableCanvas.clear();
			if (!visible) return;

			// Draw shadow
			if (shadow) {
				var sx : Float = Math.cos( shadowDirection ) * plugLength;
				var sy : Float = Math.sin( shadowDirection ) * plugLength;

				shadowCanvas.alpha = shadowAlpha;

				shadowCanvas.lineStyle( plugThickness, shadowColor );
				shadowCanvas.moveTo( p2.x, p2.y );
				shadowCanvas.lineTo( sx + p2.x, sy + p2.y );
				shadowCanvas.moveTo( 0, 0 );
				shadowCanvas.lineTo( sx, sy );

				shadowCanvas.lineStyle( cableThickness, shadowColor );
				shadowCanvas.moveTo( sx, sy );
				shadowCanvas.cubicCurveTo( sx + c1.x, sy + c1.y, sx + c2.x, sx + c2.y, sx + p2.x, sy + p2.y );
				
				shadowCanvas.moveTo( 0, 0 ); // required to flush the last line!
			}

			// Draw plugs
			if (plugThickness > 0){
				plugCanvas.alpha = plugAlpha;
				plugCanvas.beginFill( plugColor );
				plugCanvas.drawCircle( 0, 0, plugThickness/2, 16 );
				plugCanvas.drawCircle( p2.x, p2.y, plugThickness/2, 16 );
				plugCanvas.endFill();
			}

			// Draw cable
			// XXX: round caps
			cableCanvas.alpha = 1; //cableAlpha;
			cableCanvas.lineStyle( cableThickness, cableColor );
			cableCanvas.moveTo( 0, 0 );
			cableCanvas.cubicCurveTo( c1.x, c1.y, c2.x, c2.y, p2.x, p2.y );

			cableCanvas.moveTo( 0, 0 ); // required to flush the last line!
		}
	}

}