package mxd.tools;

import hxd.Math;

/**
 * Easing functions lifted from https://github.com/warrenm/AHEasing
 * Modified for Haxe
 */
class Easing{

	static var PI_2 = Math.PI/2;

	// Modeled after the line y = x
	public static function easeNone( p : Float ) : Float {
		return p;
	}

	// Modeled after the parabola y = x^2
	public static function quadraticEaseIn( p : Float ) : Float {
		return p * p;
	}

	// Modeled after the parabola y = -x^2 + 2x
	public static function quadraticEaseOut( p : Float ) : Float {
		return -(p * (p - 2));
	}

	// Modeled after the piecewise quadratic
	// y = (1/2)((2x)^2)             ; [0, 0.5)
	// y = -(1/2)((2x-1)*(2x-3) - 1) ; [0.5, 1]
	public static function quadraticEaseInOut( p : Float ) : Float {
		if(p < 0.5){
			return 2 * p * p;
		}
		else{
			return (-2 * p * p) + (4 * p) - 1;
		}
	}

	// Modeled after the cubic y = x^3
	public static function cubicEaseIn( p : Float ) : Float {
		return p * p * p;
	}

	// Modeled after the cubic y = (x - 1)^3 + 1
	public static function cubicEaseOut( p : Float ) : Float {
		var f : Float = (p - 1);
		return f * f * f + 1;
	}

	// Modeled after the piecewise cubic
	// y = (1/2)((2x)^3)       ; [0, 0.5)
	// y = (1/2)((2x-2)^3 + 2) ; [0.5, 1]
	public static function cubicEaseInOut( p : Float ) : Float {
		if(p < 0.5){
			return 4 * p * p * p;
		}
		else{
			var f : Float = ((2 * p) - 2);
			return 0.5 * f * f * f + 1;
		}
	}

	// Modeled after the quartic x^4
	public static function quarticEaseIn( p : Float ) : Float {
		return p * p * p * p;
	}

	// Modeled after the quartic y = 1 - (x - 1)^4
	public static function quarticEaseOut( p : Float ) : Float {
		var f : Float = (p - 1);
		return f * f * f * (1 - p) + 1;
	}

	// Modeled after the piecewise quartic
	// y = (1/2)((2x)^4)        ; [0, 0.5)
	// y = -(1/2)((2x-2)^4 - 2) ; [0.5, 1]
	public static function quarticEaseInOut( p : Float ) : Float {
		if(p < 0.5){
			return 8 * p * p * p * p;
		}
		else{
			var f : Float = (p - 1);
			return -8 * f * f * f * f + 1;
		}
	}

	// Modeled after the quintic y = x^5
	public static function quinticEaseIn( p : Float ) : Float {
		return p * p * p * p * p;
	}

	// Modeled after the quintic y = (x - 1)^5 + 1
	public static function quinticEaseOut( p : Float ) : Float {
		var f : Float = (p - 1);
		return f * f * f * f * f + 1;
	}

	// Modeled after the piecewise quintic
	// y = (1/2)((2x)^5)       ; [0, 0.5)
	// y = (1/2)((2x-2)^5 + 2) ; [0.5, 1]
	public static function quinticEaseInOut( p : Float ) : Float {
		if(p < 0.5){
			return 16 * p * p * p * p * p;
		}
		else{
			var f : Float = ((2 * p) - 2);
			return  0.5 * f * f * f * f * f + 1;
		}
	}

	// Modeled after quarter-cycle of sine wave
	public static function sineEaseIn( p : Float ) : Float {
		return Math.sin((p - 1) * Math.PI_2) + 1;
	}

	// Modeled after quarter-cycle of sine wave (different phase)
	public static function sineEaseOut( p : Float ) : Float {
		return Math.sin(p * Math.PI_2);
	}

	// Modeled after half sine wave
	public static function sineEaseInOut( p : Float ) : Float {
		return 0.5 * (1 - Math.cos(p * Math.PI));
	}

	// Modeled after shifted quadrant IV of unit circle
	public static function circularEaseIn( p : Float ) : Float {
		return 1 - Math.sqrt(1 - (p * p));
	}

	// Modeled after shifted quadrant II of unit circle
	public static function circularEaseOut( p : Float ) : Float {
		return Math.sqrt((2 - p) * p);
	}

	// Modeled after the piecewise circular function
	// y = (1/2)(1 - sqrt(1 - 4x^2))           ; [0, 0.5)
	// y = (1/2)(sqrt(-(2x - 3)*(2x - 1)) + 1) ; [0.5, 1]
	public static function circularEaseInOut( p : Float ) : Float {
		if(p < 0.5){
			return 0.5 * (1 - Math.sqrt(1 - 4 * (p * p)));
		}
		else{
			return 0.5 * (Math.sqrt(-((2 * p) - 3) * ((2 * p) - 1)) + 1);
		}
	}

