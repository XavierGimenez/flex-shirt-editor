package com.bykoko.vo.xmlmapping.product
{
	public class Articulos
	{
		//number of items
		[Required]
		public var total:int;
		
		//number of pages needed to display all the items
		[Required]
		public var ptotal:int;
		
		//current page
		public var pactual:int;
		
		[ChoiceType("com.bykoko.vo.xmlmapping.product.Articulo")]
		public var articulos:Array;
		
		
		public function getArticuloById(id:int):Articulo
		{
			for each(var articulo:Articulo in articulos)
			{
				if(articulo.id == id)
					return articulo;
			}
			return null;
		}
	}
}