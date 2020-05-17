package m2d.ui;

import h2d.col.Point;
import m2d.ui.Dimension;
import m2d.ui.Position;

/**
 * Position for UI elements that defines and X and Y coordinate with a scroll offset, each with min/max constraints.
 * Uses a Dimension for X and Y, which means it supports relative values too (e.g. '50%' or '33.33vh'). The scroll
 * offset is always absolute in pixels.
 */
class ScrollPosition extends Position{

	/**
	 * The amount of horizontal scroll
	 */
	public var scrollX(default,set) : Float = 0;

	/**
	 * The amount of vertical scroll
	 */
	public var scrollY(default,set) : FLoat = 0;

	public function new(){
		super();
	}

	override function changed(){
		if (x.undefined) scrollX = 0;
		if (y.undefined) scrollY = 0;
		super.changed();
	}

	function set_scrollX( v : Float ) : Float{
		scrollX = v;
		changed();
		return v;
	}

	function set_scrollY( v : Float ) : Float{
		scrollY = v;
		changed();
		return v;
	}

	/**
	 * Scroll by an amount
	 * @param dx 	The amount of horizontal scroll
	 * @param dy 	The amount of vertical scroll
	 */
	public function scroll( ?dx : Number, ?dy : Number, ?p : Point ){
		if (p!=null){
			scrollX += p.x;
			scrollY += p.y;
		}
		else{
			scrollX += dx;
			scrollY += dy;
		}
		changed();
	}

	/**
	 * Set the scroll offsets
	 * @param dx 	The amount of horizontal scroll
	 * @param dy 	The amount of vertical scroll
	 */
	 public function setScroll( ?dx : Number, ?dy : Number, ?p : Point ){
		if (p!=null){
			scrollX = p.x;
			scrollY = p.y;
		}
		else{
			scrollX = dx;
			scrollY = dy;
		}
		changed();
	}

	/**
	 * Return the scroll offset as a point
	 * @return Point	The scroll offset
	 */
	public function getScroll() : Point{
		return new Point( scrollX, scrollY );
	}

	/**
	 * Return the position 
	 * Calculate and return the value
	 * @param pw 	The parent width
	 * @param ph 	The parent height
	 * @param vw 	The viewport width
	 * @param vh 	The viewport height
	 * @return Point	The position, including scroll
	 */
	override public function getPos( pw : Float, ph : Float, vw : Float, vh : Float ) : Point{
		var px : Float = x.getWithoutBounds( pw, ph, vw, vh ) + scrollX;
		var py : Float = y.getWithoutBounds( pw, ph, vw, vh ) + scrollY;
		if (x.hasMin()) px = Math.max( x.min.get( pw, ph, vw, vh ), px );
		if (x.hasMax()) px = Math.min( x.max.get( pw, ph, vw, vh ), px );
		if (y.hasMin()) py = Math.max( y.min.get( pw, ph, vw, vh ), py );
		if (y.hasMax()) py = Math.min( y.max.get( pw, ph, vw, vh ), py );
		return new Point( px, py );
	}

	/**
	 * Calls super.getPos' to return the pos without scroll offsets.
	 * @param pw 	The parent width
	 * @param ph 	The parent height
	 * @param vw 	The viewport width
	 * @param vh 	The viewport height
	 * @return Point	The position, without scroll
	 */
	public function getPosWithoutScroll( pw : Float, ph : Float, vw : Float, vh : Float ) : Point{
		return super.getPos( pw, ph, vw, vh );
	}


}