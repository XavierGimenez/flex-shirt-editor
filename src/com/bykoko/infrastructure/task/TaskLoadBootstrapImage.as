package com.bykoko.infrastructure.task
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;

	public class TaskLoadBootstrapImage extends AbstractContextTask
	{
		[MessageDispatcher]
		public var dispatcher:Function;
		
		protected var loader:Loader;
		private var imageURL:String;
		private var bitmaps:Vector.<Bitmap>;
		
		public function TaskLoadBootstrapImage(imageURL:String, bitmaps:Vector.<Bitmap>)
		{
			super();
			this.imageURL = imageURL;
			this.bitmaps = bitmaps;
		}
		
		override protected function doStartContext():void
		{
			//load the image file
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onFileLoaded);
			loader.load(new URLRequest(imageURL));
		}
		
		
		
		//
		private function onFileLoaded(event:Event):void
		{
			//setup content based on its dimensions
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onFileLoaded);
			bitmaps.push(loader.content);

			//task completed
			complete();
		}
	}
}