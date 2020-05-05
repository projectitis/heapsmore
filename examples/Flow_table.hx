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

		// This makes the flow behave as a table:
		flow.columnCount = 3;		// Fixed to 3 columns
		flow.rowSizing = Row;		// Make all items on same row same height
		flow.height.set('auto');	// Set flow to height of it's children

		// Add items with random text snippets (from Peter Pan and Wendy) to the flow
		var item : Text = null;
		var rand : Rand = Rand.create();
		var f : h2d.Font = hxd.Res.fonts.pixel.Alkhemikal.toFont();
		for (i in 0...10){
			item = new Text(f,flow);
			item.background.fillColor = 0x662266;
			item.padding.set(20);
			item.textColor = 0xffffff;
			switch (rand.random(4)){
				case 0: item.text = 'Mrs. Darling loved to have everything just so, and Mr. Darling had a passion for being exactly like his neighbours; so, of course they had a nurse. As they were poor, owing to the amount of milk the children drank, this nurse was a prim Newfoundland dog, called Nana.';
				case 1: item.text = 'Nana had no doubt of what was the best thing to do with this shadow. She hung it out at the window, meaning “He is sure to come back for it; let us put it where he can get it easily without disturbing the children.”';
				case 2: item.text = 'She explained in quite a matter-of-fact way that she thought Peter sometimes came to the nursery in the night and sat on the foot of her bed and played on his pipes to her.';
				case _: item.text = 'All children, except one, grow up.';
			}
			item.name = 'item_$i';
		}
	}

	static function main(){
		hxd.Res.initLocal();
		new Example();
	}

	
}