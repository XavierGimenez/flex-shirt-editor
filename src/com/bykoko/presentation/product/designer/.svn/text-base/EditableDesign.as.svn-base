package com.bykoko.presentation.product.designer
{
	import com.bykoko.util.ColorUtil;
	import com.bykoko.vo.order.EditableItem;
	import com.bykoko.vo.xmlmapping.design.Diseno;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	
	import mx.controls.SWFLoader;
	
	public class EditableDesign extends EditablePictureBase
	{
		public var design:Diseno;
		public var _color:int; 
		
		
		
		/**************************************************************************************
		 * PUBLIC METHODS
		 *************************************************************************************/
		
		
		//
		public function EditableDesign(design:Diseno, color:int = -1)
		{
			super(design.id, design.file);
			this.design = design;
			_color = color;
			
			//load the design file
			addEventListener(Event.ADDED_TO_STAGE, loadFile);
		}
		
		
		
		//
		[Bindable]
		public function set color(value:int):void
		{
			_color = value;
			tintContent();
		}
		
		public function get color():int
		{
			return _color;
		}
		
		
		
		public function resetColor():void
		{
			_color = -1;
			content.transform.colorTransform =  new ColorTransform();
		}
		
		
		
		override public function autoSetup(swf:DisplayObject, editableItem:EditableItem, topLeftCornerDesignArea:Point):void
		{
			//prevent from loading the swf automatically
			removeEventListener(Event.ADDED_TO_STAGE, loadFile);
			
			super.autoSetup(swf, editableItem, topLeftCornerDesignArea);
			
			//apply color if needed
			if(editableItem.color)
			{
				color = ColorUtil.htmlStringToHexNumber(editableItem.color); 
			}
		}
		
		
		
		/**************************************************************************************
		 * PRIVATE METHODS
		 *************************************************************************************/
		
		
		
		//
		private function loadFile(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, loadFile);
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onFileLoaded);
			loader.load(new URLRequest(design.swf));
		}
		
		
		
		//
		private function tintContent():void
		{
			var colorTransform:ColorTransform = new ColorTransform();
			colorTransform.color = _color;
			content.transform.colorTransform = colorTransform;
		}

		
		
		/**************************************************************************************
		 * EVENTS
		 *************************************************************************************/
		
		
		
		//
		private function onFileLoaded(event:Event):void
		{
			//setup content based on its dimensions
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onFileLoaded);
			setupContent(loader.content, new Rectangle(0, 0, loader.content.width, loader.content.height));
			
			//apply the tint color to the content
			//tintContent();
		}
	}
}