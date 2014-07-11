package com.bykoko.domain
{	
	import com.bykoko.infrastructure.message.ProductMessage;
	import com.bykoko.infrastructure.message.ServiceMessage;
	import com.bykoko.presentation.common.AlertWindow;
	import com.bykoko.presentation.common.DialogWindow;
	import com.bykoko.presentation.product.browser.ProductItemRenderer;
	import com.bykoko.presentation.product.browser.ProductItemRendererEvent;
	import com.bykoko.vo.xmlmapping.product.Articulo;
	import com.bykoko.vo.xmlmapping.product.Posicion;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	import mx.resources.ResourceManager;
	
	import org.spicefactory.parsley.core.messaging.MessageProcessor;

	[ResourceBundle("Bundles")]
	public class Domain
	{
		[Inject]
		[Bindable]
		public var appDomain:AppDomain;
		
		[Inject]
		[Bindable]
		public var viewDomain:ViewDomain;
		
		
		
		
		/**************************************************************************************
		 * MESSAGES
		 *************************************************************************************/
		
		
		
		[MessageInterceptor(type="com.bykoko.infrastructure.message.ProductMessage")]
		public function interceptProductMessage(processor:MessageProcessor):void
		{
			if(!(processor.message as ProductMessage).interceptable)
			{
				//this message is not interceptable, don't do anything with it, just proceed
				processor.resume();
				return;
			}
				
			switch((processor.message as ProductMessage).type)
			{
				//if user wants to start a new design, show an alert to ask for confirmation
				case ProductMessage.REMOVE_ALL_DESIGNS:
					showDialogWindowBeforeResumeMessage(ResourceManager.getInstance().getString('Bundles','ALERT.TITLE.WARNING'),
							ResourceManager.getInstance().getString('Bundles','ALERT.START_NEW_DESIGN'),
							processor);
					break;

				default:
					processor.resume();
					break;
			}				
		}
		
		
		[MessageInterceptor(type="com.bykoko.infrastructure.message.ServiceMessage")]
		public function interceptServiceMessage(processor:MessageProcessor):void
		{
			switch((processor.message as ServiceMessage).type)
			{
				//if the user wants to buy this product, check first that all the editable
				//items are inside the valid design areas
				case ServiceMessage.SEND_ORDER:
					if(!appDomain.productDesignIsRight)
					{
						showAlertWindowBeforeResumeMessage(ResourceManager.getInstance().getString('Bundles','ALERT.TITLE.WARNING'),
							ResourceManager.getInstance().getString('Bundles','ALERT.DESIGN_NOT_VALID'),
							processor);
					}
					else
						processor.resume();
						
					break;
				
				default:
					processor.resume();
					break;
			}				
		}
		
		/*
		[MessageInterceptor(type="com.bykoko.presentation.product.browser.ProductItemRendererEvent")]
		public function interceptProductItemRendererEvent(processor:MessageProcessor):void
		{
			//don't update if the selected product is the same, nothing changes
			if(appDomain.selectedProduct == ((processor.message as ProductItemRendererEvent).target as ProductItemRenderer).data as Articulo)
				return;
			
			//if the user selects a new product, show an alert to ask for confirmation
			//in case the current product has designs added to it
			if(appDomain.existsDesigns)
				showDialogWindowBeforeResumeMessage(ResourceManager.getInstance().getString('Bundles','ALERT.TITLE.WARNING'),
					ResourceManager.getInstance().getString('Bundles','ALERT.CHOOSE_NEW_PRODUCT'),
					processor);
			else
				processor.resume();
		}
		*/
		
		
		/**************************************************************************************
		 * PRIVATE METHODS
		 *************************************************************************************/
		
		
		
		public static function showAlertWindowBeforeResumeMessage(title:String, text:String, processor:MessageProcessor = null):void
		{
			var alertWindow:AlertWindow = new AlertWindow();
			alertWindow.title = title;
			alertWindow.message = text;
			alertWindow.addEventListener(CloseEvent.CLOSE, function(event:CloseEvent):void
			{
				PopUpManager.removePopUp(alertWindow);
				
				if(processor)
				{
					processor.cancel();
				}
				
			});
			PopUpManager.addPopUp(alertWindow, FlexGlobals.topLevelApplication.root, true);
			PopUpManager.centerPopUp(alertWindow);
		}
		
		
		
		private function showDialogWindowBeforeResumeMessage(title:String, text:String, processor:MessageProcessor):void
		{
			var dialogWindow:DialogWindow = new DialogWindow();
			dialogWindow.title = title;
			dialogWindow.message = text;
			dialogWindow.addEventListener(CloseEvent.CLOSE, function(event:CloseEvent):void
			{
				PopUpManager.removePopUp(dialogWindow);
				if(event.detail == Alert.OK)
					processor.resume();
				
			});
			PopUpManager.addPopUp(dialogWindow, FlexGlobals.topLevelApplication.root, true);
			PopUpManager.centerPopUp(dialogWindow);
		}
	}
}