import m2d.ui.Box;

/**
 * Example of the BoxBackground class. This is a class that simulates css
 * backgrounds. It supports color and image backgrounds, and supports sizes
 * such as Fit and Fill as well as manual sizing and positioning.
 * 
 * The Box class contains a BoxBackground, and is the easiest way to
 * demonstrate it in action.
 * 
 * NOTES:
 * To access the resource needed in this example, copy the file example.png
 * from the 'res' folder to your resources folder. Image is free to use. Credits:
 * https://www.pexels.com/photo/multicolored-abstract-painting-1509534/
 */
class Example extends hxd.App{

	override function init(){

		// Create a box and place it on the scene
		var b : Box = new Box( s2d.width-100, s2d.height-100, s2d );
		b.x = b.y = 50;
		b.background.visible = true;

		// NOTE: Comment out all except one of the examples at a time!
		
		// Example 1
		// Set a solid color background
		b.background.color = 0xff9900;

		// Example 2
		// Set a background color with alpha. This sets the entire background to have
		// 50% alpha, so if you also had an image in the background, it would also
		// have 505 alpha.
		b.background.color = 0xff9900;
		b.background.alpha = 0.5;

		// Example 3
		// Set a background color with alpha. This uses ARGB colors to set the alpha
		// and the color together. In this case, the alpha is only applied to the color
		// and any background image would not be affected
		b.background.color = 0x80ff9900;
		// or
		b.background.color = mxd.utils.Color.applyAlpha( 0xff9900, 0.5 );

		// Example 4
		// Set a background image to fill entire background area
		b.background.image = hxd.Res.example.toTile();
		b.background.imageSize = Fill;

		// Example 5
		// Set a background image that fits inside the background area, but is aligned right
		b.background.image = hxd.Res.example.toTile();
		b.background.imageSize = Fit;
		b.background.imagePositionH = Max;

		// Example 6
		// Shorthand to set an image background sized to 50% width (height is automatic)
		b.background.setImage( hxd.Res.example.toTile(), Percent, 0.5 );

		// Example 7
		// Set a background image that is at a fixed size, aligned center-top, over an orange transparent background
		b.background.color = 0x80ff9900;
		b.background.setImage( hxd.Res.example.toTile(), Normal, 200, 100, Percent, 0.5, 0 );

		// Example 8
		// Same as example 7, but tile the image (note that the background color is now not required)
		b.background.setImage( hxd.Res.example.toTile(), Normal, 200, 100, Percent, 0.5, 0 );
		b.background.imageRepeat = true;

	}

	static function main(){
		hxd.Res.initLocal();
		new Example();
	}

}
