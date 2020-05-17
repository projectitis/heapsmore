package m2d.ui;

import h2d.col.Point;
import m2d.ui.Dimension;

/**
 * Position for UI elements that defines and X and Y coordinate, with min/max constraints. Uses a
 * Dimension for each value, which means it supports relative values too (e.g. '50%' or '33.33vh')
 */
class Position{

	/**
	 * X ccordinate
	 */
	public var x : Dimension = new Dimension();

	/**
	 * Y coordinate
	 */
	public var y : Dimension = new Dimension();

	/**
	 * Callback when size changes
	 */
	public var onChange : Void -> Void = null;

	/**
	 * Constructor
	 */
	public function new(){
		x.onChange = changed;
		y.onChange = changed;
	}

	function changed(){
		if (onChange != null){
			var callback : Void -> Void = onChange;
			onChange = null;
			callback();
			onChange = callback;
		}
	}

	/**
	 * Shorthand for unsetting both x and y
	 */
	public function unset(){
		var callback : Void -> Void = onChange;
		onChange = null;

		x.unset();
		y.unset();

		if (callback != null) callback();
		onChange = callback;
	}

	/**
	 * Return the position as a point
	 * @return Point	The calculated position
	 */
	public function getPos( pw : Float, ph : Float, vw : Float, vh : Float ) : Point{
		return new Point( x.get( pw, ph, vw, vh ), y.get( pw, ph, vw, vh ) );
	}

}