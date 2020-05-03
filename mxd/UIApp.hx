package mxd;

import m2d.Rect;
import hxd.App;
import m2d.ui.Canvas;

class UIApp extends App{

	/**
	 * The base element that all children should be added to.
	 */
	public var canvas : m2d.ui.Canvas;

	var viewRect : Rect;

	override function init() {
		super.init();

		canvas = new Canvas( s2d );
		viewRect = new Rect(0,0,s2d.width,s2d.height);
		canvas.update( viewRect );
	}

	override function onResize() {
		super.onResize();

		viewRect.set(0,0,s2d.width,s2d.height);
		canvas.update( viewRect );
	}

}