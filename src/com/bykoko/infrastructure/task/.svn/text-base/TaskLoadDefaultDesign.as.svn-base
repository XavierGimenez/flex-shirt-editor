package com.bykoko.infrastructure.task
{
	import com.bykoko.infrastructure.message.ProductMessage;
	import com.bykoko.infrastructure.message.ServiceMessage;
	import com.bykoko.vo.xmlmapping.design.Diseno;

	public class TaskLoadDefaultDesign extends AbstractContextTask
	{
		[MessageDispatcher]
		public var dispatcher:Function;
		
		private var idDesign:int;
		
		public function TaskLoadDefaultDesign(idDesign:int)
		{
			super();
			this.idDesign = idDesign;
		}
		
		override protected function doStartContext():void
		{
			var serviceMessage:ServiceMessage = new ServiceMessage(ServiceMessage.GET_DESIGNS, onGetDesignsCallback);
			serviceMessage.idDesign = idDesign; 
			dispatcher(serviceMessage);
		}
		
		public function onGetDesignsCallback(design:Diseno):void
		{
			//send a message to add this design to the product
			var productMessage:ProductMessage = new ProductMessage(ProductMessage.DESIGN_SELECTED);
			productMessage.design = design;
			dispatcher(productMessage);
			
			//task completed
			complete();
		}
	}
}