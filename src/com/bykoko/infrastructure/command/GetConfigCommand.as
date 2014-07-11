package com.bykoko.infrastructure.command
{
	import com.bykoko.domain.AppDomain;
	import com.bykoko.infrastructure.message.ServiceMessage;
	import com.bykoko.vo.xmlmapping.config.Articulo;
	import com.bykoko.vo.xmlmapping.config.Color;
	import com.bykoko.vo.xmlmapping.config.Colors;
	import com.bykoko.vo.xmlmapping.config.Config;
	import com.bykoko.vo.xmlmapping.config.Font;
	import com.bykoko.vo.xmlmapping.config.Fonts;
	import com.bykoko.vo.xmlmapping.config.Team;
	import com.bykoko.vo.xmlmapping.config.Text;
	import com.bykoko.vo.xmlmapping.product.Talla;
	import com.bykoko.vo.xmlmapping.product.Tallas;
	
	import mx.rpc.AsyncToken;
	
	import org.spicefactory.lib.xml.mapper.XmlObjectMappings;

	public class GetConfigCommand extends BaseCommand
	{
		[Inject]
		public var appDomain:AppDomain;

		
		override public function execute(message:ServiceMessage):AsyncToken
		{
			super.execute(message);
			return service.getConfig();
		}
		
		
		
		//
		override public function result(data:Object):void
		{
			//map the xml response
			mapper = XmlObjectMappings.
				forUnqualifiedElements().
				withRootElement(Config).
				mappedClasses(Config, Articulo, Text, Colors, Color, Fonts, Font, Tallas, Talla, Team).build();

			//save the categories
			appDomain.config = mapper.mapToObject(data as XML) as Config;
			super.result(data);
		}
	}
}