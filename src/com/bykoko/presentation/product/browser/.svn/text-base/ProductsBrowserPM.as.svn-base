package com.bykoko.presentation.product.browser
{
	import com.bykoko.domain.AppDomain;
	import com.bykoko.domain.ViewDomain;
	import com.bykoko.infrastructure.message.ServiceMessage;
	import com.bykoko.vo.xmlmapping.product.Categoria;
	import com.bykoko.vo.xmlmapping.product.Subcategoria;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;

	[Event(name="selectedCategoryChanged", type="flash.events.Event")]
	[Event(name="requestingData", type="flash.events.Event")]
	[Event(name="dataRequested", type="flash.events.Event")]
	public class ProductsBrowserPM extends EventDispatcher
	{
		[Inject]
		[Bindable]
		public var appDomain:AppDomain;
		
		[Inject]
		[Bindable]
		public var viewDomain:ViewDomain;
		
		[MessageDispatcher]
		public var dispatcher:Function;



		/**************************************************************************************
		 * PUBLIC METHODS
		 *************************************************************************************/
		
		

		//
		public function changeSelectedCategory(category:Categoria):void
		{
			//select the new category. If the new category does not have subcategories
			//do a request to show the products of the category, otherwhise show the
			//subcategories
			appDomain.selectedCategory = category;			
			if(appDomain.selectedCategory.subcategories.length > 0)
			{
				dispatchEvent(new Event("selectedCategoryChanged"));
			}
			else
			{
				//No subcategories for the selected category, get the products 
				//Notify to the view that data is being requested (view shows preloader) 
				dispatchEvent(new Event("requestingData"));
				
				//request data (check wether the current section is 'teams' or not
				var messageType:String = (viewDomain.isTeamsView == true)?	ServiceMessage.GET_TEAM_PRODUCTS_BY_CATEGORY : ServiceMessage.GET_PRODUCTS_BY_CATEGORY;	
				var message:ServiceMessage = new ServiceMessage(messageType, getProductsCallback);
				message.idCategory = appDomain.selectedCategory.id;
				dispatcher(message);
			}
		}
		
		
		
		//
		public function changeSelectedSubcategory(subcategory:Subcategoria):void
		{
			appDomain.selectedSubcategory = subcategory;
			
			//notify to the view that data is being requested (view shows preloader) 
			dispatchEvent(new Event("requestingData"));
			
			//request data (check wether the current section is 'teams' or not
			var messageType:String = (viewDomain.isTeamsView == true)?	ServiceMessage.GET_TEAM_PRODUCTS_BY_SUBCATEGORY : ServiceMessage.GET_PRODUCTS_BY_SUBCATEGORY;
			var message:ServiceMessage = new ServiceMessage(messageType, getProductsCallback);
			message.idCategory = appDomain.selectedCategory.id;
			message.idSubcategory = appDomain.selectedSubcategory.id;
			dispatcher(message);
		}
		
		
		
		/**************************************************************************************
		 * MESSAGES
		 *************************************************************************************/
		
		
		
		//
		[MessageHandler]
		public function handleSelectProductEvent(event:ProductItemRendererEvent):void
		{
			appDomain.selectProduct(event.articulo);
		}
		
		
		
		/**************************************************************************************
		 * PRIVATE METHODS
		 *************************************************************************************/
		
		
		
		//
		private function getProductsCallback():void
		{
			//notify to the view that data has been received (view removes preloader) 
			dispatchEvent(new Event("dataRequested"));
		}
	}
}