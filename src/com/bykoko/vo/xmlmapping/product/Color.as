package com.bykoko.vo.xmlmapping.product
{
	import com.bykoko.util.VOUtil;

	[Bindable]
	public class Color
	{
		[Required]
		public var name:String;
		
		[Required]
		public var id:int;
		
		[Required]
		public var cat:int;
		
		[Required]
		public var scat:int;
		
		[Required]
		public var art:int;
		
		[Required]
		public var hex:String;
		
		[Required]
		public var path:String;
		
		[Required]
		public var front:String;
		
		[Required]
		public var back:String;
		
		[Required]
		public var left:String;
		
		[Required]
		public var right:String;
		
		[ChoiceType("com.bykoko.vo.xmlmapping.product.Tallas")]
		public var tallas:Tallas;
		
		
		public function getImageFileByDisplay(productDisplay:String):String
		{
			switch(productDisplay)
			{
				case VOUtil.POSITION_FRONT:
					return front;
					break;
				
				case VOUtil.POSITION_LEFT:
					return left;
					break;
				
				case VOUtil.POSITION_RIGHT:
					return right;
					break;
				
				case VOUtil.POSITION_BACK:
					return back;
					break;
				
				default:
					return front;
					break;
			}
		}
		
		
		public function getTallaByRef(ref:String):Talla
		{
			for each(var talla:Talla in tallas.tallas)
			{
				if(talla.ref == ref)
				{
					return talla;
				}
			}
			return null;
		}
	}
}