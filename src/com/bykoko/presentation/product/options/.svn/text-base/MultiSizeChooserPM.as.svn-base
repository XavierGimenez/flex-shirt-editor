package com.bykoko.presentation.product.options
{
	import com.bykoko.domain.AppDomain;
	import com.bykoko.domain.Constants;
	import com.bykoko.infrastructure.message.ProductMessage;
	import com.bykoko.vo.SizeReferenceRendererData;
	import com.bykoko.vo.xmlmapping.product.Talla;
	
	import mx.collections.ArrayCollection;
	
	import org.spicefactory.parsley.core.messaging.MessageProcessor;
	import org.spicefactory.parsley.core.messaging.impl.MessageDispatcher;

	[Event(name="sendValidation", type="com.bykoko.presentation.product.options.MultiSizeChooserEvent")]
	[ManagedEvents("sendValidation")]
	[Bindable]
	public class MultiSizeChooserPM
	{
		[Inject]
		public var appDomain:AppDomain;
		
		[MessageDispatcher]
		public var dispatcher:Function;

		
		
		/**************************************************************************************
		 * PUBLIC METHODS
		 *************************************************************************************/
		
		
		
		public function MultiSizeChooserPM()
		{
		}
		
		
		
		//
		public function generateViewData():void
		{
			appDomain.resetMultiSizeOrderData();
			checkEnableOrder();
		}
		
		
		
		/**************************************************************************************
		 * MESSAGES
		 *************************************************************************************/
		
		
		
		//
		[MessageInterceptor(type="com.bykoko.presentation.product.options.MultiSizeChooserEvent")]
		public function interceptChangeSizeEvent(processor:MessageProcessor):void
		{
			//Before handling the event with the MessageHandler, check if the multisizeChooser is active
			if(appDomain.UIConfig == Constants.UI_CONFIG_BIG_ACCOUNT)
			{
				processor.resume();
			}
			else
			{
				processor.cancel();
			}
		}
			
			
			
		//
		[MessageHandler]
		public function handleChangeSizeEvent(event:MultiSizeChooserEvent):void
		{
			switch(event.type)
			{
				case MultiSizeChooserEvent.CHANGE_SIZE:
					checkEnableOrder();
					break;
			}
		}
		
		
		
		[MessageHandler(selector='orderSent')]
		public function sendDataHandler(message:ProductMessage):void
		{
			generateViewData();
		}
		
		
		
		/**************************************************************************************
		 * PRIVATE METHODS
		 *************************************************************************************/
		
		
		
		//
		protected function checkEnableOrder():void
		{
			//to enable to order button:
			//check that there are, at least, one product size with amount > 0 and with a populated reference
			var event:MultiSizeChooserEvent = new MultiSizeChooserEvent(MultiSizeChooserEvent.SEND_VALIDATION);
			event.isValid = false;
			
			for each(var sizeReferenceRendererData:SizeReferenceRendererData in appDomain.multiSizeOrderData)
			{
				if(sizeReferenceRendererData.amount > 0)
				{
					event.isValid = true;
					break;
				}
			}
			
			dispatchEvent(event);
		}
	}
}