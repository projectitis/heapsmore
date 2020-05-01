package m2d.ui;

import h2d.Object;
import m2d.ui.Param;

/**
 * Rect for UI elements that describes 4 sides. Used internally by UI elements
 */
class SideRect{

	 var t : Param = new Param();
	 var b : Param = new Param();
	 var l : Param = new Param();
	 var r : Param = new Param();

	/**
	 * Top anchor for positioning
	 */
	public var parent(default,set) : Box = null;
 
	/**
	 * Top anchor for positioning
	 */
	public var top(get,set) : Float;
 
	/**
	 * Right anchor for positioning
	 */
	public var right(get,set) : Float;
 
	/**
	 * Bottom anchor for positioning
	 */
	public var bottom(get,set) : Float;
 
	/**
	 * Left anchor for positioning
	 */
	public var left(get,set) : Float;

	/**
	 * Callback when size changes
	 */
	public var onChange : Void -> Void = null;

	/**
	 * Create a new BoxRect with the specified values. If only topOrAll is provided, all sides will be
	 * set to topOrAll. If additional values are provided they will set their respective sides. If aa value
	 * is null, the current value for that side will not be changed.
	 * @param topOrAll		The value for top (or for all, if rest are omitted)
	 * @param right			The value for right (no change if null)
	 * @param bottom 		The value for bottom (no change if null)
	 * @param left 			The value for left (no change if null)
	 */
	public function new( topOrAll : Float = 0, ?right : Float, ?bottom : Float, ?left : Float ){
		this.setSize( topOrAll, right, bottom, left );
	}

	/**
	 * Set all sides to the specified values. If only topOrAll is provided, all sides will be set to topOrAll.
	 * If additional values are provided they will set their respective sides. If aa value is null, the current
	 * value for that side will not be changed.
	 * @param topOrAll		The value for top (or for all, if rest are omitted)
	 * @param right			The value for right (no change if null)
	 * @param bottom 		The value for bottom (no change if null)
	 * @param left 			The value for left (no change if null)
	 */
	public function setSize( ?topOrAll : Float, ?right : Float, ?bottom : Float, ?left : Float ){
		var callback : Void -> Void = onChange; onChange=null; // Ensures callback called only once
		if ((left==null) && (bottom==null) && (right==null)){
			if (topOrAll!=null) this.top = this.right = this.bottom = this.left = topOrAll;
		}
		else{
			if (topOrAll!=null) this.top = topOrAll;
			if (right!=null) this.right = right;
			if (bottom!=null) this.bottom = bottom;
			if (left!=null) this.left = left;
		}
		// Ensure callback is not recursively called
		if (callback != null){
			callback();
			onChange = callback;
		}
	}

	/**
	 * Size setters
	 */
	function get_top() : Null<Float>{
		return this.t.value;
	}
	function set_top( v : Null<Float> ) : Null<Float>{
		this.t.setValue(v);
		changed();
		return v;
	}
	function get_right() : Null<Float>{
		return this.r.value;
	}
	function set_right( v : Null<Float> ) : Null<Float>{
		this.r.setValue(v);
		changed();
		return v;
	}
	function get_bottom() : Null<Float>{
		return this.b.value;
	}
	function set_bottom( v : Null<Float> ) : Null<Float>{
		this.b.setValue(v);
		changed();
		return v;
	}
	function get_left() : Null<Float>{
		return this.l.value;
	}
	function set_left( v : Null<Float> ) : Null<Float>{
		this.l.setValue(v);
		changed();
		return v;
	}
	function set_parent( v : Box ) : Box{
		this.parent = v;
		this.t.parent = v;
		this.r.parent = v;
		this.b.parent = v;
		this.l.parent = v;
		return v;
	}
	inline function changed(){
		if (onChange != null){
			var callback : Void -> Void = onChange;
			onChange = null;
			callback();
			onChange = callback;
		}
	}

	/**
	 * Populate from external data
	 * @param data 	The data
	 */
	public function fromData( data : haxe.DynamicAccess<Dynamic> ){
		var callback : Void -> Void = onChange; onChange = null; // Ensure we don't recurse

		applyStyle( data );

		if (callback != null) callback();
		onChange = callback;
	}

	/**
	 * This method does the actual work of applying the style data to this object. Subclasses should
	 * override this (but call super.applyStyle first).
	 * @param data 		The data
	 */
	function applyStyle( data : haxe.DynamicAccess<Dynamic> ){
		if (data == null) return;

		if (Std.is(data,Int) || Std.is(data,Float)){
			var f : Float = cast(data,Float);
			this.t.setValue( f );
			this.r.setValue( f );
			this.b.setValue( f );
			this.l.setValue( f );
		}
		else{
			if (data.exists('top')) this.t.setValue( cast(data.get('top'),String) );
			if (data.exists('right')) this.r.setValue( cast(data.get('right'),String) );
			if (data.exists('bottom')) this.b.setValue( cast(data.get('bottom'),String) );
			if (data.exists('left')) this.l.setValue( cast(data.get('left'),String) );
		}
	 }

}