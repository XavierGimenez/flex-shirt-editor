package com.bykoko.infrastructure.task
{
	import org.spicefactory.lib.task.SequentialTaskGroup;
	import org.spicefactory.lib.task.Task;
	import org.spicefactory.parsley.core.context.Context;
	
	public class SequentialContextTaskGroup extends SequentialTaskGroup implements IContextProvider
	{
		private var _context:Context;
		
		public function SequentialContextTaskGroup(context:Context, name:String = "")
		{
			_context = context;
			super(name);
			
		}

		public function get context():Context
		{
			
			return _context;
		}
	}
}