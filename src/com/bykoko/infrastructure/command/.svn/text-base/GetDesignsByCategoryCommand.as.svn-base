package com.bykoko.infrastructure.command
{
	import com.bykoko.domain.AppDomain;
	import com.bykoko.infrastructure.message.ServiceMessage;
	import com.bykoko.vo.xmlmapping.design.Diseno;
	import com.bykoko.vo.xmlmapping.design.Disenos;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.AsyncToken;
	
	import org.spicefactory.lib.xml.mapper.XmlObjectMappings;

	public class GetDesignsByCategoryCommand extends BaseCommand
	{
		[Inject]
		public var appDomain:AppDomain;

		
		
		//
		override public function execute(message:ServiceMessage):AsyncToken
		{
			super.execute(message);			
			return service.getDesignsByCategory(message.idCategory);
		}
		
		
		
		//
		override public function result(data:Object):void
		{
			if(data == "")
				appDomain.designs = new ArrayCollection();
			else
			{
				//map the xml response
				mapper = XmlObjectMappings.
					forUnqualifiedElements().
					withRootElement(Disenos).
					mappedClasses(Diseno).build();
				
				//save the designs
				appDomain.designs = new ArrayCollection((mapper.mapToObject(data as XML) as Disenos).disenos);
			}
			super.result(data);
		}
	}
}