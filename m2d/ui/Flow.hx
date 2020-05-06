package m2d.ui;

import h2d.Object;
import h2d.RenderContext;
import h2d.col.Bounds;
import hxd.Math;
import m2d.ui.Dimension;

/**
 * How the flow manages the height of rows
 */
enum FlowRowSizing {
	None;		// No effort to maintain. Each element can be a different height
	Row;		// All items in the same row are set to the height of the tallest in that row
	All;		// All items in the whole flow are set to the height of the tallest item in the flow
}

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

	/**
	 * How the size of the rows are handled. None = all elements at their own heights. None, Row, All.
	 */
	public var rowSizing : FlowRowSizing = None;

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
		var cs : Float = columnSpacing.get(elementBounds.width,elementBounds.height,ctx.scene.width,ctx.scene.height);
		var rs : Float = rowSpacing.get(elementBounds.width,elementBounds.height,ctx.scene.width,ctx.scene.height);
		var mw : Float = minColumnWidth.get(elementBounds.width,elementBounds.height,ctx.scene.width,ctx.scene.height);
		var colWidth : Float = 0;
		if (columnCount==0){
			if (minColumnWidth.undefined || (mw==0)){
				cc = items.length;
			}
			else{
				var w : Float = contentBounds.width - cs;
				cc = Math.floor( w / mw);
			}
		}
		colWidth = (contentBounds.width - cs*(cc-1)) / cc;

		// Update the column references
		var columns : Array<Float> = new Array();
		var rows : Array<Float> = new Array();
		columns.resize( cc );

		// Position the items
		var c : Int = 0;
		var x : Float = 0;
		var r : Bounds = new Bounds();
		var mx : Float = 0;
		var my : Float = 0;
		var ch : Float = 0;
		var mh : Float = 0;
		for (reflow in 0...2){
			c = 0;
			x = 0;
			mx = 0;
			my = 0;
			ch = 0;
			for (i in 0...cc) columns[i] = 0;
			for (item in items){
				// First time through
				if (reflow==0){
					// Reset
					item.position = Absolute;
					item.left.set(0);
					item.top.set(0);
					item.right.set(0);
					item.bottom.unset();
					item.width.unsetMin();
					item.width.unsetMax();
					item.width.set('100pw');
					if (rowSizing!=None) item.height.set('auto');
					ch = contentBounds.height - columns[c];
				}
				// Reflowing
				else{
					if (rowSizing==Row) ch = rows[0];
					else ch = mh;
					item.height.set(ch);
					if (c==0) trace('Reflow row height to ${ch}');
				}

				// Not calling parent.sync_children. Doing it here instead. We are also calling
				// sync directly on the child. When child.sync is called again shortly it will be
				// ignored because sync has already occured (needSync flag will be false) but we
				// need sync now to give child opporunity to adjust height.
				r.set( contentBounds.x + x, contentBounds.y + columns[c], colWidth, ch );
				item.update( r );
				item.sync( ctx );
				mx = Math.max(mx, x + item.bounds.width );
				my = Math.max(my, columns[c] + item.bounds.height); 
				if (reflow==0){
					mh = Math.max(mh, item.bounds.height);
					trace('  mh: $mh');
				}

				// Update column height
				columns[c] += item.bounds.height + rs;

				// Move to next col
				x += (colWidth + cs);
				c++;
				if (c==cc){
					x = 0;
					c = 0;
					if (rowSizing==Row){
						if (reflow==0) {
							rows.push( mh );
							trace('SET ROW ${rows.length} HEIGHT: $mh');
						}
						else rows.shift();
						mh = 0;
					}
				}
			}
			if ((reflow==0) && (c>0)){
				rows.push( mh );
				trace('SET ROW ${rows.length} HEIGHT: $mh (final)');
			}

			// If we don't need to re-flow, we break here, otherwise we go around for a reflow
			if (rowSizing==None) break;
		} // reflow
		if (height.auto) contentBounds.height = my;
		if (width.auto) contentBounds.width = mx;
	}

}