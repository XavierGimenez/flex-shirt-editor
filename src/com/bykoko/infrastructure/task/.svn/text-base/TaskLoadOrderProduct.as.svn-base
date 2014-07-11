package com.bykoko.infrastructure.task
{
	import com.bykoko.domain.AppDomain;
	import com.bykoko.infrastructure.message.ServiceMessage;
	import com.bykoko.infrastructure.message.TaskMessage;
	import com.bykoko.vo.order.Product;
	import com.bykoko.vo.xmlmapping.product.Articulo;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.spicefactory.lib.task.Task;
	
	public class TaskLoadOrderProduct extends AbstractContextTask
	{
		[MessageDispatcher]
		public var dispatcher:Function;
		
		[Inject]
		[Bindable]
		public var appDomain:AppDomain;

		
		
		public function TaskLoadOrderProduct()
		{
			super();
		}
		
		override protected function doStartContext():void
		{
			var serviceMessage:ServiceMessage = new ServiceMessage(ServiceMessage.GET_PRODUCT_BY_ID, onGetOrderProductCallback);
			serviceMessage.idProduct = (appDomain.order.products[0] as Product).productId;
			dispatcher(serviceMessage);
		}
		
		public function onGetOrderProductCallback(articulo:Articulo):void
		{
			appDomain.selectProduct(articulo);
			
			//after selecting the product. The image of the ProductDesigner.mxml
			//will fire a TaskMessage to notify that the product has been loaded
		}
		
		
		[MessageHandler(selector="loadProductResponse")]
		public function handleTaskMessage(taskMessage:TaskMessage):void
		{
			//before completing the task, select the color and size indicated in the order
			appDomain.selectedColorProduct = appDomain.selectedProduct.getColorById((appDomain.order.products[0] as Product).colorId);
			
			//setting the product color generates a new dataProvider for the size and also sets in the appDomain
			//the selected size to the first size available for the new color product -> wait some times for these
			//operations and then select the size indicated in the order
			var timer:Timer = new Timer(100, 1);
			timer.addEventListener(TimerEvent.TIMER, function(e:TimerEvent):void
			{
				timer.removeEventListener(TimerEvent.TIMER, arguments.callee);
				timer = null;
				appDomain.selectedSizeProduct = appDomain.selectedColorProduct.getTallaByRef((appDomain.order.products[0] as Product).sizeRef);
				complete();
			});
			timer.start();
		}
	}
}