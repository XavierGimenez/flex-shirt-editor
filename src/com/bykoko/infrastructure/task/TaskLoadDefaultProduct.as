package com.bykoko.infrastructure.task
{
	import com.bykoko.domain.AppDomain;
	import com.bykoko.infrastructure.message.ServiceMessage;
	import com.bykoko.infrastructure.message.TaskMessage;
	import com.bykoko.vo.xmlmapping.config.Articulo;
	import com.bykoko.vo.xmlmapping.product.Articulo;
	import com.bykoko.vo.xmlmapping.product.Categoria;
	import com.bykoko.vo.xmlmapping.product.Subcategoria;
	
	import org.spicefactory.lib.task.Task;
	
	public class TaskLoadDefaultProduct extends AbstractContextTask
	{
		[MessageDispatcher]
		public var dispatcher:Function;
		
		[Inject]
		public var appDomain:AppDomain;
		
		
		public function TaskLoadDefaultProduct()
		{
			super();
		}

		override protected function doStartContext():void
		{
			//check if there is, in the config, a default product to be loaded. If not
			//check for the first product of the first category/subcategory in the catalog, this
			//will be the default product to load
			
			if(appDomain.config.articulo == null)
			{
				//populate the Articulo (config package) object with the required data
				var category:Categoria = appDomain.categories.getItemAt(0) as Categoria;

				appDomain.config.articulo = new com.bykoko.vo.xmlmapping.config.Articulo;
				appDomain.config.articulo.cat = category.id;
				
				//if the category has no subcategories, request the product for this category. 
				//Otherwise request product for the first subcategory
				var serviceMessage:ServiceMessage = new ServiceMessage(ServiceMessage.GET_PRODUCTS_BY_CATEGORY);
				serviceMessage.idCategory = appDomain.config.articulo.cat;
				if(category.subcategories.length > 0)
				{
					appDomain.config.articulo.scat = (category.subcategories.getItemAt(0) as Subcategoria).id;
					serviceMessage.type = ServiceMessage.GET_PRODUCTS_BY_SUBCATEGORY; 
					serviceMessage.idSubcategory = appDomain.config.articulo.scat;
				}
				
				serviceMessage.callbackFunction = function():void
				{
					appDomain.config.articulo.id = (appDomain.products.getItemAt(0) as com.bykoko.vo.xmlmapping.product.Articulo).id;
					
					//now we have the Articulo object (from the config), fully populated, continue the process of loading a default product
					dispatcher(new TaskMessage(TaskMessage.LOAD_PRODUCT_REQUEST));			
				};
				dispatcher(serviceMessage);
			}
			else
			{
				//we already have data of the default product to load => do service call
				dispatcher(new TaskMessage(TaskMessage.LOAD_PRODUCT_REQUEST));
			}
		}
		
		[MessageHandler(selector="loadProductResponse")]
		public function handleTaskMessage(taskMessage:TaskMessage):void
		{
			complete();
		}
	}
}