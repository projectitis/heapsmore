package m2d.ui;

import h2d.Object;
import h2d.RenderContext;
import hxd.Math;
import m2d.ui.Dimension;

/**
 * A canvas item that allows items to be layed out in columns. Will override any custom
 * layour properties of immediate children (such as width, margin etc)
 */
class Flow extends Canvas{

	/**
	 * Space between columns. Does not add space before the first column or after the last.
	 */
	public var columnSpacing : Dimension = new Dimension();

	/**
	 * Space between rows. Does not add space before the first row or after the last.
	 */
	public var rowSpacing : Dimension = new Dimension();

	/**
	 * The minimum columns width. Used for auto-columns (if setting this, also set columnCount to 0)
	 */
	public var minColumnWidth : Dimension = new Dimension();

	/**
	 * The number of columns. Set this to 0 to automatically calculate coumns based on minColumnWidth
	 */
	public var columnCount(default,set) : Int = 0;

	var columns : Array<Float> = new Array(); // Reference to height of each column

	public function new( ?parent : Object ){
		super( parent );
		columnSpacing.onChange = invalidate;
		rowSpacing.onChange = invalidate;
		minColumnWidth.onChange = invalidate;
	}

	function set_columnCount( v : Int ) : Int{
		columnCount = Math.imax(0,v);
		invalidate();
		return v;
	}

	/**
	 * Sync operations based on updating the children
	 */
	override function sync_children( ctx:RenderContext ){
		// Get children who are Canvas objects. These are the items that need to be flowed
		var items : Array<Canvas> = new Array();
		for (child in children){
			if (Std.is(child,Canvas)){
				items.push( cast(child,Canvas) );
			}
		}

		// Calculate column sizes etc
		var cc : Int = columnCount;
		var cs : Float = columnSpacing.get(elementRect.width,elementRect.height,ctx.scene.width,ctx.scene.height);
		var rs : Float = rowSpacing.get(elementRect.width,elementRect.height,ctx.scene.width,ctx.scene.height);
		var mw : Float = minColumnWidth.get(elementRect.width,elementRect.height,ctx.scene.width,ctx.scene.height);
		var colWidth : Float = 0;
		if (columnCount==0){
			if (minColumnWidth.undefined || (mw==0)){
				cc = items.length;
			}
			else{
				var w : Float = contentRect.width - cs;
				cc = Math.floor( w / mw);
			}
		}
		colWidth = (contentRect.width - cs*(cc-1)) / cc;

		// Update the column references
		columns.resize(cc);
		for (i in 0...cc) columns[i] = 0;

		// Position the items
		var c : Int = 0;
		var x : Float = 0;
		var r : Rect = new Rect();
trace('Initial x: $x cc:$cc');

		for (item in items){
trace('Item ${item.name}');
			// Reset
			item.left.set(0);
			item.top.set(0);
			item.right.set(0);
			item.bottom.unset();
			item.width.unsetMin();
			item.width.unsetMax();
			item.width.set('100pw');
			item.position = Absolute;

			// Not calling parent.sync_children. Doing it here instead. We are also calling
			// sync directly on the child. When child.sync is called again shortly it will be
			// ignored because sync has already occured (needSync flag will be false) but we
			// need sync now to give child opporunity to adjust height.
			r.set( contentRect.x + x, contentRect.y + columns[c], colWidth, contentRect.height - columns[c] );
r.trace('  r');
			item.update( r );
			item.sync( ctx );
item.contentRect.trace('  contentRect');

			// Update column height
			columns[c] += item.marginRect.height + rs;

			// Move to next col
			x += (colWidth + cs);
			c++;
			if (c==cc){
				x = 0;
				c = 0;
			}
		}
	}

	/**
	 * XXX: Re-flow after the children sync process?
	 */
	override function sync_post( ctx:RenderContext ){

	}


}