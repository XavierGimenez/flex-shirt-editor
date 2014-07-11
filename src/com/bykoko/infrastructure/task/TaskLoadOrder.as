package com.bykoko.infrastructure.task
{
	import com.bykoko.domain.AppDomain;
	import com.bykoko.vo.order.EditableItem;
	import com.bykoko.vo.order.Order;
	import com.bykoko.vo.order.Product;
	import com.bykoko.vo.order.ProductDisplay;
	
	import mx.utils.Base64Decoder;
	
	import org.spicefactory.lib.xml.XmlObjectMapper;
	import org.spicefactory.lib.xml.mapper.XmlObjectMappings;
	
	public class TaskLoadOrder extends AbstractContextTask
	{
		[MessageDispatcher]
		public var dispatcher:Function;
		
		[Inject]
		[Bindable]
		public var appDomain:AppDomain;
		
		
		
		public function TaskLoadOrder()
		{
			super();
		}
		
		
		
		override protected function doStartContext():void
		{
			var decodedOrderSplitted:Array = appDomain.orderFlashvars.split('\\"');
			var decodedOrderEscaped:String = decodedOrderSplitted.join('"');
			
			appDomain.orderXML = new XML(decodedOrderEscaped);
			var mapper:XmlObjectMapper = XmlObjectMappings.
				forUnqualifiedElements().
				withRootElement(Order).
				mappedClasses(Order, Product, ProductDisplay, EditableItem).build();
			
			appDomain.order = mapper.mapToObject(appDomain.orderXML) as Order;
			trace(appDomain.orderXML);
			complete();
		}
	}
}