package com.bykoko.presentation.product.options
{
	import com.bykoko.domain.AppDomain;
	import com.bykoko.domain.Constants;
	import com.bykoko.domain.ViewDomain;
	import com.bykoko.infrastructure.message.ProductMessage;
	import com.bykoko.infrastructure.message.ServiceMessage;
	import com.bykoko.infrastructure.task.SequentialContextTaskGroup;
	import com.bykoko.infrastructure.task.TaskCreateProductSnapshots;
	import com.bykoko.infrastructure.task.TaskLoadDefaultProduct;
	import com.bykoko.infrastructure.task.TaskServiceMessage;
	import com.bykoko.presentation.common.AlertWindow;
	import com.bykoko.presentation.common.DialogWindow;
	import com.bykoko.vo.ProductDisplayInfo;
	import com.bykoko.vo.xmlmapping.product.Color;
	import com.bykoko.vo.xmlmapping.product.Talla;
	
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	import mx.resources.ResourceManager;
	
	import org.spicefactory.lib.task.events.TaskEvent;
	import org.spicefactory.parsley.core.context.Context;

	[Bindable]
	public class ProductOptionsPM
	{
		[Inject]
		public var viewDomain:ViewDomain;
		
		[Inject]
		public var appDomain:AppDomain;
		
		[Inject]
		public var context:Context;
		
		[MessageDispatcher]
		public var dispatcher:Function;	

		public var enableOrder:Boolean = true;

		
		
		/**************************************************************************************
		 * PUBLIC METHODS
		 *************************************************************************************/
		

		
		[Init]
		public function init():void
		{
			//checks if the order button is enabled
			//for the default config, the default initial quantity is 1 so mantain the button enabled.
			//for the config for big accounts, the default quantity of multisize chooser is zero
			enableOrder = (appDomain.UIConfig == Constants.UI_CONFIG_DEFAULT);
		}
		
		
		
		public function changeProductDisplay(productDisplayInfo:ProductDisplayInfo):void
		{
			appDomain.currentProductDisplay = productDisplayInfo.id;
		}
		
		
		public function changeProductColor(productColor:Color):void
		{
			appDomain.selectedColorProduct = productColor;
		}
		
		
		
		public function changeProductSize(productSize:Talla):void
		{
			appDomain.selectedSizeProduct = productSize;
		}
		
		
		public function sendData():void
		{
			//first execute the task of creating snapshots of the product+designs
			var taskGroup:SequentialContextTaskGroup = new SequentialContextTaskGroup(context);
			taskGroup.addTask(new TaskCreateProductSnapshots());
			taskGroup.addEventListener(TaskEvent.COMPLETE, function onTaskComplete(event:TaskEvent):void
			{
				taskGroup.removeEventListener(TaskEvent.COMPLETE, arguments.callee);
				taskGroup = null;
				
				dispatcher( new ServiceMessage(ServiceMessage.SEND_ORDER, sendDataHandler));
			});
			taskGroup.start();
		}

		
		
		/**************************************************************************************
		 * MESSAGES
		 *************************************************************************************/
		

		
		//When the multisize chooser is active, send the result of validating all the fields everytime
		//there is a change on them. This will enable/disable the order button
		[MessageHandler(selector='sendValidation')]
		public function handlerMultiSizeChooserEvent(event:MultiSizeChooserEvent):void
		{
			enableOrder = event.isValid;
		}
		
		
		
		
		[MessageHandler(selector='orderSent')]
		public function sendDataHandler(message:ProductMessage):void
		{
			//the order has been sent. Based on the profile mode of the application
			//the user will be redirected to an URL or will remain in the app.
			switch(appDomain.profile)
			{
				case Constants.PROFILE_ANONYMOUS:
					//for a not-logged user, an alert is shown (continue / go to basket)
					alertGoToBasket();
					break;
				
				default:
					//for the rest of profile modes, a message is shown and the user
					//is redirected to an url
					alertOrderFinished();
					break;
			}
		}

		
		
		/**************************************************************************************
		 * PRIVATE METHODS
		 *************************************************************************************/
		
		
		
		private function alertGoToBasket():void
		{
			var dialogWindow:DialogWindow = new DialogWindow();
			dialogWindow.title = ResourceManager.getInstance().getString('Bundles','ALERT.ORDER.FEEDBACK.ANONYMOUS.TITLE');
			dialogWindow.message = ResourceManager.getInstance().getString('Bundles', 'ALERT.ORDER.FEEDBACK.ANONYMOUS.PROMPT');
			dialogWindow.firstButtonLabel = ResourceManager.getInstance().getString('Bundles','ALERT.ORDER.FEEDBACK.ANONYMOUS.BTN.GOTOBASKET');
			dialogWindow.secondButtonLabel = ResourceManager.getInstance().getString('Bundles','ALERT.ORDER.FEEDBACK.ANONYMOUS.BTN.CONTINUE');
			dialogWindow.addEventListener(CloseEvent.CLOSE, function(event:CloseEvent):void
			{
				PopUpManager.removePopUp(dialogWindow);
				if(event.detail == Alert.OK)
				{
					//go to an url
					navigateToURL( new URLRequest(Constants.url_redirect), "_self");
				}
				else if(event.detail == Alert.CANCEL)
				{
					var isOrderFromTeams:Boolean = (viewDomain.indexPanel == ViewDomain.SECTION_TEAMS);
					
					dispatcher(new ProductMessage(ProductMessage.REMOVE_ALL_DESIGNS, null, null, !isOrderFromTeams));
					dispatcher(new ProductMessage(ProductMessage.SELECT_PRODUCTS_OPTIONS));
					viewDomain.indexPanel = ViewDomain.PANEL_PRODUCTS_BROWSER;
					
					//continue creating products. Check wether we are in the "Team" sections. If so, 
					//we have to load default categories and subcategories and select the default product again
					if(isOrderFromTeams)
					{
						//we use the bootstrapTaskGroup because views handling the taskRequests check if
						//the bootstrapTaskGroup is not null
						
						appDomain.bootstrapTaskGroup = new SequentialContextTaskGroup(context);
						appDomain.bootstrapTaskGroup = new SequentialContextTaskGroup(context);
						appDomain.bootstrapTaskGroup.addEventListener(TaskEvent.COMPLETE, function(taskEvent:TaskEvent):void
						{
							appDomain.bootstrapTaskGroup.removeEventListener(taskEvent.type, arguments.callee);
							appDomain.bootstrapTaskGroup = null;
						});
						appDomain.bootstrapTaskGroup.addTask(new TaskServiceMessage(ServiceMessage.GET_CATEGORIES));
						appDomain.bootstrapTaskGroup.addTask(new TaskServiceMessage(ServiceMessage.GET_SUBCATEGORIES));
						appDomain.bootstrapTaskGroup.addTask(new TaskLoadDefaultProduct());
						appDomain.bootstrapTaskGroup.start();
					}
				}
				
			});
			PopUpManager.addPopUp(dialogWindow, FlexGlobals.topLevelApplication.root, true);
			PopUpManager.centerPopUp(dialogWindow);
		}
		
		
		
		private function alertOrderFinished():void
		{
			var alertWindow:AlertWindow = new AlertWindow();
			alertWindow.title = ResourceManager.getInstance().getString('Bundles','ALERT.ORDER.FEEDBACK.USER.TITLE');
			alertWindow.message = ResourceManager.getInstance().getString('Bundles', 'ALERT.ORDER.FEEDBACK.USER.PROMPT');
			alertWindow.addEventListener(CloseEvent.CLOSE, function(event:CloseEvent):void
			{
				PopUpManager.removePopUp(alertWindow);
				navigateToURL( new URLRequest(Constants.url_redirect), "_self");
			});
			PopUpManager.addPopUp(alertWindow, FlexGlobals.topLevelApplication.root, true);
			PopUpManager.centerPopUp(alertWindow);
		}
	}
}