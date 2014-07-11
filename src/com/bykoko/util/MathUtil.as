package com.bykoko.util
{
	public class MathUtil
	{
		protected static const KILOBIT:Number=1024;
		protected static const MEGABIT:Number=1048576;
		
		public static function randFloat(min:Number, max:Number = NaN):Number 
		{
			if(isNaN(max)) 
			{ 
				max = min; 
				min = 0; 
			}
			return Math.random()*(max-min)+min;
		}
		
		
		
		public static function randInteger(min:Number, max:Number = NaN):int 
		{
			if(isNaN(max)) 
			{ 
				max = min; 
				min = 0; 
			}
			return Math.floor(randFloat(min,max));
		}
		
		
		
		public static function angle2radian(a:Number):Number
		{
			return resolveAngle(a) * Math.PI / 180;
		}
		
		
		public static function radian2angle(r:Number):Number 
		{
			return resolveAngle(r * 180 / Math.PI);
		}
		
		
		public static function resolveAngle(a:Number):Number 
		{
			var mod:Number=a % 360;
			return (mod < 0) ? 360 + mod : mod;
		}
		
		
		public static function byte2Megabyte(n:Number):Number
		{
			return n / MEGABIT;
		}

		public static function byte2Kilobyte(n:Number):Number
		{
			return n / KILOBIT;
		}
		
		public static function isInRange(n:Number,min:Number,max:Number,blacklist:Array=null):Boolean 
		{
			if(!blacklist || blacklist.length < 1) return (n >= min && n <= max);
			if(blacklist.length > 0)
			{
				for(var i:String in blacklist) if(n == blacklist[i]) return false;
			}
			return false;
		}
		
		//Round to a given amount of decimals.
		public static function round(val:Number, decimal:Number):Number 
		{
			return Math.round(val*Math.pow(10,decimal))/Math.pow(10,decimal);
		}
		
		
		/**
		 * Clamp constrains a value to the defined numeric boundaries.
		 * 
		 * @example
		 * <listing>		
		 * utils.math.clamp(20,2,5); //returns 5
		 * utils.math.clamp(3,2,5); //returns 3
		 * utils.math.clamp(3,1,5); //returns 3
		 * utils.math.clamp(1,10,20); //returns 10
		 * </listing>
		 * 
		 * @param val The number.
		 * @param min The minumum range.
		 * @param max The maximum range.
		 */
		public static function clamp(val:Number,min:Number,max:Number):Number
		{
			if(val < min) return min;
			if(val > max) return max;
			return val;
		}
	}
}