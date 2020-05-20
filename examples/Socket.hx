import h2d.Graphics;
import m2d.ui.Socket;

class Example extends App{

	override function init(){
		// Background color
		bg = new Graphics( s2d );
		bg.beginFill( 0x556677 );
		bg.drawRect( 0, 0, s2d.width, s2d.height );
		bg.endFill();

		// A whole bunch of sockets to play with
		for (i in 0...10) {
			var sc = new Socket( 5, s2d );
			sc.shadow = true;
			sc.x = 200;
			sc.y = 100 + 50*i;
			s.push( sc );

			sc = new Socket( 5, s2d );
			sc.shadow = true;
			sc.x = 400;
			sc.y = 100 + 50*i;
			s.push( sc );

			sc = new Socket( 5, s2d );
			sc.shadow = true;
			sc.x = 600;
			sc.y = 100 + 50*i;
			s.push( sc );

			sc = new Socket( 5, s2d );
			sc.shadow = true;
			sc.x = 800;
			sc.y = 100 + 50*i;
			s.push( sc );
		}
	}

	override function update(dt:Float) {
		// Update sockets
		for (sc in s) sc.update(dt);
	}

	static function main(){
		new Example();
	}

	
}