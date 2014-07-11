package com.bykoko.infrastructure.message
{
	public class MessageBase
	{
		[Selector]
		public var type:String;
		
		//flag to set this missatge as interceptable
		public var interceptable:Boolean = true;
		
		//callback function / parameters
		public var callbackFunction:Function;
		public var callbackParameters:Array;
		
		public function MessageBase(type:String, callbackFunction:Function = null, callbackParameters:Array = null, interceptable:Boolean = true)
		{
			this.type = type;
			this.callbackFunction = callbackFunction;
			this.callbackParameters = callbackParameters;
			this.interceptable = interceptable;
		}
	}
}