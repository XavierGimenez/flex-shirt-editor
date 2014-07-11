package com.bykoko.vo.xmlmapping.product
{
	import com.bykoko.domain.Constants;

	public class Articulo
	{
		[Required]
		public var name:String;
		
		[Required]
		public var pvp:Number;
		
		[Required]
		public var piva:Number;
		
		[Required]
		public var id:int;
		
		[Required]
		public var cat:int;
		
		[Required]
		public var scat:int;
		
		[ChoiceType("com.bykoko.vo.xmlmapping.product.Posiciones")]
		public var posiciones:Posiciones;
		
		[ChoiceType("com.bykoko.vo.xmlmapping.product.Colores")]
		public var colores:Colores;
		
		
		public function getPrice(withTax:int):Number
		{
			return (withTax == Constants.TAX_WITH)?	piva:pvp;
		}
		
		
		public function getColorById(colorId:String):Color
		{
			for each(var color:Color in colores.colores)
			{
				if(color.id == int(colorId))
				{
					return color;
				}
			}
			return null;
		}
	}
}