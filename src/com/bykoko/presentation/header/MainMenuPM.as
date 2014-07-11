package com.bykoko.presentation.header
{
	import com.bykoko.domain.AppDomain;
	import com.bykoko.domain.ViewDomain;
	import com.bykoko.infrastructure.message.ProductMessage;
	import com.bykoko.infrastructure.message.ServiceMessage;
	import com.bykoko.infrastructure.task.SequentialContextTaskGroup;
	import com.bykoko.infrastructure.task.TaskLoadDefaultProduct;
	import com.bykoko.infrastructure.task.TaskServiceMessage;
	import com.bykoko.presentation.common.DialogWindow;
	
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	import mx.resources.ResourceManager;
	
	import org.spicefactory.lib.task.events.TaskEvent;
	import org.spicefactory.parsley.core.context.Context;

	public class MainMenuPM
	{
		[Inject]
		[Bindable]
		public var viewDomain:ViewDomain;
		
		[Inject]
		[Bindable]
		public var appDomain:AppDomain;

		[Inject]
		public var context:Context;
		
		[MessageDispatcher]
		public var dispatcher:Function;
		
		
		
		/**************************************************************************************
		 * PUBLIC METHODS
		 *************************************************************************************/
		
		
		
		//check if the navigation is going to/from the section 'teams'
		public function changeOption(index:int):void
		{
			if(index == ViewDomain.SECTION_TEAMS || viewDomain.indexPanel == ViewDomain.SECTION_TEAMS)
			{
				var dialogWindow:DialogWindow = new DialogWindow();
				dialogWindow.title = ResourceManager.getInstance().getString('Bundles','ALERT.TITLE.WARNING');
				dialogWindow.message = ResourceManager.getInstance().getString('Bundles', 'ALERT.RESET_NEW_DESIGN');
				dialogWindow.addEventListener(CloseEvent.CLOSE, function(event:CloseEvent):void
				{
					PopUpManager.removePopUp(dialogWindow);
					if(event.detail == Alert.OK)
					{
						//set this message as not interceptable as the Domain intercepts ProductMessages
						//and displays an alert to ProductMessages of type REMOVE_ALL_DESIGNS. In that case
						//we are already prompting the user with an alert, we don't want to do that twice
						dispatcher(new ProductMessage(ProductMessage.REMOVE_ALL_DESIGNS, null, null, false));

						if(index != ViewDomain.SECTION_TEAMS)
						{
							viewDomain.indexPanel = index;
							//in case we are going out from the section 'teams', we have to load default categories 
							//and subcategories and select the default product again.
							
							//we use the bootstrapTaskGroup because views handling the taskRequests check if
							//the bootstrapTaskGroup is not null
							appDomain.bootstrapTaskGroup = new SequentialContextTaskGroup(context);
							appDomain.bootstrapTaskGroup.addEventListener(TaskEvent.COMPLETE, function(event:TaskEvent):void
							{
								removeBootstrap();
							});
							appDomain.bootstrapTaskGroup.addTask(new TaskServiceMessage(ServiceMessage.GET_CATEGORIES));
							appDomain.bootstrapTaskGroup.addTask(new TaskServiceMessage(ServiceMessage.GET_SUBCATEGORIES));
							appDomain.bootstrapTaskGroup.addTask(new TaskLoadDefaultProduct());
							appDomain.bootstrapTaskGroup.start();
						}
						else
						{
							//going to teams section, load the categories/subcategories 
							appDomain.bootstrapTaskGroup = new SequentialContextTaskGroup(context);
							appDomain.bootstrapTaskGroup.addTask(new TaskServiceMessage(ServiceMessage.GET_TEAM_CATEGORIES));
							appDomain.bootstrapTaskGroup.addTask(new TaskServiceMessage(ServiceMessage.GET_TEAM_SUBCATEGORIES));
							appDomain.bootstrapTaskGroup.addEventListener(TaskEvent.COMPLETE, function(event:TaskEvent):void
							{
								removeBootstrap();
								viewDomain.indexPanel = index;
							});
							appDomain.bootstrapTaskGroup.start();
						}
					}
				});
				PopUpManager.addPopUp(dialogWindow, FlexGlobals.topLevelApplication.root, true);
				PopUpManager.centerPopUp(dialogWindow);
			}
			else
			{
				viewDomain.indexPanel = index;
				trace("viewDomain.indexPanel", viewDomain.indexPanel);
			}
		}
		
		

		/**************************************************************************************
		 * PRIVATE METHODS
		 *************************************************************************************/
		
		
		
		private function removeBootstrap():void
		{
			appDomain.bootstrapTaskGroup = null;
		}
	}
}