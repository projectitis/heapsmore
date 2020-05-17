package m2d;

import h2d.col.Point;
import h2d.Graphics;

class Cable extends Graphics{

	public var cableThickness(default, set) : Float = 5;

	public var cableColor(default, set) : Int = 0xff9900;

	public var cableAlpha(default, set) : Float = 1;

	public var shadow(default, set) : Bool = true;

	public var shadowColor(default, set) : Int = 0x000000;

	public var shadowAlpha(default, set) : Float = 0.25;

	public var cableShaded(default, set) : Bool = false;

	/**
	 * User callback. Triggered when any render properties change (such as color), but not if
	 * the cable is moved.
	 */
	public var onChange : Void->Void;

	/**
	 * User callback. Triggered when start or end are changed (cable is moved). Not called if
	 * render properties such as color change.
	 */
	 public var onMove : Void->Void;

	/**
	 * Enter a maximum length for the cable, in pixels, or 0 for a cable
	 * that will extend to whatever length is required.
	 */
	public var cableLength : Float = 0;

	var p1 : Point;
	var p2 : Point;

	/**
	 * Set the coordinates of the start of the cable
	 * @param x 	X coordinate
	 * @param y 	Y coordinate	
	 */
	public function setStart( x : Float, y : Float ){
		p1.set( x,y );
	}

	/**
	 * Set the coordinates of the end of the cable. If the cable is not long enough
	 * to reach, it will move as far toward this point as possible.
	 * @param x 	X coordinate
	 * @param y 	Y coordinate	
	 */
	public function setEnd( x : Float, y : Float ) {
		p2.set( x,y );
	}

	function set_cableColor( v : Int ) : Int {
		
		return v;
	}



}