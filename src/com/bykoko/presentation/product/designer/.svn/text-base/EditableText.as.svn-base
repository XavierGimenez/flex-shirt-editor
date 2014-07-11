package com.bykoko.presentation.product.designer
{
	import com.bykoko.domain.Constants;
	import com.bykoko.infrastructure.message.EditableTextMessage;
	import com.bykoko.util.DictionaryUtil;
	import com.bykoko.vo.order.EditableItem;
	
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import flashx.textLayout.container.ContainerController;
	import flashx.textLayout.edit.EditManager;
	import flashx.textLayout.elements.FlowElement;
	import flashx.textLayout.elements.SpanElement;
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.events.SelectionEvent;
	import flashx.textLayout.events.UpdateCompleteEvent;
	import flashx.textLayout.formats.TextLayoutFormat;
	import flashx.undo.UndoManager;
	
	import mx.resources.ResourceManager;
	
	import spark.utils.TextFlowUtil;


	
	public class EditableText extends EditableTextBase
	{
		protected const defaultWidthcontainerController:int = 100; 
		
		//initial textLayoutFormat applied to the text 
		protected var textLayoutFormat:TextLayoutFormat;
		
		protected var textSizeLeaves:Dictionary = new Dictionary();
		
		
		/**************************************************************************************
		 * PUBLIC METHODS
		 *************************************************************************************/
		
		
		
		public function EditableText(id:int, asset:*, textLayoutFormat:TextLayoutFormat = null)
		{
			super(id, asset);
			this.textLayoutFormat = textLayoutFormat;
		}
		
		
		
		//Here we scale at the same time the width of the containerController and 
		//the size of each leave of text. Texts are scaled not incrementally, but scaled
		//always their original size by the accumulated scale difference. The accumulated
		//difference we can get it from the containerController scale (we know its original
		//width and the current width)
		override public function resizeBy(scaleX:Number, scaleY:Number):void
		{						
			//prevent from seting a text size lower than 6 (just 6 to mantain a minimum 
			//size in the bounding box of) 
			if(!preventScale(scaleX))
			{
				containerController.setCompositionSize(containerController.compositionWidth * scaleX, NaN);
				
				var leaf:SpanElement = textFlow.getFirstLeaf() as SpanElement;
				leaf.fontSize = textSizeLeaves[leaf] * (containerController.compositionWidth / defaultWidthcontainerController);
				while(leaf = SpanElement(leaf.getNextLeaf())) 
				{
					leaf.fontSize = textSizeLeaves[leaf] * (containerController.compositionWidth / defaultWidthcontainerController);
				}

				//center text so rotation does not become a nightmare
				centerText();
				
				//recompose text and container
				textFlow.flowComposer.compose();
				textFlow.flowComposer.updateAllControllers();
			}
		}


		
		public function autoInit(editableItem:EditableItem, topLeftCornerDesignArea:Point):void
		{
			//remove the listener to the event ADDED_TO_STAGE created in the constructor
			super.init();
			
			//create the controller with the indicated size
			containerController = new ContainerController(textArea, editableItem.width, NaN);

			//add the controller to the textFlow
			textFlow.flowComposer.addController(containerController);
			
			//create the textflow based on the editableItem data. We can not reassign the textFLow object,
			//so put all the content from one textFlow to another
			
			//<span> elements that only contain a space character are ignored. So move
			//this space chracters to the previous span, so this character is mantained
			var textFlowFromOrderXML:XML = new XML(editableItem.tlf);
			var spanList:XMLList = textFlowFromOrderXML.children()[0].children();
			for (var i:int = 0; i<spanList.length(); i++)
			{
				var span:XML = spanList[i] as XML;
				var xmlList:XMLList = span.text();
				if(xmlList.length() == 0)
				{
					if(i>0)
					{
						(spanList[i-1] as XML).setChildren((spanList[i-1] as XML).text() + " "); 	
					}
				}
			}
			
			//replacing one textFlow by another does not work. Replace the childrens
			var textFlowFromOrder:TextFlow = TextFlowUtil.importFromXML(textFlowFromOrderXML);
			var elements:Array = [];
			for(var j:int = 0; j < textFlowFromOrder.numChildren; j++)
			{
				elements.push(textFlowFromOrder.getChildAt(j));		
			}
			textFlow.replaceChildren(0, textFlow.numChildren, elements);		
			
			//decide the interactionManager to use
			textFlow.interactionManager = (appDomain && appDomain.profile == Constants.PROFILE_PRODUCT_MODIFIED_BY_OWNER)? new EditManager(new UndoManager()) : null;
				
			//compose the new textFlow 
			textFlow.flowComposer.updateAllControllers();
			
			//positionate the textArea into the editing valid area
			setupContent(textArea, new Rectangle(0, 0, editableItem.width, editableItem.height));
			
			//the coords of the editableItem are relative to the design area. These coords are the left-top
			//corner of the design
			this.x = topLeftCornerDesignArea.x + editableItem.x + (editableItem.width/2);
			this.y = topLeftCornerDesignArea.y + editableItem.y + (editableItem.height/2);
			
			//apply rotation
			if(editableItem.transform && editableItem.transform.length > 0)
			{
				rotateTo(editableItem.getDegreesFromRotationTransform(editableItem.transform));
			}

			waitAndCreateBitmap();
		}
		
		
		
		/**************************************************************************************
		 * PRIVATE METHODS
		 *************************************************************************************/
		
		
		
		
		//when the text is created, a message is dispatched
		//as the textFlow has changed, so the Parsley dispatcher needs to be not null
		override protected function init(event:Event = null):void
		{
			super.init(event);
			
			//set the height of the controller to NaN so it increases when a new line is added
			containerController = new ContainerController(textArea, defaultWidthcontainerController, NaN);

			textFlow.flowComposer.addController(containerController);
			textFlow.addEventListener(SelectionEvent.SELECTION_CHANGE, onEditableTextSelectionChange);
			textFlow.addEventListener(UpdateCompleteEvent.UPDATE_COMPLETE, onUpdateTextFlow);
			
			//set the format of the text with the current values existing in the UI (text settings panel)
			textFlow.format = textLayoutFormat;
			
			// make textFlow editable with undo
			textFlow.interactionManager = new EditManager(new UndoManager());
			
			//initialize with a selection before the first character
			textFlow.interactionManager.selectRange(0,0);
			
			//add the default text if there is no content for this created editableText (texts that
			//are created from an existing product order have already a textFlow set before they 
			//are added to stage)
			if(textFlow.getText() == '')
			{
				//remove the empty paragraph and add a new one
				if(textFlow.numChildren > 0)
				{
					textFlow.removeChildAt(0);
				}
				textFlow.addChild( createParagraph(ResourceManager.getInstance().getString('Bundles','TEXT_EDITABLE.DEFAULT_TEXT'), textLayoutFormat) );
			}
			
			//get the number of lines. Number of lines are checked every time there
			//is a change in the textflow
			numLines = textFlow.flowComposer.numLines;
				
			updateAndSetupContent();
		}
		
		
		
		protected function preventScale(scale:Number):Boolean
		{
			//calculate the new scale of the composition
			var newCompositionWidth:Number = containerController.compositionWidth * scale;
			var leaf:SpanElement = textFlow.getFirstLeaf() as SpanElement;
			if(textSizeLeaves[leaf] == null)
			{
				textSizeLeaves[leaf] = leaf.fontSize;				
			}
			
			while(leaf = SpanElement(leaf.getNextLeaf())) 
			{
				if(textSizeLeaves[leaf] == null)
				{
					textSizeLeaves[leaf] = leaf.fontSize;
				}
			}
			
			for each(var fontSize:int in DictionaryUtil.values(textSizeLeaves))
			{
				if(	fontSize * (newCompositionWidth / defaultWidthcontainerController) < 6)
				{
					//prevent from scale
					return true;
				}	
			}
			return false;
		}

		
		
		/**************************************************************************************
		 * EVENTS
		 *************************************************************************************/
		
		
		
		//
		protected function onEditableTextSelectionChange(event:SelectionEvent):void
		{
			var editableItemMessage:EditableTextMessage = new EditableTextMessage(EditableTextMessage.SELECTION_CHANGE);
			editableItemMessage.selectionState = event.selectionState;
			editableItemMessage.textFlow = textFlow;
			dispatcher(editableItemMessage);
		}
	}
}