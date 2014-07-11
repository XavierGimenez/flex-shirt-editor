package com.bykoko.vo.xmlmapping.config
{
	[Bindable]
	public class Text
	{
		[ChoiceType("com.bykoko.vo.xmlmapping.config.Colors")]
		public var colors:Colors;
		
		[ChoiceType("com.bykoko.vo.xmlmapping.config.Fonts")]
		public var fonts:Fonts;
	}
}