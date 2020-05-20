package m2d.ui;

import hxd.Event;
import h2d.col.Circle;
import h2d.Interactive;
import h2d.Object;
import h2d.Graphics;
import h2d.RenderContext;
import hxd.Math;
import h2d.filter.Blur;
import mxd.tools.ColorTools;

class SocketCable extends Cable {
	public var startObject : Object = null;
	public var endObject : Object = null;

	public function new( ?parent : Object ) {
		super( parent );
	}
}

class Socket extends Interactive {

	static var activeCable : SocketCable = null; 
	static var dockedCable : Bool = false;

	/**
	 * The inner (hold) diameter of the socket
	 */
	public var socketSize(default, set) : Float = 5;

	 /**
	  * The colour of the socket
	  */
	public var socketColor(default, set) : Int = 0x808080;
 
	 /**
	  * The alpha of the socket. Usually fully opaque.
	  */
	public var socketAlpha(default, set) : Float = 1;

	/**
	 * If true, socket will have dropshdow
	 */
	public var shadow(default, set) : Bool = false;

	/**
	 * Shadow color (default black)
	 */
	public var shadowColor(default, set) : Int = 0x000000;
 
	/**
	 * Shadow transparency (default 25%)
	 */
	public var shadowAlpha(default, set) : Float = 0.25;
 
	/**
	 * Direction of shadow in radians (default 45deg down/right)
	 */
	public var shadowDirection(default, set) : Float = Math.PI * 0.25;

	/**
	 * User callback. Triggered when any render properties change (such as color), or
	 * if the ends are moved
	 */
	public var onChange : Void->Void;

	var active : Bool = false;
	var docked : Bool = false;
	var connectedCable : SocketCable = null;

	var baseShadowCanvas : Graphics;
	var baseCanvas : Graphics;
	var socketShadowCanvas : Graphics;
	var socketCanvas : Graphics;
	var hitShape : Circle;
	var needsRedraw : Bool = true;

	/**
	 * Create a new socket with the size
	 * @param size 		Diameter of the hole (same as cable thickness)
	 * @param parent 	The parent
	 */
	public function new( size : Float, ?parent : Object ) {
		hitShape = new Circle( 0, 0, 5 );
		super(10,10,parent,hitShape);

		socketSize = size;
		baseShadowCanvas = new Graphics( this );
		baseShadowCanvas.filter = new Blur(2);
		baseCanvas = new Graphics( this );
		socketShadowCanvas = new Graphics( this );
		socketShadowCanvas.filter = new Blur(2);
		socketCanvas = new Graphics( this );
	}

	function set_socketSize( v : Float ) : Float {
		socketSize = Math.max( 0, v );
		hitShape.ray = socketSize * 2;
		changed();
		return v;
	}

	function set_socketColor( v : Int ) : Int {
		socketColor = v;
		changed();
		return v;
	}

	function set_socketAlpha( v : Float ) : Float {
		socketAlpha = Math.clamp(v);
		changed();
		return v;
	}

	function set_shadow( v : Bool ) : Bool {
		shadow = v;
		changed();
		return v;
	}

	function set_shadowColor( v : Int ) : Int {
		shadowColor = v;
		changed();
		return v;
	}

	function set_shadowAlpha( v : Float ) : Float {
		shadowAlpha = Math.clamp(v);
		changed();
		return v;
	}

	function set_shadowDirection( v : Float ) : Float {
		shadowDirection = v;
		changed();
		return v;
	}

	function changed() {
		if ( onChange != null ) {
			var cb : Void->Void = onChange;
			onChange = null;
			cb();
			onChange = cb;
		}
		needsRedraw = true;
	}

	override function onMove(e:Event) {
		if (!active && !docked && (activeCable != null)){
			activeCable.setEnd( x, y );
			dockedCable = true;
		}
	}

	override function onOut(e:Event) {
		dockedCable = false;
	}

