package com.bykoko.infrastructure.task
{
	import com.bykoko.infrastructure.message.ServiceMessage;
	import com.bykoko.util.DictionaryUtil;
	import com.bykoko.vo.xmlmapping.design.Diseno;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;

	public class TaskLoadBootstrapDesignById extends AbstractContextTask
	{
		[MessageDispatcher]
		public var dispatcher:Function;
		
		protected var loader:Loader;
		private var editableItem:XML;
		private var idDesign:int;
		private var designs:Dictionary;
		private var SWFs:Dictionary;;
		
		public function TaskLoadBootstrapDesignById(editableItem:XML, designs:Dictionary, SWFs:Dictionary)
		{
			super();
			this.editableItem = editableItem;
			this.idDesign = editableItem.@id;
			this.designs = designs;
			this.SWFs = SWFs;
		}
		
		override protected function doStartContext():void
		{
			//don't ask for the same design several times. On the other hand, the swf need to be loaded
			//several times: if we have to use the same swf several times, we can not load once and then
			//add it to displayList several times (that is not allowed by the runtime player)
			var existingDesign:Diseno;
			for each(var diseno:Diseno in DictionaryUtil.values(designs))
			{
				if(diseno.id == idDesign)
				{
					existingDesign = diseno;
				}
			}
			
			if(existingDesign)
			{
				designs[editableItem] = existingDesign;
				loadSWF(existingDesign.swf);
			}
			else
			{
				var serviceMessage:ServiceMessage = new ServiceMessage(ServiceMessage.GET_DESIGNS, onGetDesignsCallback);
				serviceMessage.idDesign = idDesign; 
				dispatcher(serviceMessage);
			}
		}
		
		public function onGetDesignsCallback(design:Diseno):void
		{
			designs[editableItem] = design;
			loadSWF(design.swf);
		}
		
		
		//
		private function loadSWF(url:String):void
		{
			//now load the swf of the design
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onFileLoaded);
			loader.load(new URLRequest(url));
		}
		
		
		//
		private function onFileLoaded(event:Event):void
		{
			//setup content based on its dimensions
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onFileLoaded);
			SWFs[editableItem] = loader.content;

			//task completed
			complete();
		}
	}
}