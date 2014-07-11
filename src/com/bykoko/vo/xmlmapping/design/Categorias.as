package com.bykoko.vo.xmlmapping.design
{
	public class Categorias
	{
		[Required]
		public var total:int;
		
		[Required]		
		public var ptotal:int;
		
		[Required]
		public var pactual:int
		
		[ChoiceType("com.bykoko.vo.xmlmapping.design.Categoria")]
		public var categorias:Array;
	}
}