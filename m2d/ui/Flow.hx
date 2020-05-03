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
trace('Initial x: $x');
		for (item in items){
trace('Item ${item.name}');
			// Reset
			item.left.unset();
			item.top.unset();
			item.right.unset();
			item.bottom.unset();
			item.width.unsetMin();
			item.width.unsetMax();
			item.position = Absolute;

			// Set
			item.left.set(x);
			item.top.set(columns[c]);
			item.width.set(colWidth);
trace('  Placed at: ${x},${columns[c]} with width $colWidth');

			// Update column height
			columns[c] += item.height.get(elementRect.width,elementRect.height,ctx.scene.width,ctx.scene.height) + rs;

			// Move to next col
			x += (colWidth + cs);
			c++;
			if (c==cc){
				x = 0;
				c = 0;
			}
		}

		// Continue sync
		super.sync_children( ctx );
	}

	/**
	 * XXX: Re-flow after the children sync process?
	 */
	override function sync_post( ctx:RenderContext ){

	}


}