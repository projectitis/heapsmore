package mxd;

import h2d.col.Bounds;
import hxd.App;
import m2d.ui.Canvas;

class UIApp extends App{

	/**
	 * The base element that all children should be added to.
	 */
	public var canvas : m2d.ui.Canvas;

	var viewBounds : Bounds = new Bounds();

	override function init() {
		super.init();

		canvas = new Canvas( s2d );
		viewBounds.set(0,0,s2d.width,s2d.height);
		canvas.update( viewBounds );
	}

	override function onResize() {
		super.onResize();
		viewBounds.set( 0,0,s2d.width,s2d.height );
		canvas.update( viewBounds );
	}

}