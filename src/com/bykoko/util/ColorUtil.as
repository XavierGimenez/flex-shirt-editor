package com.bykoko.util
{
	import flash.geom.ColorTransform;

	public class ColorUtil
	{
		private static const HEX_CHARACTERS:String="0123456789abcdef";
		
		public static function htmlStringToHexNumber(hexString:String):Number
		{
			return Number('0x' + hexString.substr(1));
		}
		
		public static function htmlStringToHexString(hexString:String):String
		{
			return String('0x' + hexString.substr(1));
		}
		
		public static function toHtmlString(n:int):String
		{
			var hexString:String = toHex(n);
			return String('#' + hexString.substr(2));
		}
		
		protected static function toHex(n:int):String
		{
			var hexString:String = n.toString(16).toUpperCase();
			while( hexString.length < 6 )
			{
				hexString = '0' + hexString;
			}
			return ("0x" + hexString);
		}
	}
}