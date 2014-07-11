package com.bykoko.presentation.product.options
{
	import flash.events.Event;
	
	public class MultiSizeChooserEvent extends Event
	{
		public static const CHANGE_SIZE:String = "changeSize";
		public static const SEND_VALIDATION:String = "sendValidation";
		
		public var isValid:Boolean;
		
		public function MultiSizeChooserEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}