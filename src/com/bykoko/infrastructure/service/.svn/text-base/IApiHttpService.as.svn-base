package com.bykoko.infrastructure.service
{
	import com.bykoko.vo.ProductDisplaySnapshot;
	
	import mx.rpc.AsyncToken;

	public interface IApiHttpService
	{
		function getConfig():AsyncToken
		function getCategories():AsyncToken
		function getSubCategories():AsyncToken
		
		function getProductsByCategory(idCategory:int):AsyncToken
		function getProductsBySubcategory(idCategory:int, idSubcategory:int):AsyncToken
		function getProductById(idProduct:int):AsyncToken
			
		function getDesignsCategories():AsyncToken
		function getDesignById(idDesign:int):AsyncToken
		function getDesignsByCategory(idCategory:int):AsyncToken
			
		function sendOrder(urlPost:String, idOrder:String, orderTimeStamp:Number, profile:int, orderXML:XML):AsyncToken
			
		function getTeamCategories():AsyncToken;
		function getTeamSubCategories():AsyncToken;
		function getTeamProductsByCategory(idCategory:int):AsyncToken;
		function getTeamProductsBySubcategory(idCategory:int, idSubcategory:int):AsyncToken;
	}
}