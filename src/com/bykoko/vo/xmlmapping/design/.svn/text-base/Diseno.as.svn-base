package com.bykoko.vo.xmlmapping.design
{	
	import com.bykoko.domain.Constants;
	
	import spark.formatters.NumberFormatter;

	[Bindable]
	public class Diseno
	{
		public static const TYPE_IMAGE:int = 1;
		public static const TYPE_VECTOR:int = 2;
		
		[Required]
		public var name:String;
		
		[Required]
		public var id:int;
		
		[Required]
		public var usrcod:int;
		
		[Required]
		public var usr:String;
		
		[Required]
		public var logo:String;
		
		[Required]
		public var disenos:int;
		
		[Required]
		public var premios:int;
		
		[Required]
		public var estilos:String;
		
		[Required]
		public var pvp:Number;
		
		[Required]
		public var piva:Number;
		
		[Required]
		public var file:String;	//path of the original file
		
		//Optional, path of the svg version of the design
		public var svg:String;	
		
		//Optional, path of the swf version of the design
		public var swf:String;
		
		//Optional, dpi if the design is an image
		public var dpi:String;
		
		//type of the image
		[Required]
		public var tip:int;
		
		
		public function getPrice(withTax:int):Number
		{
			return (withTax == Constants.TAX_WITH)?	piva:pvp;
		}
	}
}