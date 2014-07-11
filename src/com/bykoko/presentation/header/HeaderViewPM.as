package com.bykoko.presentation.header
{
	import com.bykoko.domain.AppDomain;
	import com.bykoko.infrastructure.message.ProductMessage;

	public class HeaderViewPM
	{
		[Inject]
		[Bindable]
		public var appDomain:AppDomain;

		[MessageDispatcher]
		public var dispatcher:Function;
			
			
		
		
		public function resetDesign():void
		{
			//send message to remove the current product designs
			dispatcher( new ProductMessage(ProductMessage.REMOVE_ALL_DESIGNS))
		}
	}
}