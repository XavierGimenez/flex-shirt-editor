package com.bykoko.vo
{
	import com.bykoko.vo.xmlmapping.product.Talla;

	[Bindable]
	public class SizeReferenceRendererData
	{
		public var amount:int;
		public var reference:String;
		protected var talla:Talla;
		
		
		public function SizeReferenceRendererData(talla:Talla)
		{
			this.talla = talla;
			amount = 0;
			reference = talla.refd;
		}
		
		public function get sizeLabel():String
		{
			return talla.name.toUpperCase();
		}
		
		public function set sizeLabel(value:String):void
		{
		}
		
		public function get sizeReference():String
		{
			return talla.ref;	
		}
	}
}