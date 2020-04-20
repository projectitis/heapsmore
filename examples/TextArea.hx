import m2d.ui.Box;

/**
 * Example of the TextArea class.
 * 
 * TextArea extends Box, so has css-style positioning and layout features, including
 * backgrounds. @see Background.hx
 * 
 * NOTES:
 * To support BDF font's you'll need to use the bdf_fonts branch of heaps,
 * unless it's been pulled into the heaps master by now and I haven't got
 * around to updating this example.
 * 
 * Otherwise, feel free to substitute with an FNT bitmap font file.
 * SDF/Signed Distance Field fonts not yet supported.
 * 
 * To access the font needed in this example, copy the font file
 * DMSerifDisplayRegular_24.bdf from the 'res' folder to your resources
 * folder. The font is free to use. Credits:
 * https://fonts.google.com/specimen/DM+Serif+Display
 * It was converted from TTF to BDF using FontForge, also free to use:
 * https://fontforge.org/en-US/
 * The excerpt is from Peter Pan by James M. Barrie, available on Gutenberg:
 * http://www.gutenberg.org/ebooks/16
 */
class Example extends hxd.App{

	override function init(){

		// Create a text area with our chosen font. Set a semi-transparent black background,
		// black text, and some padding. Set line spacing to about 1.25
		var f : h2d.Font = hxd.Res.DMSerifDisplayRegular_24.toFont();
		var tf : m2d.ui.TextArea = new m2d.ui.TextArea( f, s2d );
		tf.padding.setSize(20);
		tf.background.setColor( 0x000000, 0.1 );
		tf.color = 0x000000;
		tf.lineSpacing = 1.25;

		// NOTE: Comment out all except one of the examples at a time!
		
		// Example 1
		// Set a fixed width (height will be auto). Note that the width includes the padding
		// and the border, just like css "box-sizing:border-box". @see m2d.ui.Box
		tf.width = s2d.width / 2;
		tf.text = 'Mrs. Darling loved to have everything just so, and Mr. Darling had a passion for being exactly like his neighbours; so, of course, they had a nurse. As they were poor, owing to the amount of milk the children drank, this nurse was a prim Newfoundland dog, called Nana';

		// Example 2
		// Set a maximum width. SImilar to teh last example, except that the text field will
		// be smaller if there is less text to push it to maxWidth.
		tf.maxWidth = s2d.width / 2;
		tf.text = 'All children, except one, grow up.';

		// Example 3
		// Set a minimum width and a maximum width
		tf.minWidth = s2d.width / 2;
		tf.maxWidth = s2d.width;
		tf.text = 'All children, except one, grow up.';

		// Example 4
		// There are many text alignments to choose from. Try Left, Right, Center, Justify,
		// JustifyRight and JustifyCenter.
		tf.width = s2d.width / 2;
		tf.text = 'All children, except one, grow up.';
		tf.align = Right;
		// or
		tf.width = s2d.width / 2;
		tf.text = 'Mrs. Darling loved to have everything just so, and Mr. Darling had a passion for being exactly like his neighbours; so, of course, they had a nurse. As they were poor, owing to the amount of milk the children drank, this nurse was a prim Newfoundland dog, called Nana';
		tf.align = Justify;

	}

	static function main(){
		hxd.Res.initLocal();
		new Example();
	}

}