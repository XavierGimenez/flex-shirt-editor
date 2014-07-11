package com.bykoko.vo.xmlmapping.svg
{
	public class Tspan
	{
		[Required]
		public var fontFamily:String;
		
		[Required]
		public var fontStyle:String;
		
		[Required]
		public var fontWeight:String;
		
		[Required]
		public var fontSize:int;
		
		/*[Required]
		public var textAnchor:String;
		*/
		[Required]
		public var fill:String; //in html format #xxxxxx
		
		[Required]
		[TextNode]
		public var text:String;	//text should contain CDATA closures <![CDATA[   ]]>
	}
}