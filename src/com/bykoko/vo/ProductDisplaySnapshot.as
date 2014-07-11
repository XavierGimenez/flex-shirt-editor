package com.bykoko.vo
{
	
	//snap shot of a product display sent to the server (the snapshot does not include the product image, just the designs)
	public class ProductDisplaySnapshot
	{
		//id of the product display
		public var id:String;
		
		//Base-64 encoded string of the ImageSnapshot instance
		public var base64StringImage:String;
		
		public function ProductDisplaySnapshot(id:String, base64StringImage:String)
		{
			this.id = id;
			this.base64StringImage = base64StringImage;
		}
	}
}