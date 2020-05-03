package m2d.ui;

import hxd.Math;
import m2d.ui.Dimension;

class BorderDimension extends Dimension{

	/**
	 * Color of this dimension
	 */
	public var color(default,set) : Int;

	/**
	 * Alpha of this dimension
	 */
	public var alpha(default,set) : Float = 1;

	public function new(){
		super();
	}

	function set_color( v : Int ):Int{
		color = v;
		changed();
		return v;
	}

	function set_alpha( v : Float ):Float{
		alpha = Math.clamp(v);
		changed();
		return v;
	}

}