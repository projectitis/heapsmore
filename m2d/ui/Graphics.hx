package m2d.ui;

import h2d.Object;

/**
 * An extension of the graphics class used only by internal children of the UI elements. Any child
 * of this type is not treated the same as regualr children.
 */
class Graphics extends h2d.Graphics{

	public function new( ?parent : Object ){
		super( parent );
	}

}