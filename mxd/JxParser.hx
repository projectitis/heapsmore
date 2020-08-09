package mxd;

import h3d.pass.Default;
import mxd.EqParser;
using StringTools;

/**
 * Extend EqParser only so that error messages show correct position within the scope
 * of the JSON doc, rather than just the equation.
 */
class JxParser extends EqParser {

	var inComment : Bool = false;

	/**
	 * Constructor
	 */
	public function new() {
		super();
	}

	/**
	 * Decode a JX string 
	 * @param str 		The JX string to decode, or
	 * @param strs 		An array of JX strings to decode into the same object
	 * @return Dynamic	The resulting object
	 */
	public function decode( ?str : String, ?strs : Array<String> ) : Dynamic {
		pos = 0;
		if (strs == null) {
			if (str == null) return null;
			strs = new Array();
			strs.push( str );
		}
		else {
			if (str != null) strs.push( str );
		}
		var data : Dynamic = null;
		for (i in 0...strs.length) {
			this.str = strs[i];
			data = parseRec( data );
		}
		return data;
	}

	/**
	 * Parse a JX record from the document
	 * @param data 		The data object to parse to
	 */
	function parseRec( data : Dynamic = null ) : Dynamic {
trace('parseRec');
		while (true) {
			trace('  About to parseExpr');
			var token = parseExpr( false );
			if (token == null) return null;
			switch (token.type) {
				// Object
				case TTCustom('{'.code): {
					trace('  Start object');
					var obj = {}, field = null, sep:Null<Bool> = null;
					// Parse object
					while (true) {
						var t = parseToken();
						switch (t.type) {
							case TTCustom('}'.code): {
								if (field != null || sep == false) unexpected( t );
								trace('/parseRec');
								return obj;
							}
							case TTCustom(':'.code): {
								if (field == null) unexpected( t );
								Reflect.setField(obj, field, parseRec());
								field = null;
								sep = true;
							}
							case TTSeperator: {
								if (sep) sep = false else unexpected( t );
							}
							case TTString:
								if (field != null || sep) unexpected( t );
								field = t.value;
							default:
								unexpected( t );
						}
					}
				}
				// String etc?
				case TTString, TTNumber: {
					return token.value;
				}
				default:
					

			}
		}
		trace('/parseRec');
		return true;
	}

	/**
	 * Check if the character code is a valid token starter
	 * @param c 	The character code to check, or
	 * @return		True if the character code is a valid token starter
	 */
	override function isCustomStartCharacter( c : Int ) : Bool {
		switch (c) {
			case '{'.code, '['.code: return true;
			case '/'.code, ':'.code: return true;
			case '}'.code, ']'.code: return true;

			default: return false;
		}
	}

	/**
	 * Check if the character code is a valid token ender
	 * @param c 	The character code to check
	 * @return		True if the character code is a valid token ender
	 */
	override function isCustomEndCharacter( c : Int ) : Bool {
		switch (c) {
			case ':'.code, ']'.code, '}'.code, ','.code, ';'.code: return true;
			default: return false;
		}
	}
	
	/**
	 * Based on isCustomCharacter, creates the token
	 * @param c 		The character code
	 * @param token 	The token to modify
	 * @return Bool		True if the token is multi-character, of false if it should return immediately
	 */
	override function createCustomToken( c : Int, token : Token ) : Bool {
		switch (c) {
			case '{'.code, '['.code, ':'.code, '}'.code, ']'.code: {
				token.type = TTCustom( c );
				return false;
			}
			case '.'.code: {
				token.type = TTCustom( c );
				return true;
			}
			case '/'.code: {
				if ( peek() == '/'.code ) {
					token.type = TTCustom( '/'.code );
					next();
					return true;
				}
				else if ( peek() == '*'.code ) {
					token.type = TTCustom( '*'.code );
					next();
					return true;
				}
			}
		}
		return false;
	}

	/**
	 * Parse a character into a custom token
	 * @param c 		The character code
	 * @param token 	The token to modify
	 * @return Bool		True to finish parsing this token. False to continue parsing
	 */
	override function parseCustomToken( c : Int, token : Token ) : Bool {
		switch (token.type) {
			// Inline comment
			case TTCustom('/'.code): {
				if ( (c == '\n'.code) || (c == '\r'.code) ) return true;
			}
			// Block comment
			case TTCustom('*'.code): {
				if ( (c == '/'.code) && (peek(-2) == '*'.code) ) return true;
			}
			// Unhandled
			case TTCustom(t): {
				error('Unknown custom token of type "'+String.fromCharCode(t)+'"', pos-1);
			}
			default: // Ignore
		}
		return false;
	}

	/**
	 * A custom hook called at the end of parsing a token, when a token has been found
	 * @param token 	The populated token object
	 */
	override function onEndToken( token : Token ) {
		token.trace(4);
	}

	/**
	 * Custom hook called as a custom token is processed during expression parsing
	 * @param token 	The custom token
	 * @param stack		The token stack
	 * @return Int		0=skip to next token, -1=stop parsing expression, 1=continue parsing token
	 */
	override function processCustomToken( token : Token, stack : Stack ) : Int {
		switch (token.type) {
			// Start object
			case TTCustom('{'.code): return -1;
			// End key
			case TTCustom(':'.code): return -1;
			// End object
			case TTCustom('}'.code): return -1;
			// Unhandled
			case TTCustom(t): {
				error('Unknown custom token of type "'+String.fromCharCode(t)+'"', pos-1);
			}
			default: // Ignore
		}
		return 1;
	}

	override function onEndExpr(token:Token, stack:Stack):Bool {
		stack.trace();
		switch (token.type) {
			case TTCustom('}'.code): {
				rewind();
				return false;
			}
			case TTSeperator: {
				throw('Seperator found here');
			}
			default: {
				return true;
			}
		}
	}

}