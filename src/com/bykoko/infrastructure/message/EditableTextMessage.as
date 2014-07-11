package com.bykoko.infrastructure.message
{
	import flashx.textLayout.edit.SelectionState;
	import flashx.textLayout.elements.TextFlow;
	
	public class EditableTextMessage
	{
		public static const SELECTION_CHANGE:String = "selectionChange";
		public static const TEXT_CHANGE:String = "textChange";
		public static const TEXT_FORMAT_CHANGE:String = "textFormatChange";
		public static const NUM_LINES_CHANGE:String = "numLinesChange";
		
		
		public var selectionState:SelectionState;
		public var textFlow:TextFlow;
		
		[Selector]
		public var _type:String;
		
		
		
		public function EditableTextMessage(type:String)
		{
			_type = type;
		}

		public function get type():String
		{
			return _type;
		}

		public function set type(value:String):void
		{
			_type = value;
		}

	}
}