package com.bykoko.presentation.product.designer
{
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.geom.Rectangle;

	public class EditableImage extends EditablePictureBase
	{
		public var bitmap:Bitmap;
		public var fileName:String;
		public var removeBackground:Number = 0;
		
		
		
		/**************************************************************************************
		 * PUBLIC METHODS
		 *************************************************************************************/
		
		
		
		//
		public function EditableImage(id:int, asset:*, fileName:String)
		{
			super(id, asset);
			this.bitmap = asset as Bitmap;
			this.fileName = fileName;
			addEventListener(Event.ADDED_TO_STAGE, setupBitmap);
		}
		
		
		
		/**************************************************************************************
		 * PRIVATE METHODS
		 *************************************************************************************/
		
		
		
		//
		private function setupBitmap(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, setupBitmap);
			setupContent(bitmap, new Rectangle(0, 0, bitmap.width, bitmap.height));
		}
	}
}