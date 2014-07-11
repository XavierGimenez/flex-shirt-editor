package com.bykoko.vo.xmlmapping.product
{
	import com.bykoko.domain.Constants;
	
	import flash.geom.Rectangle;

	public class Posicion
	{
		[Bindable]
		[Required]
		public var name:String;
		
		[Required]
		public var pvp:Number;
		
		[Required]
		public var piva:Number;
		
		[Required]
		public var id:int;
		
		[Required]
		public var x1:Number;
		
		[Required]
		public var x2:Number;
		
		[Required]
		public var y1:Number;
		
		[Required]
		public var y2:Number;
		
		[Required]
		public var dimx:Number;
		
		[Required]
		public var dimy:Number;
		
		public function getPrice(withTax:int):Number
		{
			return (withTax == Constants.TAX_WITH)?	piva:pvp;
		}
	}
}