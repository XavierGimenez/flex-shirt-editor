package com.bykoko.presentation.product.designer
{
	import com.bykoko.util.ColorUtil;
	import com.bykoko.util.VOUtil;
	import com.bykoko.vo.FontDesigner;
	import com.bykoko.vo.TeamProductItemData;
	import com.bykoko.vo.xmlmapping.config.Color;
	
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.text.engine.FontLookup;
	import flash.text.engine.FontPosture;
	import flash.text.engine.FontWeight;
	import flash.text.engine.RenderingMode;
	
	import flashx.textLayout.container.ContainerController;
	import flashx.textLayout.edit.SelectionManager;
	import flashx.textLayout.elements.ParagraphElement;
	import flashx.textLayout.elements.SpanElement;
	import flashx.textLayout.events.UpdateCompleteEvent;
	import flashx.textLayout.formats.TextAlign;
	import flashx.textLayout.formats.TextLayoutFormat;
	
	import mx.binding.utils.ChangeWatcher;

	
	public class EditableTextTeam extends EditableTextBase
	{
		private var _teamProductItemData:TeamProductItemData;
		private var changeNameWatcher:ChangeWatcher
		private var changeNumWatcher:ChangeWatcher;

		
		
		/**************************************************************************************
		 * PUBLIC METHODS
		 *************************************************************************************/
		
		
		
		public function EditableTextTeam(id:int, asset:*, teamProductItemData:TeamProductItemData)
		{
			super(id, asset);
			
			this.teamProductItemData = teamProductItemData;
			
			//as the data of the TeamProductData (name and number of the player) is rendered into a
			//textflow, we can not bind this data, as the TextFlow does not support binding. So add
			//watcher to reflect the changes when the user is changing this values from the UI
			changeNameWatcher = ChangeWatcher.watch(this.teamProductItemData, "name", updateText);
			changeNumWatcher = ChangeWatcher.watch(this.teamProductItemData, "num", updateText);
			
			//super() adds listener to call init() when this item is added to the stage. Checks
			//also when the object is removed, so we can stop watching properties
			addEventListener(Event.REMOVED_FROM_STAGE, dispose);
		}
		
		
		
		//
		public function updateText(event:Event = null):void
		{
			//update the name of the player (first paragraph of the text)
			((textFlow.getChildAt(0) as ParagraphElement).getChildAt(0) as SpanElement).text = teamProductItemData.name;
			
			//update the number of the player (second paragraph of the text)
			((textFlow.getChildAt(1) as ParagraphElement).getChildAt(0) as SpanElement).text = teamProductItemData.num;
			
			textFlow.flowComposer.updateAllControllers();
		}
		
		
		
		//
		public function updateColor(color:int):void
		{
			((textFlow.getChildAt(0) as ParagraphElement).getChildAt(0) as SpanElement).setStyle("color", color);
			((textFlow.getChildAt(1) as ParagraphElement).getChildAt(0) as SpanElement).setStyle("color", color);
			textFlow.flowComposer.updateAllControllers();
		}
		
		
		
		//
		public function updateFont(fontName:String):void
		{
			((textFlow.getChildAt(0) as ParagraphElement).getChildAt(0) as SpanElement).fontFamily = fontName;
			((textFlow.getChildAt(1) as ParagraphElement).getChildAt(0) as SpanElement).fontFamily = fontName;
			textFlow.flowComposer.updateAllControllers();
		}



		/**************************************************************************************
		 * GETTERS / SETTERS
		 *************************************************************************************/
		
		
		[Bindable]
		public function get teamProductItemData():TeamProductItemData
		{
			return _teamProductItemData;
		}
		
		public function set teamProductItemData(value:TeamProductItemData):void
		{
			_teamProductItemData = value;
		}
		
		
		
		/**************************************************************************************
		 * PRIVATE METHODS
		 *************************************************************************************/
		
		
		
		
		//when the text is created, a message is dispatched
		//as the textFlow has changed, so the Parsley dispatcher needs to be not null
		override protected function init(event:Event = null):void
		{
			super.init(event);
			
			//get info about the valid area for design, as the text will fit all the available width
			//set the height of the controller to NaN so it increases when a new line is added
			var designArea:Rectangle = VOUtil.getRectangleFromPosition(appDomain.selectedProduct.posiciones[appDomain.currentProductDisplay])
			containerController = new ContainerController(textArea, designArea.width, NaN);
			textFlow.flowComposer.addController(containerController);
			textFlow.addEventListener(UpdateCompleteEvent.UPDATE_COMPLETE, onUpdateTextFlow);
			
			//format text with the default setting
			var textLayoutFormat:TextLayoutFormat = new TextLayoutFormat();
			textLayoutFormat.fontFamily = (appDomain.designFonts.getItemAt(0) as FontDesigner).fontName;
			textLayoutFormat.fontWeight = FontWeight.NORMAL;
			textLayoutFormat.fontStyle = FontPosture.NORMAL;
			textLayoutFormat.textAlign = TextAlign.CENTER;
			textLayoutFormat.fontLookup = FontLookup.EMBEDDED_CFF;
			textLayoutFormat.renderingMode = RenderingMode.CFF;
			textLayoutFormat.color = 0x000000;
			
			textFlow.format = textLayoutFormat;
			
			//for some reason we have to do a selection, otherwise the bounds of the textFlow are not calculated right
			textFlow.interactionManager = new SelectionManager();
			textFlow.interactionManager.selectRange(0,0);
			
			//remove any possible empty paragraph
			if(textFlow.numChildren > 0)
			{
				textFlow.removeChildAt(0);
			}
			
			//add the name of the player
			textLayoutFormat.fontSize = appDomain.config.team.fontSizeName;
			textFlow.addChild( createParagraph(teamProductItemData.name, textLayoutFormat) );
			
			//create a second paragraph for the number of the team player
			textLayoutFormat.fontSize = appDomain.config.team.fontSizeNum;
			textFlow.addChild( createParagraph(teamProductItemData.num, textLayoutFormat) );
			updateAndSetupContent();
		}
		
		
		
		protected function dispose(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, dispose);
			changeNameWatcher.unwatch();
			changeNumWatcher.unwatch();
		}
	}
}