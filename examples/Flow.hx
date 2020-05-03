import hxd.Rand;
import m2d.Rect;
import m2d.ui.Canvas;
import m2d.ui.Flow;
import mxd.UIApp;

class Example extends UIApp{

	override function init(){
		super.init();

		canvas.background.fillColor = 0x8f8767;

		var flow : Flow = new Flow(canvas);
		flow.background.fillColor = 0xff9900;
		flow.margin.set('50px');
		flow.padding.set('20px');
		flow.columnSpacing.set('20px');
		flow.rowSpacing.set('20px');
		flow.minColumnWidth.set('200px');

		var item : Canvas = null;
		var rand : Rand = Rand.create();
		for (i in 0...10){
			item = new Canvas(flow);
			item.background.fillColor = 0x662266;
			item.height.set( 100 + rand.random(100) );
			item.name = 'item_$i';
		}
	}

	static function main(){
		new Example();
	}

	
}