package mxd.utils;

import hxd.Math;

/**
 * Various color helpers
 */
class Color{

	/**
	 * List of web "X11 colors" from the CSS3 specification
	 * https://en.wikipedia.org/wiki/Web_colors
	 */
	static inline var Transparent			: Int = 0xff00ff;
	static inline var Pink					: Int = 0xffc0cb;
	static inline var LightPink				: Int = 0xffb6c1;
	static inline var HotPink				: Int = 0xff69b4;
	static inline var DeepPink				: Int = 0xff1493;
	static inline var PaleVioletRed			: Int = 0xdb7093;
	static inline var MediumVioletRed		: Int = 0xc71585;
	static inline var LightSalmon			: Int = 0xffa07a;
	static inline var Salmon				: Int = 0xfa8072;
	static inline var DarkSalmon			: Int = 0xe9967a;
	static inline var LightCoral			: Int = 0xf08080;
	static inline var IndianRed				: Int = 0xcd5c5c;
	static inline var Crimson				: Int = 0xdc143c;
	static inline var Firebrick				: Int = 0xb22222;
	static inline var DarkRed				: Int = 0x8b0000;
	static inline var Red					: Int = 0xff0000;
	static inline var OrangeRed				: Int = 0xff4500;
	static inline var Tomato				: Int = 0xff6347;
	static inline var Coral					: Int = 0xff7f50;
	static inline var DarkOrange			: Int = 0xff8c00;
	static inline var Orange				: Int = 0xffa500;
	static inline var Yellow				: Int = 0xffff00;
	static inline var LightYellow			: Int = 0xffffe0;
	static inline var LemonChiffon			: Int = 0xfffacd;
	static inline var LightGoldenrodYellow	: Int = 0xfafad2;
	static inline var PapayaWhip			: Int = 0xffefd5;
	static inline var Moccasin				: Int = 0xffe4b5;
	static inline var PeachPuff				: Int = 0xffdab9;
	static inline var PaleGoldenrod			: Int = 0xeee8aa;
	static inline var Khaki					: Int = 0xf0e68c;
	static inline var DarkKhaki				: Int = 0xbdb76b;
	static inline var Gold					: Int = 0xffd700;
	static inline var Cornsilk				: Int = 0xfff8dc;
	static inline var BlanchedAlmond		: Int = 0xffebcd;
	static inline var Bisque				: Int = 0xffe4c4;
	static inline var NavajoWhite			: Int = 0xffdead;
	static inline var Wheat					: Int = 0xf5deb3;
	static inline var Burlywood				: Int = 0xdeb887;
	static inline var Tan					: Int = 0xd2b48c;
	static inline var RosyBrown				: Int = 0xbc8f8f;
	static inline var SandyBrown			: Int = 0xf4a460;
	static inline var Goldenrod				: Int = 0xdaa520;
	static inline var DarkGoldenrod			: Int = 0xb8860b;
	static inline var Peru					: Int = 0xcd853f;
	static inline var Chocolate				: Int = 0xd2691e;
	static inline var SaddleBrown			: Int = 0x8b4513;
	static inline var Sienna				: Int = 0xa0522d;
	static inline var Brown					: Int = 0xa52a2a;
	static inline var Maroon				: Int = 0x800000;
	static inline var DarkOliveGreen		: Int = 0x556b2f;
	static inline var Olive					: Int = 0x808000;
	static inline var OliveDrab				: Int = 0x6b8e23;
	static inline var YellowGreen			: Int = 0x9acd32;
	static inline var LimeGreen				: Int = 0x32cd32;
	static inline var Lime					: Int = 0x00ff00;
	static inline var LawnGreen				: Int = 0x7cfc00;
	static inline var Chartreuse			: Int = 0x7fff00;
	static inline var GreenYellow			: Int = 0xadff2f;
	static inline var SpringGreen			: Int = 0x00ff7f;
	static inline var MediumSpringGreen		: Int = 0x00fa9a;
	static inline var LightGreen			: Int = 0x90ee90;
	static inline var PaleGreen				: Int = 0x98fb98;
	static inline var DarkSeaGreen			: Int = 0x8fbc8f;
	static inline var MediumAquamarine		: Int = 0x66cdaa;
	static inline var MediumSeaGreen		: Int = 0x3cb371;
	static inline var SeaGreen				: Int = 0x2e8b57;
	static inline var ForestGreen			: Int = 0x228b22;
	static inline var Green					: Int = 0x008000;
	static inline var DarkGreen				: Int = 0x006400;
	static inline var Aqua					: Int = 0x00ffff;
	static inline var Cyan					: Int = 0x00ffff;
	static inline var LightCyan				: Int = 0xe0ffff;
	static inline var PaleTurquoise			: Int = 0xafeeee;
	static inline var Aquamarine			: Int = 0x7fffd4;
	static inline var Turquoise				: Int = 0x40e0d0;
	static inline var MediumTurquoise		: Int = 0x48d1cc;
	static inline var DarkTurquoise			: Int = 0x00ced1;
	static inline var LightSeaGreen			: Int = 0x20b2aa;
	static inline var CadetBlue				: Int = 0x5f9ea0;
	static inline var DarkCyan				: Int = 0x008b8b;
	static inline var Teal					: Int = 0x008080;
	static inline var LightSteelBlue		: Int = 0xb0c4de;
	static inline var PowderBlue			: Int = 0xb0e0e6;
	static inline var LightBlue				: Int = 0xadd8e6;
	static inline var SkyBlue				: Int = 0x87ceeb;
	static inline var LightSkyBlue			: Int = 0x87cefa;
	static inline var DeepSkyBlue			: Int = 0x00bfff;
	static inline var DodgerBlue			: Int = 0x1e90ff;
	static inline var CornflowerBlue		: Int = 0x6495ed;
	static inline var SteelBlue				: Int = 0x4682b4;
	static inline var RoyalBlue				: Int = 0x4169e1;
	static inline var Blue					: Int = 0x0000ff;
	static inline var MediumBlue			: Int = 0x0000cd;
	static inline var DarkBlue				: Int = 0x00008b;
	static inline var Navy					: Int = 0x000080;
	static inline var MidnightBlue			: Int = 0x191970;
	static inline var Lavender				: Int = 0xe6e6fa;
	static inline var Thistle				: Int = 0xd8bfd8;
	static inline var Plum					: Int = 0xdda0dd;
	static inline var Violet				: Int = 0xee82ee;
	static inline var Orchid				: Int = 0xda70d6;
	static inline var Fuchsia				: Int = 0xff00ff;
	static inline var Magenta				: Int = 0xff00ff;
	static inline var MediumOrchid			: Int = 0xba55d3;
	static inline var MediumPurple			: Int = 0x9370db;
	static inline var BlueViolet			: Int = 0x8a2be2;
	static inline var DarkViolet			: Int = 0x9400d3;
	static inline var DarkOrchid			: Int = 0x9932cc;
	static inline var DarkMagenta			: Int = 0x8b008b;
	static inline var Purple				: Int = 0x800080;
	static inline var Indigo				: Int = 0x4b0082;
	static inline var DarkSlateBlue			: Int = 0x483d8b;
	static inline var SlateBlue				: Int = 0x6a5acd;
	static inline var MediumSlateBlue		: Int = 0x7b68ee;
	static inline var White					: Int = 0xffffff;
	static inline var Snow					: Int = 0xfffafa;
	static inline var Honeydew				: Int = 0xf0fff0;
	static inline var MintCream				: Int = 0xf5fffa;
	static inline var Azure					: Int = 0xf0ffff;
	static inline var AliceBlue				: Int = 0xf0f8ff;
	static inline var GhostWhite			: Int = 0xf8f8ff;
	static inline var WhiteSmoke			: Int = 0xf5f5f5;
	static inline var Seashell				: Int = 0xfff5ee;
	static inline var Beige					: Int = 0xf5f5dc;
	static inline var OldLace				: Int = 0xfdf5e6;
	static inline var FloralWhite			: Int = 0xfffaf0;
	static inline var Ivory					: Int = 0xfffff0;
	static inline var AntiqueWhite			: Int = 0xfaebd7;
	static inline var Linen					: Int = 0xfaf0e6;
	static inline var LavenderBlush			: Int = 0xfff0f5;
	static inline var MistyRose				: Int = 0xffe4e1;
	static inline var Gainsboro				: Int = 0xdcdcdc;
	static inline var LightGray				: Int = 0xd3d3d3;
	static inline var Silver				: Int = 0xc0c0c0;
	static inline var DarkGray				: Int = 0xa9a9a9;
	static inline var Gray					: Int = 0x808080;
	static inline var DimGray				: Int = 0x696969;
	static inline var LightSlateGray		: Int = 0x778899;
	static inline var SlateGray				: Int = 0x708090;
	static inline var DarkSlateGray			: Int = 0x2f4f4f;
	static inline var Black					: Int = 0x000000;

