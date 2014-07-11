package com.bykoko.infrastructure.task
{
	import com.bykoko.domain.AppDomain;
	import com.bykoko.domain.Constants;
	import com.bykoko.infrastructure.message.ProductMessage;
	import com.bykoko.infrastructure.message.ServiceMessage;
	import com.bykoko.infrastructure.message.TaskMessage;
	import com.bykoko.presentation.product.designer.EditableText;
	import com.bykoko.vo.order.Product;
	import com.bykoko.vo.xmlmapping.product.Articulo;
	
	import flashx.textLayout.conversion.TextConverter;
	
	import org.spicefactory.lib.task.Task;
	
	import spark.core.SpriteVisualElement;
	
	public class TaskSetFirstAvailableProductDisplay extends AbstractContextTask
	{
		[MessageDispatcher]
		public var dispatcher:Function;
		
		[Inject]
		[Bindable]
		public var appDomain:AppDomain;

		
		
		public function TaskSetFirstAvailableProductDisplay()
		{
			super();
		}
		
		override protected function doStartContext():void
		{
			appDomain.setFirstAvailableProductDisplay();
			dispatcher(new ProductMessage(ProductMessage.CHANGE_PRODUCT_DISPLAY))
			
			//task completed
			complete();
		}
	}
}