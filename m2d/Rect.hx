package m2d;

import hxd.Math;

/**
 * A rectangle
 */
class Rect{
	/**
	 * X coordinate of top-left corner
	 */
	public var x(default,set) : Float;

	/**
	 * Y coordinate of top-left corner
	 */
	public var y(default,set) : Float;

	/**
	 * Width of the rect. If -ve, will be converted to +ve and the X-coord will be changed accordingly.
	 */
	public var width(default,set) : Float;

	/**
	 * Height of the rect. If -ve, will be converted to +ve and the Y-coord will be changed accordingly.
	 */
	public var height(default,set) : Float;

	/**
	 * Read only. The X coordinate of bottom-right corner (not inclusive)
	 */
	public var x2(default,null) : Float;

	/**
	 * Read only. The Y coordinate of bottom-right corner (not inclusive)
	 */
	public var y2(default,null) : Float;

	/**
	 * Allow a -ve width and height to be set
	 */
	public var allowNegative : Bool = false;

	/**
	 * Create a new rect
	 * @param x 		The X coord of the top-left corner
	 * @param y 		The Y coord of the top left corner
	 * @param width 	The width of the rect
	 * @param height 	The height of the rect
	 */
	public function new( x : Float=0, y : Float=0, width : Float=0, height : Float=0 ){
		this.set( x, y, width, height );
	}

	/**
	 * Set the dimensions of this rect
	 * @param x 		The X coord of the top-left corner
	 * @param y 		The Y coord of the top left corner
	 * @param width 	The width of the rect
	 * @param height 	The height of the rect
	 */
	public function set( x : Float=0, y : Float=0, width : Float=0, height : Float=0 ){
		if (width<0){
			this.x2 = x;
			this.width = -width;
			this.x = this.x2 + width;
		}
		else{
			this.x = x;
			this.width = width;
			this.x2 = this.x + width;
		}

		if (height<0){
			this.y2 = y;
			this.height = -height;
			this.y = this.y2 + height;
		}
		else{
			this.y = y;
			this.height = height;
			this.y2 = this.y + height;
		}
	}

	function set_x( v : Float ) : Float{
		this.x = v;
		this.x2 = this.x + this.width;
		return v;
	}
	function set_y( v : Float ) : Float{
		this.y = v;
		this.y2 = this.y + this.height;
		return v;
	}
	function set_width( v : Float ) : Float{
		if (v<0){
			if (allowNegative){
				this.x2 = this.x + v;
				this.width = -v;
				this.x = this.x2 - this.width;
			}
			else{
				this.width = 0;
				this.x2 = this.x;
			}
		}
		else{
			this.width = v;
			this.x2 = this.x + width;
		}
		return v;
	}
	function set_height( v : Float ) : Float{
		if (v<0){
			if (allowNegative){
				this.y2 = this.y + v;
				this.height = -v;
				this.y = this.y2 - this.height;
			}
			else{
				this.height = 0;
				this.y2 = this.y;
			}
		}
		else{
			this.height = v;
			this.y2 = this.y + height;
		}
		return v;
	}

	/**
	 * Check if  this rect is empty
	 * @return Bool		True if empty, otherwise false
	 */
	public function empty() : Bool{
		return (width==0) || (height==0);
	}

	/**
	 * Check if this rect contains the specified point
	 * @param x 	The x coord to check
	 * @param y 	The y coord to check
	 * @return Bool		true if the point is inside this rect, otherwise false
	 */
	public function contains( ?x : Float, ?y : Float, ?r : Rect ) : Bool{
		if (r!=null){
			return ((r.x>=this.x) && (r.y>=r.y) && (r.x2<=this.x2) && (r.y2<=this.y2));
		}
		return (x>=this.x) && (x<this.x2) && (y>=this.y) && (y<this.y2);
	}

	/**
	 * Check if the supplied rect overlaps this rect at any point
	 * @param r 		The rect
	 * @return Bool		True if there is any overlap
	 */
	public function overlaps( r : Rect ) : Bool{
		return !((this.x>=r.x2) || (r.x >= this.x2) || (this.y>=r.y2) || (r.y >= this.y2));
	}

	/**
	 * Clip this rect with the one passed in leaving the overlap
	 * @param r 	The rect
	 */
	public function intersect( r : Rect ){
		this.x = Math.max(this.x,r.x);
		this.x2 = Math.min(this.x2,r.x2);
		this.y = Math.max(this.y,r.y);
		this.y2 = Math.min(this.y2,r.y2);
		if (this.x2<this.x) this.x = this.x2 = (this.x+this.x2)*0.5;
		if (this.y2<this.y) this.y = this.y2 = (this.y+this.y2)*0.5;
		this.width = this.x2 - this.x;
		this.height = this.y2 - this.y;
	}

	/**
	 * Expand this rect to also contain the one passed in
	 * @param r 	The rect
	 */
	public function conbine( r : Rect ){
		this.x = Math.min(this.x,r.x);
		this.x2 = Math.max(this.x2,r.x2);
		this.y = Math.min(this.y,r.y);
		this.y2 = Math.max(this.y2,r.y2);
		this.width = this.x2 - this.x;
		this.height = this.y2 - this.y;
	}

	/**
	 * Copy values from another rect to this one
	 * @param r 	The rect to copy from
	 */
	public function from( r : Rect ){
		this.x = r.x;
		this.y = r.y;
		this.width = r.width;
		this.height = r.height;
		this.x2 = r.x2;
		this.y2 = r.y2;
	}

	/**
	 * Create a copy of this rect
	 * @return Rect		A copy of this rect
	 */
	public function copy() : Rect{
		return new Rect( this.x, this.y, this.width, this.height );
	}

	/**
	 * Trace
	 */
	public function trace( name : String = 'Rect' ){
		trace('$name: $x,$y ${width}x${height} $x2,$y2');
	}

}