	/**
	 * Apply alpha to a 24-bit RGB Int value, which results in a 32-bit ARGB value.
	 * Any alpha will be replaced.
	 * @param color 	The color
	 * @param a 		The alpha 0.0 <= a <= 1.0
	 */
	public static function applyAlpha( color : Int, a : Float ){
		var av : Int = Math.round( Math.clamp(a) * 255 );
		return (color & 0xffffff) | (av<<24);
	}

	/**
	 * Extract the alpha portion of a color as a float between 0 and 1.
	 * @param color 		The color
	 * @param zeroIsOpaque 	If the alpha component is zero, treat it as 1.0 (fully opaque)
	 */
	public static function getAlpha( color : Int , zeroIsOpaque : Bool = false ) : Float{
		var a : Int = (color>>24)&255;
		if ((a==0) && zeroIsOpaque) return 1;
		return a/255;
	}

	/**
	 * Return a 24-bit color (no alpha component) from the supplied RGB components
	 * @param 	R	The red component 0-255 
	 * @param 	G	The green component 0-255 
	 * @param 	B	The blue component 0-255  
	 * @return Int	The color
	 */
	public static function colorFromRGB( R : Int, G : Int, B : Int ) : Int{
		R = Math.iclamp( R, 0, 255 );
		G = Math.iclamp( R, 0, 255 );
		B = Math.iclamp( R, 0, 255 );
		return fastColorFromRGB( R, G, B );
	}

