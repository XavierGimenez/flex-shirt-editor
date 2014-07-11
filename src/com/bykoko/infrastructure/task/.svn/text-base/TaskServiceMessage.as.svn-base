package com.bykoko.infrastructure.task
{
	import com.bykoko.infrastructure.message.ProductMessage;
	import com.bykoko.infrastructure.message.ServiceMessage;
	import com.bykoko.vo.xmlmapping.design.Diseno;

	//Generic Task class to wrap a call to a service without any argument
	public class TaskServiceMessage extends AbstractContextTask
	{
		[MessageDispatcher]
		public var dispatcher:Function;
		
		private var messageType:String;
		
		public function TaskServiceMessage(messageType:String)
		{
			super();
			this.messageType = messageType;
		}
		
		override protected function doStartContext():void
		{
			var serviceMessage:ServiceMessage = new ServiceMessage(messageType, onServiceMessage);
			dispatcher(serviceMessage);
		}
		
		public function onServiceMessage():void
		{
			//task completed
			complete();
		}
	}
}