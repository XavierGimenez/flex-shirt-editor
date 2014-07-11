package com.bykoko.infrastructure.command
{
	import com.bykoko.domain.AppDomain;
	import com.bykoko.infrastructure.message.ServiceMessage;
	import com.bykoko.vo.xmlmapping.product.Subcategoria;
	import com.bykoko.vo.xmlmapping.product.Subcategorias;
	
	import mx.rpc.AsyncToken;
	
	import org.spicefactory.lib.xml.mapper.XmlObjectMappings;

	public class GetSubCategoriesCommand extends BaseCommand
	{
		[Inject]
		public var appDomain:AppDomain;
		
		
		
		override public function execute(message:ServiceMessage):AsyncToken
		{
			super.execute(message);
			return service.getSubCategories();
		}
		
		
		//
		override public function result(data:Object):void
		{
			//map the xml response
			mapper = XmlObjectMappings.
				forUnqualifiedElements().
				withRootElement(Subcategorias).
				mappedClasses(Subcategoria).build();
			
			//save the subcategories into its category
			appDomain.subcategories = (mapper.mapToObject(data as XML) as Subcategorias).subcategorias;
			super.result(data);
		}
	}
}