	/**
	 * Same as colorFromRGB but with no bounds checking on the arguments!
	 * @param 	R	The red component 0-255 
	 * @param 	G	The green component 0-255 
	 * @param 	B	The blue component 0-255  
	 * @return Int	The color
	 */
	public static inline function fastColorFromRGB( R : Int, G : Int, B : Int ) : Int{
		return (R<<16) & (G<<8) & B;
	}

	/**
	 * Return a 32-bit color from the supplied RGB and A components (alpha 0-255). Despite
	 * the order of the arguments to this function, the 32-bit color format is ARGBA.
	 * @param 	R	The red component 0-255 
	 * @param 	G	The green component 0-255 
	 * @param 	B	The blue component 0-255  
	 * @param 	A	The alpha component 0-255 
	 * @return Int	The color
	 */
	public static function colorFromRGBA( R : Int, G : Int, B : Int, A : Int ) : Int{
		R = Math.iclamp( R, 0, 255 );
		G = Math.iclamp( R, 0, 255 );
		B = Math.iclamp( R, 0, 255 );
		A = Math.iclamp( A, 0, 255 );
		return fastColorFromRGBA( R, G, B, A );
	}

	/**
	 * Return a 32-bit color from the supplied aRGB components (alpha 0.0-1.0). Despite
	 * the order of the arguments to this function, the 32-bit color format is ARGBA.
	 * @param 	R	The red component 0-255 
	 * @param 	G	The green component 0-255 
	 * @param 	B	The blue component 0-255  
	 * @param 	A	The alpha component 0.0-1.0
	 * @return Int	The color
	 */
	public static function colorFromRGBa( R : Int, G : Int, B : Int, a : Float ) : Int{
		var A : Int = Math.round(Math.clamp(a)*255);
		R = Math.iclamp( R, 0, 255 );
		G = Math.iclamp( R, 0, 255 );
		B = Math.iclamp( R, 0, 255 );
		return fastColorFromRGBA( R, G, B, A );
	}

	/**
	 * Same as colorFromRGBa but with no bounds checking on the arguments!
	 * @param 	R	The red component 0-255 
	 * @param 	G	The green component 0-255 
	 * @param 	B	The blue component 0-255  
	 * @param 	a	The alpha component 0.0-1.0 
	 * @return Int	The color
	 */
	public static inline function fastColorFromRGBa( R : Int, G : Int, B : Int, a : Float ) : Int{
		return (Math.round(a*255)<<24) & (R<<16) & (G<<8) & B;
	}

	/**
	 * Same as colorFromRGBA but with no bounds checking on the arguments!
	 * @param 	A	The alpha component 0-255 
	 * @param 	R	The red component 0-255 
	 * @param 	G	The green component 0-255 
	 * @param 	B	The blue component 0-255  
	 * @return Int	The color
	 */
	public static inline function fastColorFromRGBA( R : Int, G : Int, B : Int, A : Int ) : Int{
		return (A<<24) & (R<<16) & (G<<8) & B;
	}

}