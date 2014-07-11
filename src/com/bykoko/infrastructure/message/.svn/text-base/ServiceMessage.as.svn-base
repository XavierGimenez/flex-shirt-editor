package com.bykoko.infrastructure.message
{
	public class ServiceMessage extends MessageBase
	{
		//message types
		public static const GET_CONFIG:String = "getConfig";
		public static const GET_CATEGORIES:String = "getCategories";
		public static const GET_SUBCATEGORIES:String = "getSubCategories";
		public static const GET_PRODUCTS_BY_CATEGORY:String = "getProductByCategory";
		public static const GET_PRODUCTS_BY_SUBCATEGORY:String = "getProductBySubCategory";
		public static const GET_PRODUCT_BY_ID:String = "getProductById";
		public static const GET_DESIGN_CATEGORIES:String = "getDesignCategories";
		public static const GET_DESIGNS:String = "getDesigns";
		public static const GET_DESIGNS_BY_CATEGORY:String = "getDesignsByCategory";
		public static const SEND_ORDER:String = "sendOrder";
		public static const GET_TEAM_CATEGORIES:String = "getTeamCategories";
		public static const GET_TEAM_SUBCATEGORIES:String = "getTeamSubCategories";
		public static const GET_TEAM_PRODUCTS_BY_CATEGORY:String = "getTeamProductByCategory";
		public static const GET_TEAM_PRODUCTS_BY_SUBCATEGORY:String = "getTeamProductBySubCategory";
		
		
		//variables populated depending on the type of message
		public var idCategory:int;
		public var idSubcategory:int;
		public var idDesign:int;
		public var idProduct:int;
		
		//
		public function ServiceMessage(type:String, callbackFunction:Function = null, callbackParameters:Array = null)
		{
			super(type, callbackFunction, callbackParameters);
		}
	}
}