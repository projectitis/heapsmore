package h2m.ui;

import h2m.ui.Box;
import h2d.Font;
import h2d.RenderContext;

enum Align {
	Left;
	Right;
	Center;
	Justify;
}

/**
 * An improved TextArea class. features:
 *		Justify alignment
 *		Clipping
 *		Better text wrap
 *		Auto-width, auto-height, or fixed size
 */
class TextArea extends Box{

	public var font : Font;
	public var text(default,set) : String = '';
	public var align(default,set) : Align = Align.Left;

	/**
	 * Automatically adjust width while keeping height fixed. If both are set, will make the text area
	 * as big as required to fit the full text.
	 */
	public var autoWidth : Bool = true;

	/**
	 * Automatically adjust height while keeping width fixed. If both are set, will make the text area
	 * as big as required to fit the full text.
	 */
	public var autoHeight : Bool = false;

	var textWrapped : Null<String> = null;
	var dirty : Bool = false;

	public function new( ?font : Font, ?parent : h2d.Object ) {
		super(parent);
		this.font = font;
		this.height = font.lineHeight; // By default, single line with auto-width
	}

	function set_text( v : String ) : String{
		if (this.text!=v){
			this.text = v;
			this.dirty = true;
		}
		return v;
	}

	function set_align( v : Align ) : Align{
		if (this.align!=v){
			this.align = v;
			this.dirty = true;
		}
		return v;
	}

	/**
	 * Update everything ready for a redraw
	 */
	public function update(){
		if (!dirty) return;

		if (textWrapped==null){
			
		}
	}

	/**
	 * Clear any currently rendered text
	 */
	function clear(){

	}

	override function draw(ctx:RenderContext) {
		if (!dirty) return;

		if (font==null){
			clear();
			return;
		}


	}


}