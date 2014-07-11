package com.bykoko.vo.xmlmapping.design
{
	public class Disenos
	{
		//number of items
		[Required]
		public var total:int;
		
		//number of pages needed to display all the items
		[Required]
		public var ptotal:int;
		
		//current page
		public var pactual:int;
		
		[ChoiceType("com.bykoko.vo.xmlmapping.design.Diseno")]
		public var disenos:Array;
	}
}