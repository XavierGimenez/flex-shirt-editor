package com.bykoko.infrastructure.task
{
	import com.bykoko.infrastructure.message.ProductMessage;

	public class TaskUpdatePrice extends AbstractContextTask
	{
		[MessageDispatcher]
		public var dispatcher:Function;
		
		public function TaskUpdatePrice()
		{
			super();
		}
		
		override protected function doStartContext():void
		{
			dispatcher(new ProductMessage(ProductMessage.UPDATE_PRICE));
			
			//task completed
			complete();
		}
	}
}