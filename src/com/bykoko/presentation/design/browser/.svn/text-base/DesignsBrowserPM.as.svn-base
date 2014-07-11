package com.bykoko.presentation.design.browser
{
	import com.bykoko.domain.AppDomain;
	import com.bykoko.infrastructure.message.ProductMessage;
	import com.bykoko.infrastructure.message.ServiceMessage;
	import com.bykoko.presentation.product.designer.EditableDesign;
	import com.bykoko.vo.xmlmapping.design.Categoria;
	import com.bykoko.vo.xmlmapping.design.Diseno;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.events.ColorPickerEvent;
	
	import spark.components.supportClasses.ItemRenderer;
	

	[Event(name="requestingData", type="flash.events.Event")]
	[Event(name="dataRequested", type="flash.events.Event")]
	public class DesignsBrowserPM extends EventDispatcher
	{
		[Inject]
		[Bindable]
		public var appDomain:AppDomain;
		
		[MessageDispatcher]
		public var dispatcher:Function;
		
		
		
		/**************************************************************************************
		 * PUBLIC METHODS
		 *************************************************************************************/
		
		
		
		public function changeSelectedCategory(category:Categoria):void
		{
			//select the new category. If the new category does not have subcategories
			//do a request to show the products of the category, otherwhise show the
			//subcategories
			appDomain.selectedDesignCategory = category;			
			
			//notify to the view that data is being requested (view shows preloader) 
			dispatchEvent(new Event("requestingData"));
			
			//request data
			var message:ServiceMessage = new ServiceMessage(ServiceMessage.GET_DESIGNS_BY_CATEGORY, getDesignsCallback);
			message.idCategory = appDomain.selectedDesignCategory.id;
			dispatcher(message);
		}
		
		
		//changes the color of the selected design
		public function setDesignColor(event:ColorPickerEvent):void
		{
			if(appDomain.editableItem && appDomain.editableItem is EditableDesign)
			{
				(appDomain.editableItem as EditableDesign).color = event.color;
			}
		}
		
		
		
		//removes the color of the selected design
		public function resetDesignColor():void
		{
			if(appDomain.editableItem && appDomain.editableItem is EditableDesign)
			{
				(appDomain.editableItem as EditableDesign).resetColor();
			}
		}
		
		
		
		//
		public function selectDesign(design:Diseno, color:int = -1):void
		{
			var productMessage:ProductMessage = new ProductMessage(ProductMessage.DESIGN_SELECTED);
			productMessage.design = design;
			productMessage.designColor = color;
			dispatcher(productMessage);
		}
		
		
		
		/**************************************************************************************
		 * PRIVATE METHODS
		 *************************************************************************************/
		
		
		
		//
		private function getDesignsCallback():void
		{
			//notify to the view that data has been received (view removes preloader) 
			dispatchEvent(new Event("dataRequested"));
		}
	}
}