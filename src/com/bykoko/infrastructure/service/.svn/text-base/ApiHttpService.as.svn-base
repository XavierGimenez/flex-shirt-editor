package com.bykoko.infrastructure.service
{
	import com.bykoko.domain.AppDomain;
	import com.bykoko.domain.Constants;
	import com.bykoko.domain.Domain;
	import com.bykoko.util.StringUtil;
	import com.bykoko.vo.ProductDisplaySnapshot;
	
	import flash.net.URLRequestMethod;
	
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.http.HTTPService;
	
	public class ApiHttpService extends HTTPService implements IApiHttpService
	{
		[Inject]
		[Bindable]
		public var appDomain:AppDomain;
		
		private const ADD_PROFILE_AND_ORDER:Boolean = true;
		
		
		
		
		/******************************************************************************
		 * PUBLIC METHODS
		 *****************************************************************************/
		
		
		
		//
		public function ApiHttpService(rootURL:String=null, destination:String=null)
		{
			super(rootURL, destination);		
		}
		
		
		
		//
		public function getConfig():AsyncToken
		{
			return doServiceCall(Constants.url_config, ADD_PROFILE_AND_ORDER);
		}
		
		//
		public function getCategories():AsyncToken
		{
			return doServiceCall(appDomain.URL_SERVICE + "?do=categorias&equ=0");
		}
		
		//
		public function getSubCategories():AsyncToken
		{
			return doServiceCall(appDomain.URL_SERVICE + "?do=subcategorias&equ=0");
		}

		//
		public function getProductsByCategory(idCategory:int):AsyncToken
		{
			return doServiceCall(appDomain.URL_SERVICE + "?do=articulos&equ=0&cat=" + idCategory);
		}
		
		//
		public function getProductsBySubcategory(idCategory:int, idSubcategory:int):AsyncToken
		{
			return doServiceCall(appDomain.URL_SERVICE + "?do=articulos&equ=0&cat=" + idCategory + "&scat=" + idSubcategory);
		}

		//
		public function getProductById(idProduct:int):AsyncToken
		{
			return doServiceCall(appDomain.URL_SERVICE + "?do=articulos&art=" + idProduct);
		}
		
		//
		public function getDesignsCategories():AsyncToken
		{
			return doServiceCall(appDomain.URL_SERVICE + "?do=catdis");
		}
		
		//
		public function getDesignById(idDesign:int):AsyncToken
		{
			return doServiceCall(appDomain.URL_SERVICE + "?do=disenos&cod=" + idDesign);
		}
		
		
		//
		public function getDesignsByCategory(idCategory:int):AsyncToken
		{
			return doServiceCall(appDomain.URL_SERVICE + "?do=disenos&cat=" + idCategory);
		}

		//
		public function sendOrder(urlPost:String, idOrder:String, orderTimeStamp:Number, profile:int, orderXML:XML):AsyncToken
		{
			var params:Object = {};
			
			//timestamp of the send order 
			params["id_producto"] = orderTimeStamp;
			
			//xml information of the order
			params["order"] = StringUtil.htmlDecode(orderXML.toXMLString());

			trace(params["order"]);

			//idOrder, php session variable
			params["id_pedido"] = idOrder;
			
			//profile mode of the designer
			params["tip"] = profile;
					
			this.url = appDomain.URL_SEND_ORDER;
			this.contentType = CONTENT_TYPE_FORM;
			this.method = URLRequestMethod.POST;
			return this.send(params);
		}
		
		//
		public function getTeamCategories():AsyncToken
		{
			return doServiceCall(appDomain.URL_SERVICE + "?do=categorias&equ=1");
		}
		
		//
		public function getTeamSubCategories():AsyncToken
		{
			return doServiceCall(appDomain.URL_SERVICE + "?do=subcategorias&equ=1");
		}
		
		//
		public function getTeamProductsByCategory(idCategory:int):AsyncToken
		{
			return doServiceCall(appDomain.URL_SERVICE + "?do=articulos&equ=1&cat=" + idCategory);
		}
		
		//
		public function getTeamProductsBySubcategory(idCategory:int, idSubcategory:int):AsyncToken
		{
			return doServiceCall(appDomain.URL_SERVICE + "?do=articulos&equ=1&cat=" + idCategory + "&scat=" + idSubcategory);
		}
		
		
		
		/******************************************************************************
		 * PRIVATE METHODS
		 *****************************************************************************/
		
		
		
		//
		private function doServiceCall(action:String, addProfileAndOrder:Boolean = false):AsyncToken
		{
			//add some common params to the url
			action += "&catalogo=" + appDomain.catalogueId;
			
			if(addProfileAndOrder)
			{
				action += "&tip=" + appDomain.profile;
				action += (appDomain.orderFlashvars != null)? "&order=1":"&order=0";
			}
			
			this.url = action;
			this.resultFormat = RESULT_FORMAT_E4X;
			
			var call:AsyncToken = this.send();
			return call;
		}

	}
}