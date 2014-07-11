package com.bykoko.infrastructure.task
{
	import org.spicefactory.lib.task.Task;
	import org.spicefactory.parsley.core.context.DynamicObject;
	
	public class AbstractContextTask extends Task
	{
		private var _dynamicObject:DynamicObject;
		
		protected override function doStart():void
		{
			_dynamicObject = IContextProvider(parent).context.addDynamicObject(this);
			doStartContext();
			super.doStart();
		}
		
		protected function doStartContext():void
		{
			/* base implementation does nothing */
		}
		
		protected override function doCancel():void
		{
			cleanContext();
			super.doCancel();
		}
		
		protected override function doSkip():void
		{
			cleanContext();
			super.doSkip();
		}
		
		protected override function complete():Boolean
		{
			cleanContext();
			return super.complete();
		}
		
		private function cleanContext():void
		{
			_dynamicObject.remove();
		}
	}
}