package mxd.utils;

/**
 * Various color helpers
 */
class Color{

	/**
	 * Apply alpha to a 24-bit RGB Int value, which results in a 32-bit ARGB value.
	 * Any alpha will be replaced.
	 * @param color 	The color
	 * @param a 		The alpha 0.0 <= a <= 1.0
	 */
	public static function applyAlpha( color : Int, a : Float ){
		var av : Int = Math.round( ((a<0)?a:(a>1)?1:a) * 255 );
		return (color & 0xffffff) | (av<<24);
	}

}