package com.bykoko.presentation.product.designer
{
	import com.bykoko.domain.AppDomain;
	import com.bykoko.domain.Constants;
	import com.bykoko.infrastructure.message.EditableTextMessage;
	import com.bykoko.util.ColorUtil;
	import com.bykoko.util.MathUtil;
	import com.bykoko.util.RectangleUtil;
	import com.bykoko.vo.xmlmapping.svg.Text;
	import com.bykoko.vo.xmlmapping.svg.Tspan;
	import com.bykoko.vo.xmlmapping.svg.TspanPositioned;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.engine.TextLine;
	import flash.utils.Timer;
	
	import flashx.textLayout.compose.TextFlowLine;
	import flashx.textLayout.container.ContainerController;
	import flashx.textLayout.edit.SelectionState;
	import flashx.textLayout.elements.ParagraphElement;
	import flashx.textLayout.elements.SpanElement;
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.events.UpdateCompleteEvent;
	import flashx.textLayout.formats.TextLayoutFormat;
	
	import org.spicefactory.lib.xml.XmlObjectMapper;
	import org.spicefactory.lib.xml.mapper.XmlObjectMappings;
	
	import spark.core.SpriteVisualElement;
	import spark.primitives.Rect;
	import spark.utils.TextFlowUtil;

	[ResourceBundle("Bundles")]
	public class EditableTextBase extends EditableBase
	{
		public var textArea:SpriteVisualElement;
		public var containerController:ContainerController;
		protected var numLines:int;
		public var textFlow:TextFlow;
		public var bitmap:Bitmap
		protected var timer:Timer;
		
		protected const ALPHA_ON:Number = 0.1;
		protected const ALPHA_OFF:Number = 0.01;
		
		[Inject]
		[Bindable]
		public var appDomain:AppDomain;
		
		
		/**************************************************************************************
		 * PUBLIC METHODS
		 *************************************************************************************/
		
		
		
		public function EditableTextBase(id:int, asset:*)
		{
			super(id, asset);
			
			//save the asset that this instance will manage
			textArea = asset as SpriteVisualElement;
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		
		
		//exports the text in the Text Layout Format
		public function exportTextLayoutFormat():String
		{
			return Constants.CDATA_INIT + TextFlowUtil.export(textFlow).toXMLString() + Constants.CDATA_END;
		}
		
		
		
		//For texts, when we get the bounds, if we get the bounds of the ContainerController, which is not the
		//real bounds of the text. We make use of the bitmap to get the real text bounds
		override public function get size():Rectangle
		{
			var angle:Number = content.rotation;
			content.rotation = 0;
			var size:Rectangle = bitmap.getBounds(parent);
			content.rotation = angle;
			return size;
		}
		
		
		
		//exports the text as an svg text
		public function exportSVG():String
		{
			var textSVG:Text = new Text();
			var pElement:ParagraphElement;
			var spanElement:SpanElement;
			var tspan:Tspan;
			
			//there is no automating word wrapping in SVG, so paragraphs in the TextFlow
			//with more than one line need to be splitted.
			splitMultilineParagraphs();
			
			//add rotation transform if exists
			if(isRotated)
			{
				textSVG.transform = rotationTransform;
			}
	
			//navigate throught all the <p> elements of the textFlow
			for(var i:int = 0; i<textFlow.numChildren; i++)
			{
				//navigate throught all the <span> element of each <p> element
				pElement = textFlow.getChildAt(i) as ParagraphElement;

				for(var j:int = 0; j<pElement.numChildren; j++)
				{
					//first span of the paragraph is the 'wrapper' of all the text for
					//the inspected paragraph.It will have the absolute position
					//regarding the left-top corner of the design valid area. If the
					//paragraph contains more spans, these are originated due
					//to changes in the formatting text and they have no position
					//indicated, so they are placed relatively, just after its
					//previous span (http://tutorials.jenkov.com/svg/tspan-element.html)
					spanElement = pElement.getChildAt(j) as SpanElement;
					if(spanElement.text != "")
					{
						if(j == 0)
						{
							//because we have splitted possible multiline paragraphs,
							//each paragraph is one line. The object TextFlowLine gives
							//its position relative to its container
							var textFlowLine:TextFlowLine = textFlow.flowComposer.getLineAt(i);
							tspan = new TspanPositioned();
							(tspan as TspanPositioned).x = textFlowLine.x;
							
							//svg considers y=0 the bottom side of the "bounding box" of the text,
							//(we should not see a svg text placed at 0,0, it would be above the y=0)
							//so add the height of the line
							(tspan as TspanPositioned).y = textFlowLine.y + textFlowLine.textHeight;
							
							//finally, add the position of the bitmap version of the text (relative to the design area)
							(tspan as TspanPositioned).x += positionForSVG.x;
							(tspan as TspanPositioned).y += positionForSVG.y;
							
							//send also info about the position of each line relative to the container (used later for
							//image processing in the server)
							var linePos:Rectangle = textFlowLine.getBounds();
							(tspan as TspanPositioned).xRelative = MathUtil.clamp(linePos.x, 0, linePos.x + 1);
							(tspan as TspanPositioned).yRelative = MathUtil.clamp(linePos.y, 0, linePos.y + 1);
						}
						else
						{
							tspan = new Tspan();
						}

						//get the formatting values: don't add the textAnchor property as each <tspan>
						//contains the absolute position relative to the left-top corner of the valid area
						//tspan.textAnchor = 	(spanElement.textAlign == TextAlign.RIGHT)? Constants.SVG_ANCHOR_END:
						//					(spanElement.textAlign == TextAlign.CENTER)? Constants.SVG_ANCHOR_MIDDLE:Constants.SVG_ANCHOR_START;
						tspan.fontFamily = spanElement.fontFamily;
						tspan.fontSize = spanElement.fontSize;
						tspan.fontWeight = (spanElement.fontWeight == undefined)?	Constants.SVG_PROPERTY_NORMAL:spanElement.fontWeight;
						tspan.fontStyle = (spanElement.fontStyle == undefined)?	Constants.SVG_PROPERTY_NORMAL:spanElement.fontStyle;
						tspan.fill = ColorUtil.toHtmlString(spanElement.color);
						
						//always wrap the text around CDATA
						tspan.text = Constants.CDATA_INIT + spanElement.text + Constants.CDATA_END;
						textSVG.tspans.push(tspan);
					}
				}
			}
			
			var mapper:XmlObjectMapper = XmlObjectMappings.
				forUnqualifiedElements().
				withRootElement(Text).
				mappedClasses(Tspan, TspanPositioned).
				build();
			
			var svg:XML = mapper.mapToXml(textSVG);
			return svg.toXMLString();
		}
		
		
		
		//
		public function selectAll():void
		{
			textFlow.interactionManager.setFocus();
			textFlow.interactionManager.selectAll();
			textFlow.flowComposer.updateAllControllers();
		}

		
		
		//
		public function clearSelection():void
		{
			//remove the selection
			textFlow.interactionManager.selectRange(-1,0);
			textFlow.flowComposer.updateAllControllers();
		}
		
		
		
		//Applies a selectionState to the textFlow. If null, clears any existing selection
		public function setSelection(selectionState:SelectionState):void
		{
			if(selectionState)
			{
				textFlow.interactionManager.setFocus();
				textFlow.interactionManager.setSelectionState(selectionState);
				textFlow.flowComposer.updateAllControllers();
			}
			else
				clearSelection();
		}
		
		
		
		//
		public function showSnapShot(state:Boolean):void
		{
			if(bitmap)
			{
				bitmap.alpha = (state == true)?	ALPHA_ON:ALPHA_OFF;
			}
		}
		
		
		
		//
		public function getTextBounds():Rectangle
		{
			var assetBounds:Rectangle = content.getBounds(content);
			if(RectangleUtil.hasDimensions(assetBounds))
			{
				var textFlowLine:TextFlowLine = textFlow.flowComposer.getLineAt(textFlow.flowComposer.numLines-1);
				if(textFlowLine.getTextLine().y > 0)
					assetBounds.height = textFlowLine.getTextLine().y;
				return assetBounds;
			}
			else
			{
				return null;
			}
		}
		
		
		/**************************************************************************************
		 * PRIVATE METHODS
		 *************************************************************************************/
		
		
		
		//when the text is created, a message is dispatched
		//as the textFlow has changed, so the Parsley dispatcher needs to be not null
		protected function init(event:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			//create the textflow if there is no value for it
			if(textFlow == null)
				textFlow = new TextFlow();
		}
		
		
		
		//
		protected function updateAndSetupContent():void
		{
			//compose the new textFlow 
			textFlow.flowComposer.updateAllControllers();
			
			//positionate the textArea into the editing valid area
			setupContent(textArea, textArea.getBounds(this));
			
			//important: look at this function for an explanation of why a bitmap needs to be created
			waitAndCreateBitmap();
		}
		
		
		
		protected function createParagraph(text:String, textLayoutFormat:TextLayoutFormat):ParagraphElement
		{
			var span:SpanElement = new SpanElement();
			span.text = text;
			span.format = textLayoutFormat;
			
			var paragraph:ParagraphElement = new ParagraphElement();
			paragraph.addChild(span);
			paragraph.format = textLayoutFormat;
			return paragraph;
		}
		
		
		
		protected function splitMultilineParagraphs():void
		{
			var textFlowLine:TextFlowLine;
			var paragraph:ParagraphElement;
			var offset:int = 0;
			
			for (var i:int = 0; i < textFlow.flowComposer.numLines; i++)
			{
				textFlowLine = textFlow.flowComposer.getLineAt(i);
				if(textFlowLine.paragraph != paragraph)
				{
					if(paragraph)
					{
						//as we loop through paragraphs, we need to acumulate
						//their lengths, in order to split possible paragraphs
						//in the right position
						offset += paragraph.textLength;
					}
					paragraph = textFlowLine.paragraph;
				}
				else
				{
					//multiline paragraph. Split the paragraph at the relative position of 
					//the textFlowLine (textFlowLine.absolute - accumulated offset)
					var newParagraph:ParagraphElement = paragraph.splitAtPosition(textFlowLine.absoluteStart - offset) as ParagraphElement;
					textFlow.flowComposer.compose();
					
					//accumulate the length of the first resulting paragraph
					offset += paragraph.textLength;
					
					//update the paragraph being inspected (the second one after the splitting)
					paragraph = newParagraph;
				}
			}
		}

		
		//in order to be able to execute hitTest function with the bitmapdata of this EditableTextBase instance,
		//we need to mantain a bitmap version of the textFlow. Trying to get the bitmap of this class (IEditable)
		//gives wrong results (detailed explanation on ProductDesignerPM::editableItemHitTest)
		protected function waitAndCreateBitmap():void
		{
			timer = new Timer(200, 1);
			timer.addEventListener(TimerEvent.TIMER, function(event:TimerEvent):void
			{
				timer.removeEventListener(event.type, arguments.callee);
				timer = null;
				createBitmapOfTextFlow();	
			});
			timer.start();
		}
		
		
		
		protected function createBitmapOfTextFlow():void 
		{
			if(bitmap)
			{
				bitmap.bitmapData.dispose();
				bitmap.parent.removeChild(bitmap);
				bitmap = null;
			}
		
			//trying to get the bitmap of the IEditable when is an EditableText instance, returns an empty bitmap
			//to get the bitmap with the text, this way is the right one
			var contentBounds:Rectangle = content.getBounds(content);
			var bitmapDataWidth:Number = contentBounds.width;
			var bitmapDataHeight:Number = contentBounds.height;
			if(bitmapDataHeight == 0 || bitmapDataWidth == 0)
			{
				return;
			}
			var bitmapData:BitmapData = new BitmapData(bitmapDataWidth, bitmapDataHeight, true, 0xff0000);
			bitmapData.draw(textArea);
			
			bitmap = new Bitmap(bitmapData);
			content.addChildAt(bitmap, 0);
			bitmap.alpha = ALPHA_OFF;
			bitmap.x = contentBounds.x;
			bitmap.y = contentBounds.y;
		}
		
		
		
		protected function centerText():void
		{
			var textBounds:Rectangle = getTextBounds();
			if(textBounds)
			{
				textArea.x = -textBounds.width/2;
				textArea.y = -textBounds.height/2;
			}
		}
		
		
		
		/**************************************************************************************
		 * EVENTS
		 *************************************************************************************/
		

		
		//
		protected function onUpdateTextFlow(e:UpdateCompleteEvent):void
		{	
			var messageTextChange:EditableTextMessage = new EditableTextMessage(EditableTextMessage.TEXT_CHANGE);
			messageTextChange.textFlow = textFlow;
			dispatcher(messageTextChange);
			createBitmapOfTextFlow();
			
			if(numLines != textFlow.flowComposer.numLines)
			{
				//when the nº of lines change (so the height of the text changes), keep the 
				//text always centered so rotation can be applied without too much headaches
				if(this is EditableText)
				{
					//update controller so when the BoundingBox asks for dimensiones
					//the controller is updated
					textFlow.flowComposer.compose();
					textFlow.flowComposer.updateAllControllers();
					
					//after lines are added to/ removed from the container, to get the
					//correct height of the text, get the 'y' value of the last TextLine
					//object of the text Flow (the TextLine has the 'y' property in the 
					//base line of its text) => the best way I've found to get the right height
					centerText();
					createBitmapOfTextFlow();
				}
				//update numLines and send message to update the bounding box
				numLines = textFlow.flowComposer.numLines;
				
				var messageLinesChange:EditableTextMessage = new EditableTextMessage(EditableTextMessage.NUM_LINES_CHANGE);
				messageLinesChange.textFlow = textFlow;
				dispatcher(messageLinesChange);
			}
		}
	}
}