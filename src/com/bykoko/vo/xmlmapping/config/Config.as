package com.bykoko.vo.xmlmapping.config
{
	import com.bykoko.vo.xmlmapping.product.Tallas;

	[Bindable]
	public class Config
	{	
		[Required]
		[ChildTextNode]
		public var logo:String;
		
		[Required]
		[ChildTextNode]
		public var upload_dir:String;
		
		//[Required]
		//if there is no default product in the setup, load the first from the first category/subcategory
		public var articulo:Articulo;
		
		[Required]
		[ChildTextNode]
		public var url_post:String;
		
		[Required]
		[ChildTextNode]
		public var url_root:String;
		
		[Required]
		[ChildTextNode]
		public var limit_art:int;
		
		[Required]
		[ChildTextNode]
		public var limit_url:String;
		
		[ChildTextNode]
		public var user_id:int;
		
		[Required]
		[ChildTextNode]
		public var id_pedido:String;
		
		[Required]
		[ChildTextNode]
		public var id_catalogo_mpr:int;
		
		public var text:Text;
		
		public var tallas:Tallas;
		
		[Required]
		public var team:Team;
		
		[Required]
		[ChildTextNode]
		public var modulo_disenos:int;
		
		[Required]
		[ChildTextNode]
		public var modulo_imagenes:int;
		
		[Required]
		[ChildTextNode]
		public var modulo_textos:int;
		
		[Required]
		[ChildTextNode]
		public var modulo_equipos:int;
		
		[Required]
		[ChildTextNode]
		public var modulo_multitallas:int;
		
		[Required]
		[ChildTextNode]
		public var show_price:int;
		
		[ChildTextNode]
		public var iva:Number;
		
		[ChildTextNode]
		public var lang:String;
	}
}