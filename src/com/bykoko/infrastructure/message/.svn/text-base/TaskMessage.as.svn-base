package com.bykoko.infrastructure.message
{
	import com.bykoko.vo.xmlmapping.config.Articulo;

	public class TaskMessage
	{
		[Selector]
		public var type:String;
		
		//message types
		public static const LOAD_PRODUCT_REQUEST:String = "loadProductRequest";
		public static const LOAD_PRODUCT_RESPONSE:String = "loadProductResponse";

		public static const CREATE_PRODUCT_SNAPSHOTS_REQUEST:String = "createProductSnapshotsRequest";
		public static const CREATE_PRODUCT_SNAPSHOTS_RESPONSE:String = "createProductSnapshotsResponse";
		
		public function TaskMessage(type:String)
		{
			this.type = type;
		}
	}
}