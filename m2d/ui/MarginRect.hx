package m2d.ui;

class MarginRect extends SideRect{

	/**
	 * Collapse margins to the largest one if there are two together
	 */
	public var collapse(default,set) : Bool = false;

	public function new(){
		super();
	}

	function set_collapse( v : Bool ) : Bool{
		collapse = v;
		changed();
		return v;
	}

}