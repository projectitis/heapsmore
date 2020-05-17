package m2d.ui;

import h2d.Object;
import h2d.RenderContext;
import hxd.Math;
import m2d.ui.Canvas;
import m2d.ui.Dimension;
import m2d.ui.Graphics;

enum ScrollbarType{
	Vertical;		// Vertical scrollbar (default)
	Horizontal;		// Horizontal scrollbar
}

enum ScrollbarPosition{
	Default;		// Right for vertical, Bottom for horizontal (default)
	Opposite;		// Left for vertical, Top for horizontal
}

enum ScrollbarSide{
	Inside;			// Just inside the content area, over the content (default)
	Outside;		// Just outside the content area, not over the content
}

class Scrollbar extends Graphics{

	public var type : ScrollbarType = Vertical;

	public var position : ScrollbarPosition = Default;

	public var side : ScrollbarSide = Inside;

	/**
	 * Color of the background (default black)
	 */
	public var backgroundColor(default,set) : Int = 0;

	/**
	 * Alpha of the background (default 50%)
	 */
	public var backgroundAlpha(default,set) : Float = 0.5;

	/**
	 * Corner radius of the background
	 */
	public var backgroundRadius(default,set) : Float = 0;

	/**
	 * Color of the handle (default white)
	 */
	public var handleColor(default,set) : Int = 0xffffff;

	/**
	 * Alpha of the handle (default 100%)
	 */
	public var handleAlpha(default,set) : Float = 1;

	/**
	 * Corner radius of the handle
	 */
	public var handleRadius(default,set) : Float = 0;

	/**
	 * The size of the handle. Is changed automatically depending on the amount of scroll available,
	 * but the user can set the minimum and maximum size (`handleSize.setMin` and `handleSize.setMax`).
	 */
	public var handleSize : Dimension = new Dimension();

	/**
	 * The outer width of the scrollbar (Default 10px)
	 */
	public var width : Dimension = new Dimension(10);

	/**
	 * The padding of the scrollbar (Default 0)
	 */
	public var padding : SideRect = new SideRect();

	/**
	 * The target UI element that the scrollbar is for
	 */
	public var target(default,set) : Canvas = null;

	/**
	 * Callback when scrollbar value changes (e..g user has scrolled)
	 */
	public var onChange : Void -> Void = null;

	var handle : Graphics;
	var handleSizeCalc : Float = 0;
	var handleFactor : Float = 0;
	var needsRedraw : Bool = true;
	var needsResync : Bool = true;

	public function new( ?parent : Object, ?target : Canvas ){
		super( parent );
		if (target!=null) this.target = target;
		handle = new Graphics( this );
		padding.onChange = invalidate;
		width.onChange = invalidate;
		handleSize.onChange = invalidate;
		handleSize.setMin(50);
	}

	function set_target( v : Canvas ){
		this.target = v;
		invalidate();
		return v;
	}

	function set_backgroundColor( v : Int ) : Int{
		backgroundColor = v;
		invalidate();
		return v;
	}

	function set_backgroundAlpha( v : Float ) : Float{
		backgroundAlpha = Math.clamp(v);
		invalidate();
		return v;
	}

	function set_backgroundRadius( v : Float ) : Float{
		backgroundRadius = Math.max(0,v);
		invalidate();
		return v;
	}

	function set_handleColor( v : Int ) : Int{
		handleColor = v;
		invalidate();
		return v;
	}

	function set_handleAlpha( v : Float ) : Float{
		handleAlpha = Math.clamp(v);
		invalidate();
		return v;
	}

	function set_handleRadius( v : Float ) : Float{
		handleRadius = Math.max(0,v);
		invalidate();
		return v;
	}

	/**
	 * Called internally to fire callback when something changes
	 */
	function changed(){
		if (onChange!=null){
			var callback = onChange;
			onChange = null;
			callback();
			onChange = callback;
		}
	}

	/**
	 * Called by parent to update the handle position (content has scrolled)
	 */
	public function update() {
		needsResync = true;
	}

	/**
	 * Called by the parent to update the handle position
	 */
	@:access(m2d.ui.Canvas)
	override public function sync( ctx : RenderContext ){
		if (needsResync){
			needsResync = false;

			// Calculate handle values
			var sx : Float = target.scroll.x.getMax( target.scrollBounds.width, target.scrollBounds.height, ctx.scene.width, ctx.scene.height );
			var sy : Float = target.scroll.y.getMax( target.scrollBounds.width, target.scrollBounds.height, ctx.scene.width, ctx.scene.height );
			var bw : Float = width.get( target.scrollBounds.width, target.scrollBounds.height, ctx.scene.width, ctx.scene.height );
			var pt : Float = padding.top.get( target.scrollBounds.width, target.scrollBounds.height, ctx.scene.width, ctx.scene.height );
			var pb : Float = padding.bottom.get( target.scrollBounds.width, target.scrollBounds.height, ctx.scene.width, ctx.scene.height );
			var pl : Float = padding.left.get( target.scrollBounds.width, target.scrollBounds.height, ctx.scene.width, ctx.scene.height );
			var pr : Float = padding.right.get( target.scrollBounds.width, target.scrollBounds.height, ctx.scene.width, ctx.scene.height );
			var hw : Float = 0;
			var hs : Float = 0;

			var cb = handleSize.onChange;
			handleSize.onChange = null;
			if (this.type==Vertical){
				
				handleSize.set( target.scrollBounds.height * target.scrollBounds.height / (target.scrollBounds.height + sy) );
				hs = handleSize.get( target.scrollBounds.width, target.scrollBounds.height, ctx.scene.width, ctx.scene.height );
				handleSizeCalc = handleSize.get( target.scrollBounds.width, target.scrollBounds.height, ctx.scene.width, ctx.scene.height );
				handleFactor = (target.scrollBounds.height - pt - pb - hs) / sy;
				hw = bw - pl - pr;
				handleSize.onChange = cb;
			}
			//positionHandle( ctx );
		}
		super.sync( ctx );
	}

