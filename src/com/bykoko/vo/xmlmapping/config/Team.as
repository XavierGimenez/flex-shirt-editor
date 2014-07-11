package com.bykoko.vo.xmlmapping.config
{
	public class Team
	{
		[Required]
		[ChildTextNode]
		public var colorId:int;
		
		[Required]
		[ChildTextNode]
		public var fontId:int;
		
		[Required]
		[ChildTextNode]
		public var fontSizeName:int;
		
		[Required]
		[ChildTextNode]
		public var fontSizeNum:int;
	}
}