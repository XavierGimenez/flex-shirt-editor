package com.bykoko.infrastructure.task
{
	import com.bykoko.domain.AppDomain;
	import com.bykoko.infrastructure.message.TaskMessage;
	
	public class TaskCreateProductSnapshots extends AbstractContextTask
	{
		[MessageDispatcher]
		public var dispatcher:Function;
		
		[Inject]
		public var appDomain:AppDomain;
		
		
		public function TaskCreateProductSnapshots()
		{
			super();
		}

		override protected function doStartContext():void
		{
			//we already have data of the default product to load => do service call
			dispatcher(new TaskMessage(TaskMessage.CREATE_PRODUCT_SNAPSHOTS_REQUEST));
		}
		
		[MessageHandler(selector="createProductSnapshotsResponse")]
		public function handleTaskMessage(taskMessage:TaskMessage):void
		{
			complete();
		}
	}
}