	override function onPush(e:Event) {
		// Starting a cable
		if (activeCable == null){

			// Start a new cable
			if (!docked){
				activeCable = new SocketCable( this.parent );
				activeCable.startObject = this;
				connectedCable = activeCable;
				activeCable.cableLength = 0;
				activeCable.cableThickness = socketSize;
				activeCable.plugThickness = socketSize*2;
				activeCable.plugLength = socketSize*4;
				activeCable.plugColor = socketColor;
				activeCable.shadow = shadow;
				activeCable.shadowColor = shadowColor;
				activeCable.shadowAlpha = shadowAlpha;
				activeCable.shadowDirection = shadowDirection;
				activeCable.setStart( x, y );
				active = true;
				docked = true;
			}

			// Undock an existing cable
			else if (connectedCable != null){
				activeCable = connectedCable;
				
				if (activeCable.endObject != this){
					activeCable.startObject = activeCable.endObject;
					activeCable.setStart( activeCable.startObject.x, activeCable.startObject.y );
				}

				cast( activeCable.startObject, Socket ).active = true;
				activeCable.endObject = null;
				active = false;
				docked = false;
				dockedCable = false;
			}
		}
		
	}

	/**
	 * Release mouse on a socket
	 * @param e 	
	 */
	override function onRelease(e:Event) {

		if (activeCable != null){

			// Release cable
			if (active || !dockedCable) {
				if (activeCable.startObject != this){
					cast( activeCable.startObject, Socket ).active = false;
					cast( activeCable.startObject, Socket ).docked = false;
					cast( activeCable.startObject, Socket ).connectedCable = null;
				}
				activeCable.remove();
				activeCable = null;
				active = false;
				docked = false;
				dockedCable = false;
			}

			// Dock cable
			else if (!docked){
				cast( activeCable.startObject, Socket ).active = false;
				activeCable.endObject = this;
				connectedCable = activeCable;
				activeCable = null;
				active = false;
				docked = true;
				dockedCable = false;
			}
		}
	}

	public function update(dt:Float) {
		if (active && !dockedCable && (activeCable != null)){
			activeCable.setEnd( scene.mouseX, scene.mouseY );
		}
	}

	/**
	 * Draw the socket
	 * XXX: Shading
	 * @param ctx 		The render context
	 */
	 override function draw( ctx:RenderContext ) {
		super.draw(ctx);

		if (needsRedraw) {
			needsRedraw = false;
trace('draw. visible:$visible');

			baseShadowCanvas.clear();
			baseCanvas.clear();
			socketShadowCanvas.clear();
			socketCanvas.clear();
			if (!visible) return;

			if (shadow){
				var sx : Float = Math.cos( shadowDirection );
				var sy : Float = Math.sin( shadowDirection );

				baseShadowCanvas.alpha = shadowAlpha;
				baseShadowCanvas.beginFill( shadowColor );
				baseShadowCanvas.drawCircle( sx*2, sy*2, socketSize * 2.1 );
				baseShadowCanvas.endFill();

				socketShadowCanvas.alpha = shadowAlpha;
				socketShadowCanvas.beginFill( shadowColor );
				socketShadowCanvas.drawCircle( sx*2, sy*2, socketSize * 1.2 );
				socketShadowCanvas.endFill();
			}

			baseCanvas.alpha = socketAlpha;
			baseCanvas.beginFill( ColorTools.darken( socketColor, 0.2 ) );
			baseCanvas.drawCircle( 0, 0, socketSize * 2, 16 );
			baseCanvas.endFill();

			socketCanvas.alpha = socketAlpha;
			socketCanvas.beginFill( socketColor );
			socketCanvas.drawCircle( 0, 0, socketSize, 16 );
			socketCanvas.endFill();
			socketCanvas.beginFill( 0x000000 );
			socketCanvas.drawCircle( 0, 0, socketSize / 2, 16 );
			socketCanvas.endFill();
		}
	}



}