package com.bykoko.infrastructure.command
{
	import com.bykoko.infrastructure.message.ServiceMessage;
	import com.bykoko.infrastructure.service.IApiHttpService;
	
	import flash.profiler.showRedrawRegions;
	
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	import mx.managers.CursorManager;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	
	import org.spicefactory.lib.xml.XmlObjectMapper;

	public class BaseCommand
	{
		private var _asyncToken:AsyncToken;
		
		//function and its parameters to be executed after the command receives the result
		private var _callbackFunction:Function;
		private var _callbackParameters:Array;

		//object that will map the xml result into vo's
		public var mapper:XmlObjectMapper;
		
		[Inject]
		public var service:IApiHttpService;
		
		
		
		/******************************************************************************
		 * PUBLIC METHODS
		 *****************************************************************************/
		
		
		
		public function BaseCommand()
		{
		}

		

		//
		public function execute(message:ServiceMessage):AsyncToken
		{
			enableApplication(false);
			CursorManager.setBusyCursor();
			callbackFunction = message.callbackFunction;
			callbackParameters = message.callbackParameters;
			return asyncToken;
		}



		//
		public function result(data:Object):void
		{
			enableApplication();
			CursorManager.removeBusyCursor();
			
			if(callbackFunction != null)
				callbackFunction.apply(null, callbackParameters);
		}

		
		
		//
		public function fault(info:Object = null):void
		{
			enableApplication();
			CursorManager.removeBusyCursor();
			var event:FaultEvent = info as FaultEvent;
			if(info)
				Alert.show(event.fault.message,event.fault.faultDetail);
			else
				Alert.show("(i18n) Problems in the result of the service")
		}
		
		
		
		/******************************************************************************
		 * GETTER / SETTER
		 *****************************************************************************/
		
		
		
		public function get asyncToken():AsyncToken
		{
			return _asyncToken;
		}
		
		public function set asyncToken(value:AsyncToken):void
		{
			_asyncToken = value;
		}

		public function get callbackFunction():Function
		{
			return _callbackFunction;
		}

		public function set callbackFunction(value:Function):void
		{
			_callbackFunction = value;
		}

		public function get callbackParameters():Array
		{
			return _callbackParameters;
		}

		public function set callbackParameters(value:Array):void
		{
			_callbackParameters = value;
		}


		
		/******************************************************************************
		 * PROTECTED METHODS
		 *****************************************************************************/
		
		
		
		protected function enableApplication(state:Boolean = true):void
		{
			FlexGlobals.topLevelApplication.mouseEnabled = 
			FlexGlobals.topLevelApplication.enabled = state;
		}
	}
}