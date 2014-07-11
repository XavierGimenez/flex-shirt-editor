package com.bykoko.presentation.text
{
	import com.bykoko.domain.AppDomain;
	import com.bykoko.infrastructure.message.EditableTextMessage;
	import com.bykoko.infrastructure.message.ProductMessage;
	import com.bykoko.presentation.product.designer.EditableText;
	import com.bykoko.presentation.product.designer.EditableTextBase;
	import com.bykoko.vo.xmlmapping.config.Color;
	
	import flash.events.Event;
	import flash.text.Font;
	import flash.text.TextFormat;
	import flash.text.engine.FontPosture;
	import flash.text.engine.FontWeight;
	
	import flashx.textLayout.edit.IEditManager;
	import flashx.textLayout.edit.SelectionState;
	import flashx.textLayout.elements.ParagraphElement;
	import flashx.textLayout.elements.SpanElement;
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.formats.ITextLayoutFormat;
	import flashx.textLayout.formats.TextLayoutFormat;
	
	import mx.events.ColorPickerEvent;
	
	import spark.components.ButtonBar;
	import spark.components.ComboBox;
	import spark.components.NumericStepper;
	import spark.components.RichEditableText;
	import spark.events.IndexChangeEvent;
	import spark.utils.TextFlowUtil;

	public class TextEditorPanelPM
	{
		[Inject]
		[Bindable]
		public var appDomain:AppDomain;
		
		[MessageDispatcher]
		public var dispatcher:Function;
		
		//get the text area of the selected EditableText
		protected var textArea:RichEditableText

		
		
		/**************************************************************************************
		 * PUBLIC METHODS
		 *************************************************************************************/
		
		
		
		//Changes the size of the selected text
		public function setTextSize(event:Event):void
		{
			if(	isTextFlowAvailable())
			{
				var tf:TextLayoutFormat = new TextLayoutFormat();
				tf.fontSize = (event.target as NumericStepper).value;
				applyTextFormat(tf);
			}
		}
		
		
		
		//changes the selected text to bold
		public function setBoldStyle(event:Event):void
		{
			if(	isTextFlowAvailable())
			{
				var tf:TextLayoutFormat = new TextLayoutFormat();
				tf.fontWeight = ((event.target as TextOptionButton).selected == true)?	FontWeight.BOLD:FontWeight.NORMAL;
				applyTextFormat(tf);
			}
		}
		
		
		
		//changes the selected text to italic
		public function setItalicStyle(event:Event):void
		{
			if(	isTextFlowAvailable())
			{
				var tf:TextLayoutFormat = new TextLayoutFormat();
				tf.fontStyle = ((event.target as TextOptionButton).selected == true)?	FontPosture.ITALIC:FontPosture.NORMAL;
				applyTextFormat(tf);
			}
	}
		
		
		
		//changes the color of the selected text
		public function setTextColor(event:ColorPickerEvent):void
		{
			if(	isTextFlowAvailable())
			{
				var tf:TextLayoutFormat = new TextLayoutFormat();
				tf.color = event.color;
				applyTextFormat(tf);
			}
		}
		
		
		
		//changes the alignment of the selected text
		public function setTextAlign(event:IndexChangeEvent):void
		{
			if(	isTextFlowAvailable() && (event.target as ButtonBar).selectedItem)
			{
				var tf:TextLayoutFormat = new TextLayoutFormat();
				tf.textAlign = (event.target as ButtonBar).selectedItem.align;
				applyTextFormat(tf);
			}
		}
		
		
		
		//Changes the font family of the selected text
		public function setTextFont(fontName:String):void
		{	
			if(	isTextFlowAvailable())
			{
				var tf:TextLayoutFormat = new TextLayoutFormat();
				tf.fontFamily = fontName;
				applyTextFormat(tf);
			}
		}

		
		
		public function sendMessageToAddText(textLayoutFormat:TextLayoutFormat):void
		{
			//notify that a text has to be added
			var productMessage:ProductMessage = new ProductMessage(ProductMessage.INSERT_TEXT);
			productMessage.textLayoutFormat = textLayoutFormat;
			dispatcher(productMessage);
		}
		
		
		
		/**************************************************************************************
		 * PRIVATE METHODS
		 *************************************************************************************/
		
		
		
		//
		private function isTextFlowAvailable():Boolean
		{
			return(	appDomain.selectedEditableItemIsText &&
					(appDomain.editableItem as EditableText).textFlow && 
					(appDomain.editableItem as EditableText).textFlow.interactionManager is IEditManager);
		}
		
		
		
		//
		private function applyTextFormat(tf:TextLayoutFormat):void
		{
			//apply the new textFormat in the selection, if no selection then apply the TextFormat in all the text
			//only the defined properties in the textFormat are applied.
			var textFlow:TextFlow = (appDomain.editableItem as EditableText).textFlow;
			
			//text align is aplied not in the selection, but in the structure textFlow->paragraph->span
			//The rest of properties of the textFormat are applied over a selection
			if(tf.textAlign)
			{
				textFlow.textAlign = tf.textAlign;
				for (var i:int = 0; i < textFlow.flowComposer.numLines; i++)
				{
					var paragraph:ParagraphElement = textFlow.flowComposer.getLineAt(i).paragraph;					
					paragraph.textAlign = tf.textAlign;
					(paragraph.getFirstLeaf() as SpanElement).textAlign = tf.textAlign;
				}
				textFlow.flowComposer.updateAllControllers();
			}
			else
			{
				var selectionState:SelectionState = (textFlow.interactionManager.isRangeSelection() == false)?	new SelectionState(textFlow, 0, textFlow.textLength, tf) : null;
				IEditManager(textFlow.interactionManager).applyLeafFormat(tf, selectionState);
			}
			
			textFlow.interactionManager.setFocus();
			
			//if there was a selection range, mantain it after the change
			if(selectionState)
				textFlow.interactionManager.setSelectionState(selectionState);
			
			//for some properties, check if the text is out of the design area
			if(tf.fontSize != null || tf.fontWeight != null || tf.fontStyle != null || tf.textAlign != null || tf.fontFamily != null)
			{
				//send a message to update the bounding box
				dispatcher(new EditableTextMessage(EditableTextMessage.TEXT_FORMAT_CHANGE));
			}
		}
	}
}