package com.bykoko.vo.xmlmapping.config
{
	[Bindable]
	public class Color
	{
		[Required]
		public var name:String;
		
		[Required]
		public var id:int;

		[Required]
		public var hex:String;
	}
}