package com.bykoko.infrastructure.command
{
	import com.bykoko.domain.AppDomain;
	import com.bykoko.infrastructure.message.ServiceMessage;
	import com.bykoko.vo.xmlmapping.product.Categoria;
	import com.bykoko.vo.xmlmapping.product.Categorias;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.AsyncToken;
	
	import org.spicefactory.lib.xml.mapper.XmlObjectMappings;

	public class GetTeamCategoriesCommand extends BaseCommand
	{
		[Inject]
		public var appDomain:AppDomain;

		
		override public function execute(message:ServiceMessage):AsyncToken
		{
			super.execute(message);
			return service.getTeamCategories();
		}
		
		
		
		//
		override public function result(data:Object):void
		{
			//map the xml response
			mapper = XmlObjectMappings.
				forUnqualifiedElements().
				withRootElement(Categorias).
				mappedClasses(Categoria).build();

			//save the categories
			appDomain.categories = new ArrayCollection((mapper.mapToObject(data as XML) as Categorias).categorias); 
			super.result(data);
		}
	}
}