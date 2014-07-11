package com.bykoko.vo.order
{
	public class ProductDisplay
	{
		[Required]
		public var position:String;
		
		[Required]
		public var price:Number

		[ChoiceType("com.bykoko.vo.order.EditableItem")]
		public var editableItems:Array = [];
		
		//snapshot image (base64 string)
		public var snapShot:String;
		
		public function ProductDisplay()
		{
		}
	}
}