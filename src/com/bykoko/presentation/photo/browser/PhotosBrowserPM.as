package com.bykoko.presentation.photo.browser
{
	import com.bykoko.domain.AppDomain;
	import com.bykoko.domain.Constants;
	import com.bykoko.infrastructure.message.ProductMessage;
	import com.bykoko.presentation.common.AlertWindow;
	import com.bykoko.presentation.product.designer.EditableImage;
	import com.bykoko.presentation.product.designer.IEditable;
	import com.bykoko.util.DictionaryUtil;
	import com.bykoko.util.MathUtil;
	import com.bykoko.vo.PhotoItemRendererData;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;
	import mx.managers.PopUpManager;
	import mx.resources.ResourceManager;

	[Event(name="setLoadingState", type="flash.events.Event")]
	[Event(name="setDefaultState", type="flash.events.Event")]
	[ResourceBundle("Bundles")]
	public class PhotosBrowserPM extends EventDispatcher
	{
		private var fileReference:FileReference;
		private var maxMbFileWeight:int = 10;
		private var maxFileSize:int = 4000;
		private var minFileSize:int = 50;
		private var imageLoader:Loader;

		[Inject]
		[Bindable]
		public var appDomain:AppDomain;
		
		[MessageDispatcher]
		public var dispatcher:Function;
		
		
		
		/**************************************************************************************
		 * PUBLIC METHODS
		 *************************************************************************************/
		
		
		
		//
		public function openFileDialog(event:MouseEvent):void
		{
			fileReference = new FileReference();
			fileReference.addEventListener(Event.SELECT, onFileSelected);
			fileReference.addEventListener(Event.COMPLETE, onFileCompleted);
			
			//NOTE: list of filetypes for mac: http://www.tink.ws/blog/macintosh-file-types/  
			fileReference.browse( [new FileFilter(ResourceManager.getInstance().getString('Bundles','PHOTO_PANEL.FILE_FILTER'), "*.jpeg;*.jpg;*.png;", "JPEG;jp2_;PNG")] );
		}
		
		
		
		//
		private function showAlert(message:String):void
		{
			var alertWindow:AlertWindow = new AlertWindow();
			alertWindow.message = message;
			PopUpManager.addPopUp(alertWindow, FlexGlobals.topLevelApplication.root, true);
			PopUpManager.centerPopUp(alertWindow);
		}

		

		/**************************************************************************************
		 * PRIVATE METHODS
		 *************************************************************************************/
		
		
		
		//
		private function uploadFile(bitmap:Bitmap):void
		{
			fileReference.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			fileReference.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			fileReference.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, onUploadCompleteData);
			
			var urlVars:URLVariables = new URLVariables();
			urlVars.id_pedido = appDomain.config.id_pedido;
			var urlRequest:URLRequest = new URLRequest();
			urlRequest = new URLRequest();
			urlRequest.method = URLRequestMethod.POST;
			urlRequest.data = urlVars;
			urlRequest.url = appDomain.URL_FILE_UPLOAD;
			fileReference.upload(urlRequest);
		}

		
		
		/**************************************************************************************
		 * EVENTS
		 *************************************************************************************/
		
		
		
		//
		private function onFileSelected(event:Event):void
		{
			//check if the size of the file to load is right
			if(MathUtil.byte2Megabyte(fileReference.size) > 10)
				showAlert(ResourceManager.getInstance().getString('Bundles','PHOTO_PANEL.WARNING.FILE_WEIGHT_WRONG'));
			else
			{
				//change view state and load the selected file
				dispatchEvent(new Event("setLoadingState"));
				fileReference.load();
			}
		}
		
		
		
		//
		private function onFileCompleted(event:Event):void
		{
			fileReference.removeEventListener(Event.SELECT, onFileSelected);
			fileReference.removeEventListener(Event.COMPLETE, onFileCompleted);
			
			//load the byteArray of the loaded file
			imageLoader = new Loader();
			imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded);
			imageLoader.loadBytes(fileReference.data);
		}
		
		
		
		//
		private function onImageLoaded(event:Event):void
		{
			imageLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onImageLoaded);
			
			//check if the size of the image is right
			if(	MathUtil.isInRange(imageLoader.contentLoaderInfo.content.width, minFileSize, maxFileSize) &&
				MathUtil.isInRange(imageLoader.contentLoaderInfo.content.height, minFileSize, maxFileSize))			
			{
				//upload file. Still mantain the view with the loading state
				uploadFile(imageLoader.contentLoaderInfo.content as Bitmap);
			}
			else
			{
				dispatchEvent(new Event("setDefaultState"));
				showAlert(ResourceManager.getInstance().getString('Bundles','PHOTO_PANEL.WARNING.FILE_SIZE_WRONG'));
			}
		}
		
		
		
		//
		private function ioErrorHandler(event:IOErrorEvent):void
		{
			fileReference = null;
			dispatchEvent(new Event("setDefaultState"));
			showAlert(ResourceManager.getInstance().getString('Bundles','PHOTO_PANEL.WARNING.PHOTO_PANEL.WARNING.IO_ERROR'));
		}
		
		
		
		//
		private function onSecurityError(event:SecurityErrorEvent):void
		{
			fileReference = null;
			dispatchEvent(new Event("setDefaultState"));
			showAlert(ResourceManager.getInstance().getString('Bundles','PHOTO_PANEL.WARNING.SECURITY_ERROR'));
		}
		
		
		
		//
		private function onUploadCompleteData(event:DataEvent):void
		{
			fileReference = null;
			
			if(event.data == Constants.ERROR_UPLOAD_FILE)
			{
				//problem uploading the file
				showAlert(ResourceManager.getInstance().getString('Bundles','PHOTO_PANEL.WARNING.UPLOAD_ERROR'));
			}
			else
			{
				//save the image to the collection of bitmaps
				var photoItemData:PhotoItemRendererData = new PhotoItemRendererData();
				photoItemData.image = new Bitmap((imageLoader.contentLoaderInfo.content as Bitmap).bitmapData.clone());
				photoItemData.imageFileName = event.data;
				appDomain.uploadedBitmaps.addItem(photoItemData);
					
				//file loaded ok, send the image to be added to the design
				var productMessage:ProductMessage = new ProductMessage(ProductMessage.IMAGE_LOADED);
				productMessage.image = imageLoader.contentLoaderInfo.content as Bitmap;
				productMessage.imageFilename = event.data;
				dispatcher(productMessage);
			}

			dispatchEvent(new Event("setDefaultState"));
		}
		
		
		
		/**************************************************************************************
		 * MESSAGES
		 *************************************************************************************/
		
		
		
		//
		[MessageHandler]
		public function handleSelectDesignEvent(event:Event):void
		{
			switch(event.type)
			{
				case Event.SELECT:
					var productMessage:ProductMessage = new ProductMessage();
					productMessage.imageFilename = ((event.target as PhotoItemRenderer).data as PhotoItemRendererData).imageFileName;
					productMessage.type = ProductMessage.IMAGE_LOADED;
					productMessage.image = new Bitmap( ((event.target as PhotoItemRenderer).data as PhotoItemRendererData).image.bitmapData.clone() );
					productMessage.imageRemoveBackground = ((event.target as PhotoItemRenderer).removeBackground.currentState == 'selected')?	1:0;
					dispatcher(productMessage);
					break;
				
				case "mantainBackground":
				case "removeBackground":
					for each(var iEditablesInProductDisplay:ArrayCollection in appDomain.allEditableDesigns)
					{
						for each(var iEditable:IEditable in iEditablesInProductDisplay)
						{
							if(	iEditable is EditableImage && 
								(iEditable as EditableImage).fileName == ((event.target as PhotoItemRenderer).data as PhotoItemRendererData).imageFileName)
							{
								(iEditable as EditableImage).removeBackground = (event.type == "removeBackground")?	1:0;
							}
						}
					}
					break;
			}
		}
	}
}