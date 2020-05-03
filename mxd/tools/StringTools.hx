package mxd.tools;

using StringTools;

class StringTools{

	/**
	 * Return the number of occurances of character `c` in string `s`
	 * @param s 	The string
	 * @param c		The character code
	 * @return Int	The number of occurances
	 */
	public static function count( s : String, c : Int ){
		var n : Int = 0;
		for (i in 0...s.length) if (s.fastCodeAt(i)==c) n++;
		return n;
	}

	public static function contains( s : String, c : Int ){
		for (i in 0...s.length) if (s.fastCodeAt(i)==c) return true;
		return false;
	}

}