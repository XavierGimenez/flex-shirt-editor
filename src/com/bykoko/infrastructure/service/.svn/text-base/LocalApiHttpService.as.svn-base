package com.bykoko.infrastructure.service
{
	import com.bykoko.domain.Constants;
	import com.bykoko.domain.Domain;
	
	import flash.net.URLRequestMethod;
	
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.http.HTTPService;
	
	public class LocalApiHttpService extends HTTPService implements IApiHttpService
	{
		
		
		/******************************************************************************
		 * PUBLIC METHODS
		 *****************************************************************************/
		
		
		
		//
		public function LocalApiHttpService(rootURL:String=null, destination:String=null)
		{
			super(rootURL, destination);			
		}
		
		
		
		//
		public function getConfig():AsyncToken
		{
			this.url = "setup.xml"; //Domain.URL_SERVICE + action;
			this.resultFormat = RESULT_FORMAT_E4X;
			
			var call:AsyncToken = this.send();
			return call;
		}
		
		
		
		//
		public function getCategories():AsyncToken
		{
			return doServiceCall("?do=categorias");
		}
		
		//
		public function getSubCategories():AsyncToken
		{
			return doServiceCall("?do=subcategorias");
		}

		//
		public function getProductsByCategory(idCategory:int):AsyncToken
		{
			return doServiceCall("?do=articulos&cat=" + idCategory);
		}
		
		//
		public function getProductsBySubcategory(idCategory:int, idSubcategory:int):AsyncToken
		{
			return doServiceCall("?do=articulos&cat=" + idCategory + "&scat=" + idSubcategory);
		}
		
		//
		public function getDesignsCategories():AsyncToken
		{
			return doServiceCall("?do=catdis");
		}
		
		//
		public function getDesignsByCategory(idCategory:int):AsyncToken
		{
			return doServiceCall("?do=disenos&cat=" + idCategory);
		}

		//
		public function sendOrder(urlPost:String, idOrder:String, orderTimeStamp:Number, orderXML:XML):AsyncToken
		{
			trace("order:");
			trace(orderXML);
			var params:Object = {};
			params["order"] = orderXML;
			this.url = Constants.URL_ROOT + "getData.php";
			this.contentType = CONTENT_TYPE_FORM;
			this.method = URLRequestMethod.POST;
			return this.send(params);
		}
		
		
		/******************************************************************************
		 * PRIVATE METHODS
		 *****************************************************************************/
		
		
		
		//
		private function doServiceCall(action:String):AsyncToken
		{
			this.url = Constants.URL_SERVICE + action;
			this.resultFormat = RESULT_FORMAT_E4X;
			
			var call:AsyncToken = this.send();
			return call;
		}

	}
}