	/**
	 * Flag that this element needs a re-draw next frame
	 */
	public function invalidate(){
		needsRedraw = true;
	}

	/**
	 * Move the handle to indicate the correct scroll position of the target
	 * @param ctx 
	 */
	@:access(m2d.ui.Canvas)
	function positionHandle( ctx : RenderContext ){
		// vertical
		if (type==Vertical){
			handle.y = handleFactor * target.scroll.y.get( target.scrollBounds.width, target.scrollBounds.height, ctx.scene.width, ctx.scene.height );
			trace('handleFactor: $handleFactor');
			trace('handle.y: ${handle.y}');
		}
		// Horizontal
		else{
			handle.x = handleFactor * target.scroll.x.get( target.scrollBounds.width, target.scrollBounds.height, ctx.scene.width, ctx.scene.height );
		}
	}

	@:access(m2d.ui.Canvas)
	@:access(h2d.RenderContext)
	override function draw( ctx : RenderContext ){
		super.draw( ctx );
		if (!needsRedraw) return;
		needsRedraw = false;

		this.clear();
		this.handle.clear();
		if (target==null) return;

		var sx : Float = target.scroll.x.getMax( target.scrollBounds.width, target.scrollBounds.height, ctx.scene.width, ctx.scene.height );
		var sy : Float = target.scroll.y.getMax( target.scrollBounds.width, target.scrollBounds.height, ctx.scene.width, ctx.scene.height );

		if ((this.type==Vertical) && (sy==0)) visible = false;
		if ((this.type==Horizontal) && (sx==0)) visible = false;
		if (!visible) return;

		var bw : Float = width.get( target.scrollBounds.width, target.scrollBounds.height, ctx.scene.width, ctx.scene.height );
		var pt : Float = padding.top.get( target.scrollBounds.width, target.scrollBounds.height, ctx.scene.width, ctx.scene.height );
		var pb : Float = padding.bottom.get( target.scrollBounds.width, target.scrollBounds.height, ctx.scene.width, ctx.scene.height );
		var pl : Float = padding.left.get( target.scrollBounds.width, target.scrollBounds.height, ctx.scene.width, ctx.scene.height );
		var pr : Float = padding.right.get( target.scrollBounds.width, target.scrollBounds.height, ctx.scene.width, ctx.scene.height );
		var hw : Float = 0;
		var hs : Float = 0;

		// Begin drawing
		beginFill( backgroundColor, backgroundAlpha );
		handle.beginFill( handleColor, handleAlpha );

		// Vertical
		if (this.type==Vertical){
			// Position background
			this.y = target.scrollBounds.yMin;
			if (this.position==Default){
				this.x = target.scrollBounds.xMax;
				if (this.side==Inside) this.x -= bw;
			}
			else{
				this.x = target.scrollBounds.xMin;
				if (this.side==Outside) this.x -= bw;
			}

			// Draw background
			if (backgroundRadius==0) drawRect( 0,0, bw,target.scrollBounds.height );
			else drawRoundedRect( 0,0, bw,target.scrollBounds.height, backgroundRadius );

			// Position handle
			var cb = handleSize.onChange;
			handleSize.onChange = null;
			handleSize.set( target.scrollBounds.height * target.scrollBounds.height / (target.scrollBounds.height + sy) );
			hs = handleSize.get( target.scrollBounds.width, target.scrollBounds.height, ctx.scene.width, ctx.scene.height );
			handleFactor = (target.scrollBounds.height - pt - pb - hs) / sy;
			hw = bw - pl - pr;
			handleSize.onChange = cb;
			
			// Draw handle
			if (handleRadius==0) handle.drawRect( pt,pl, hw,hs );
			else handle.drawRoundedRect( pt,pl, hw,hs, handleRadius );
		}

		// Horizontal
		else{
			// Position background
			this.x = target.scrollBounds.xMin;
			if (this.position==Default){
				this.y = target.scrollBounds.yMax;
				if (this.side==Inside) this.y -= bw;
			}
			else{
				this.y = target.scrollBounds.yMin;
				if (this.side==Outside) this.y -= bw;
			}

			// Draw background
			if (backgroundRadius==0) drawRect( 0,0, target.scrollBounds.width,bw );
			else drawRoundedRect( 0,0, target.scrollBounds.width,bw, backgroundRadius );
		}

		// Finalise drawing
		endFill();
		handle.endFill();

		// Position the handle
		positionHandle( ctx );
	}

}