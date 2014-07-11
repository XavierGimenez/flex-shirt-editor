package com.bykoko.infrastructure.command
{
	import com.bykoko.domain.AppDomain;
	import com.bykoko.infrastructure.message.ServiceMessage;
	import com.bykoko.vo.xmlmapping.design.Diseno;
	import com.bykoko.vo.xmlmapping.design.Disenos;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.AsyncToken;
	
	import org.spicefactory.lib.xml.mapper.XmlObjectMappings;

	public class GetDesignByIdCommand extends BaseCommand
	{
		[Inject]
		public var appDomain:AppDomain;

		
		
		//
		override public function execute(message:ServiceMessage):AsyncToken
		{
			super.execute(message);			
			return service.getDesignById(message.idDesign);
		}
		
		
		
		//
		override public function result(data:Object):void
		{
			//map the xml response
			mapper = XmlObjectMappings.
				forUnqualifiedElements().
				withRootElement(Disenos).
				mappedClasses(Diseno).build();
			
			var designs:ArrayCollection = new ArrayCollection((mapper.mapToObject(data as XML) as Disenos).disenos);
			if(callbackFunction != null)
				callbackFunction(designs.getItemAt(0) as Diseno);
			
			super.result(data);
		}
	}
}