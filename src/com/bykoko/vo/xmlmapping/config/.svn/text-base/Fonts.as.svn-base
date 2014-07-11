package com.bykoko.vo.xmlmapping.config
{
	import flash.text.Font;
	
	import mx.collections.ArrayCollection;

	[Bindable]
	public class Fonts
	{
		[ChoiceType("com.bykoko.vo.xmlmapping.config.Font")]
		public var font:Array;

		
		
		//get the embeded fonts of the application that are targeted to
		//be used for the editable texts
		public function get fontsForEditableTexts():ArrayCollection
		{
			var fontsForEditableText:ArrayCollection = new ArrayCollection();
			var filterFunction:Function = function(item:com.bykoko.vo.xmlmapping.config.Font, index:int, array:Array):Boolean
			{
				return(item.family == font.fontName);
			}
			
			for each(var font:flash.text.Font in flash.text.Font.enumerateFonts(false))
			{
				//if(font.filter(filterFunction).length > 0)
					fontsForEditableText.source.push(font);
			}
			return fontsForEditableText;
		}
		
		
		public function getFontById(id:int):com.bykoko.vo.xmlmapping.config.Font
		{
			for each(var fontElement:com.bykoko.vo.xmlmapping.config.Font in font)
			{
				if(fontElement.id == id)
					return fontElement;
			}
			return null;
		}
	}
}