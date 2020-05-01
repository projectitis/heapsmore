package mxd;

import haxe.DynamicAccess;
import h2d.Font;
import m2d.ui.Box;
import h2d.Scene;

/**
 * Used when loading fonts from Json file
 */
typedef FontDescriptor = { name : String, path : String };

/**
 * An app based on the m2d UI objects
 */
class UIApp extends hxd.App{

	/**
	 * Store the viewport for global access
	 */
	public static var viewport : Scene;

	/**
	 * Store the fonts for global access
	 */
	public static var fonts : Map<String,Font> = new Map();

	/**
	 * Store styles for global access
	 */
	 public static var styles : Map<String,DynamicAccess<Dynamic>> = new Map();

	/**
	 * The base UI object for all UI elements. Additional UI elements should not be added directly to
	 * the scene. They may not behave as intended.
	 */
	public var background : m2d.ui.Box;

	/**
	 * Constructor. Create the UIApp.
	 */
	public function new(){
		super();
	}

	override public function init(){
		UIApp.viewport = this.s2d;
		background = new Box( this.s2d );
	}

	/**
	 * Grab a global font by name
	 * @param name 	The font name
	 * @return Font		The font, if it exists, or null
	 */
	public static function getFont( name : String ) : Font{
		return UIApp.fonts[name];
	}

	/**
	 * Grab a global style by name. This is sort of like a css class
	 * @param name 	The style name
	 * @return DynamicAccess<Dynamic> The style data
	 */
	public static function getStyle( name : String ) : DynamicAccess<Dynamic>{
		return UIApp.styles[name];
	}

	/**
	 * Create a UI structure from JSON. The json data contains the properties of the UI object, such
	 * as `width`, `height`, `padding`, `background` etc. The only required property is "type", which
	 * is the UI object type (`Box`, `TextArea` etc). To be useful, you'll likely also want an "id" so
	 * that the object can be referenced later. See the `fromData` method of a UI element (h2d.ui) to
	 * see which properties it accepts.
	 * Normal usage would be to load the json from a Resource: `UIApp.UIFromJSON( hxd.Res.MyJSONFile.toText() ,s2d );`
	 * 
	 * Example data structure:
	 * {
	 * 		"type": "Box",				// Not required. Base is ALWAYS a Box	
	 * 
	 * 		... properties of base ...
	 * 
	 * 		"fonts": {					// Two ways of specifying a font from a resource
	 * 			"my-font": "path/to/MyFont",
	 * 			"other-font": {
	 * 				"path": "path/to/OtherFont"
	 * 			}
	 * 		},
	 * 
	 * 		"styles": {
	 * 			"my-style": {
	 * 				"width": "50%",
	 * 				"padding": {
	 * 					"left": "10%",
	 * 					"right": "10%"
	 * 				}
	 * 			},
	 * 			"other-style": {
	 * 				"style": "my-style",		// Styles can include other styles. CAREFUL! don't create an infinite loop!
	 * 				"background": {
	 * 					"color": "0xff9900",
	 * 					"visible": "true"
	 * 				}
	 * 			}
	 * 		},
	 * 
	 * 		"children": [
	 * 			{
	 * 				"type": "Box",			// required	
	 * 				"id": "InnerLeftBox",
	 * 				"width": "30%",
	 * 				... properties of child 1 ...
	 * 				"style": "my-style",				// Also apply properties from this style
	 * 				"style": "my-style,other-style"		// Multiple styles (in order)
	 * 			},
	 * 			{
	 * 				"type": "Box",			// required	
	 * 				"id": "InnerRightBox",
	 * 				"width": "70%"
	 * 				... properties of child 2 ...
	 * 				"children": [
	 * 					... children of child 2 ...
	 * 				]
	 * 			},
	 * 			...
	 *		 ]
	 * }
	 * @param json 		The JSON file
	 * @param parent 	The parent display object
	 */
	public function fromJson( json : String ){
		fromData( haxe.Json.parse( json ) );
	}

	/**
	 * See description for `fromJson`. The JSON data is parsed to a DynamicAccess, which is then passed to
	 * this method to do the actual work. User methods that load UI data from another source should parse
	 * that data to a DynamicAccess<Dynamic> and also pass it to this method.
	 * @param data 		The data, usually from a JSON file
	 * @param parent 	The parent display object
	 */
	public function fromData( data : haxe.DynamicAccess<Dynamic> ){
		var elem : m2d.ui.Box = null;

		// Load fonts
		if (data.exists('fonts')){
			var fontsData : haxe.DynamicAccess<Dynamic> = data.get('fonts');
			for (name in fontsData.keys()){
				var fontData : haxe.DynamicAccess<Dynamic> = fontsData.get(name);
				var path : String = '';
				if (Std.is(fontData,String)) path = cast(fontData,String);
				else if (fontData.exists('path')) path = fontData.get('path');
				if (path!=''){
					try{
						if (path.substr(-4).toLowerCase()=='.bdf') UIApp.fonts[name] = hxd.Res.load(path).to(hxd.res.BDFFont).toFont();
						else UIApp.fonts[name] = hxd.Res.load(path).to(hxd.res.BitmapFont).toFont();
					}
					catch(e:Any) {
						throw 'The font \'$name\' could not be loaded from \'$path\'';
					}
				}
			}
		}

		// Load styles
		if (data.exists('styles')){
			var stylesData : haxe.DynamicAccess<Dynamic> = data.get('styles');
			for (name in stylesData.keys()){
				UIApp.styles[name] = stylesData.get(name);
			}
		}

		// Apply to teh root UI object, background (will also create children)
		background.fromData( data );
	}

}