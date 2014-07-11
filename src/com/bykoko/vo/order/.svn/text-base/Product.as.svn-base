package com.bykoko.vo.order
{
	import com.bykoko.vo.xmlmapping.product.Articulo;
	
	import org.spicefactory.lib.xml.XmlObjectMapper;
	import org.spicefactory.lib.xml.mapper.XmlObjectMappings;

	public class Product
	{
		[Required]
		public var productId:int;
		
		[Required]
		public var colorId:String;
		
		[Required]
		public var sizeRef:String;
		
		[Required]
		public var pvp:Number;
		
		[Required]
		public var unitPrice:Number;
		
		[Required]
		public var finalPrice:Number;
		
		[Required]
		public var quantity:int;
		
		//code of an existing product that has been loaded through the designer
		public var uprcod:String;
		
		//user code of an existing product that has been loaded through the designer
		public var uprusr:String;
		
		public var uprnom:String;
		
		//description of the product
		public var uprdes:String;
		
		//selling price set by the user
		public var uprpvp:Number = 0;
		
		//addition cost added by the owner of the creation. This addition is the difference between the base cost and the selling cost
		public var uprrec:Number = 0;

		//references for an specific client
		public var sizeRefInternal:String;

		[ChoiceType("com.bykoko.vo.order.ProductDisplay")]
		public var productDisplays:Array = [];

		

		public function Product()
		{
		}
		
		
		public function clone():Product
		{
			var mapper:XmlObjectMapper = XmlObjectMappings.
				forUnqualifiedElements().
				withRootElement(Product).
				mappedClasses(Product, ProductDisplay, EditableItem).build();
			
			var productXML:XML = mapper.mapToXml(this);
			return mapper.mapToObject(productXML) as Product;
		}
	}
}