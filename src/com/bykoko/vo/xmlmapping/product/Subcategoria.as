package com.bykoko.vo.xmlmapping.product
{
	public class Subcategoria
	{
		//[Required]
		public var name:String;
		
		//[Required]
		public var id:int;
		
		//id of the category which the subcategory belong to
		//[Required]		
		public var cat:int;
	}
}