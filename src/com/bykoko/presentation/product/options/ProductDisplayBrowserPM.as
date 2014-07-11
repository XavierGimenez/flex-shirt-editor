package com.bykoko.presentation.product.options
{
	import com.bykoko.domain.AppDomain;
	import com.bykoko.domain.Constants;
	import com.bykoko.infrastructure.message.ProductMessage;
	
	import org.spicefactory.parsley.core.messaging.impl.MessageDispatcher;

	public class ProductDisplayBrowserPM
	{
		[Inject]
		[Bindable]
		public var appDomain:AppDomain;

		[MessageDispatcher]
		public var dispatcher:Function;
		
		

		//
		public function nextProductDisplay():void
		{
			appDomain.nextProductDisplay(Constants.FORWARD);
		}
		
		
		
		//
		public function previousProductDisplay():void
		{
			appDomain.nextProductDisplay(Constants.BACKWARD);
		}
	}
}