	// Modeled after the exponential function y = 2^(10(x - 1))
	public static function exponentialEaseIn( p : Float ) : Float {
		return (p == 0.0) ? p : Math.pow(2, 10 * (p - 1));
	}

	// Modeled after the exponential function y = -2^(-10x) + 1
		public static function exponentialEaseOut( p : Float ) : Float {
		return (p == 1.0) ? p : 1 - Math.pow(2, -10 * p);
	}

	// Modeled after the piecewise exponential
	// y = (1/2)2^(10(2x - 1))         ; [0,0.5)
	// y = -(1/2)*2^(-10(2x - 1))) + 1 ; [0.5,1]
	public static function exponentialEaseInOut( p : Float ) : Float {
		if(p == 0.0 || p == 1.0) return p;
		
		if(p < 0.5){
			return 0.5 * Math.pow(2, (20 * p) - 10);
		}
		else{
			return -0.5 * Math.pow(2, (-20 * p) + 10) + 1;
		}
	}

	// Modeled after the damped sine wave y = sin(13pi/2*x)*pow(2, 10 * (x - 1))
	public static function elasticEaseIn( p : Float ) : Float {
		return Math.sin(13 * Math.PI_2 * p) * Math.pow(2, 10 * (p - 1));
	}

	// Modeled after the damped sine wave y = sin(-13pi/2*(x + 1))*pow(2, -10x) + 1
	public static function elasticEaseOut( p : Float ) : Float {
		return Math.sin(-13 * Math.PI_2 * (p + 1)) * Math.pow(2, -10 * p) + 1;
	}

	// Modeled after the piecewise exponentially-damped sine wave:
	// y = (1/2)*sin(13pi/2*(2*x))*pow(2, 10 * ((2*x) - 1))      ; [0,0.5)
	// y = (1/2)*(sin(-13pi/2*((2x-1)+1))*pow(2,-10(2*x-1)) + 2) ; [0.5, 1]
	public static function elasticEaseInOut( p : Float ) : Float {
		if(p < 0.5){
			return 0.5 * Math.sin(13 * Math.PI_2 * (2 * p)) * Math.pow(2, 10 * ((2 * p) - 1));
		}
		else{
			return 0.5 * (Math.sin(-13 * Math.PI_2 * ((2 * p - 1) + 1)) * Math.pow(2, -10 * (2 * p - 1)) + 2);
		}
	}

	// Modeled after the overshooting cubic y = x^3-x*sin(x*pi)
	public static function backEaseIn( p : Float ) : Float {
		return p * p * p - p * Math.sin(p * Math.PI);
	}

	// Modeled after overshooting cubic y = 1-((1-x)^3-(1-x)*sin((1-x)*pi))
	public static function backEaseOut( p : Float ) : Float {
		var f : Float = (1 - p);
		return 1 - (f * f * f - f * Math.sin(f * Math.PI));
	}

	// Modeled after the piecewise overshooting cubic function:
	// y = (1/2)*((2x)^3-(2x)*sin(2*x*pi))           ; [0, 0.5)
	// y = (1/2)*(1-((1-x)^3-(1-x)*sin((1-x)*pi))+1) ; [0.5, 1]
	public static function backEaseInOut( p : Float ) : Float {
		if(p < 0.5){
			var f : Float = 2 * p;
			return 0.5 * (f * f * f - f * Math.sin(f * Math.PI));
		}
		else{
			var f : Float = (1 - (2*p - 1));
			return 0.5 * (1 - (f * f * f - f * Math.sin(f * Math.PI))) + 0.5;
		}
	}

	public static function bounceEaseIn( p : Float ) : Float {
		return 1 - bounceEaseOut(1 - p);
	}

	public static function bounceEaseOut( p : Float ) : Float {
		if(p < 4/11.0){
			return (121 * p * p)/16.0;
		}
		else if(p < 8/11.0){
			return (363/40.0 * p * p) - (99/10.0 * p) + 17/5.0;
		}
		else if(p < 9/10.0){
			return (4356/361.0 * p * p) - (35442/1805.0 * p) + 16061/1805.0;
		}
		else{
			return (54/5.0 * p * p) - (513/25.0 * p) + 268/25.0;
		}
	}

	public static function bounceEaseInOut( p : Float ) : Float {
		if(p < 0.5){
			return 0.5 * bounceEaseIn(p*2);
		}
		else{
			return 0.5 * bounceEaseOut(p * 2 - 1) + 0.5;
		}
	}

}