package com.bykoko.vo.xmlmapping.config
{
	[Bindable]
	public class Colors
	{
		[ChoiceType("com.bykoko.vo.xmlmapping.config.Color")]
		public var color:Array;
		
		
		public function getColorById(id:int):Color
		{
			for each(var colorElement:Color in color)
			{
				if(colorElement.id == id)
					return colorElement;
			}
			return null;
		}
	}
}