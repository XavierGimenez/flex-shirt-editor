package com.bykoko.infrastructure.task
{
	import com.bykoko.domain.AppDomain;
	import com.bykoko.domain.Constants;
	import com.bykoko.infrastructure.message.ProductMessage;
	import com.bykoko.presentation.product.designer.EditableDesign;
	import com.bykoko.presentation.product.designer.EditableImage;
	import com.bykoko.presentation.product.designer.EditableText;
	import com.bykoko.vo.order.EditableItem;
	import com.bykoko.vo.order.Product;
	import com.bykoko.vo.xmlmapping.design.Diseno;
	import com.bykoko.vo.xmlmapping.product.Posicion;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	import org.spicefactory.lib.task.SequentialTaskGroup;
	import org.spicefactory.lib.task.Task;
	import org.spicefactory.lib.task.TaskGroup;
	import org.spicefactory.lib.task.events.TaskEvent;
	import org.spicefactory.lib.xml.XmlObjectMapper;
	import org.spicefactory.lib.xml.mapper.XmlObjectMappings;
	import org.spicefactory.parsley.core.context.Context;
	
	public class TaskRecreateOrderImages extends AbstractContextTask
	{
		[MessageDispatcher]
		public var dispatcher:Function;
		
		[Inject]
		[Bindable]
		public var appDomain:AppDomain;
		
		[Inject]
		public var context:Context;

		protected var bitmaps:Vector.<Bitmap>;
		protected var editableItems:Vector.<EditableItem>;
		protected var imageXMLList:XMLList;


		
		public function TaskRecreateOrderImages()
		{
			super();
		}



		override protected function doStartContext():void
		{
			var editableItem:EditableItem;
			var mapper:XmlObjectMapper = XmlObjectMappings.
				forUnqualifiedElements().
				withRootElement(EditableItem).
				mappedClasses(EditableItem).build();

			bitmaps = new Vector.<Bitmap>();
			editableItems = new Vector.<EditableItem>();
			imageXMLList = appDomain.orderXML.descendants().(attribute("tip") == "img" && attribute("id") == "-1");
			
			//create a group of tasks to, for each item: 1)ask for its design swf, 2)load the swf
			var taskGroup:SequentialContextTaskGroup = new SequentialContextTaskGroup(context);
			taskGroup.addEventListener(TaskEvent.COMPLETE, onImagesLoaded);
			for each(var imageXML:XML in imageXMLList)
			{
				editableItem = mapper.mapToObject(imageXML) as EditableItem;
				editableItems.push(editableItem);
				
				//loads the swf of the design
				taskGroup.addTask( new TaskLoadBootstrapImage(appDomain.URL_ROOT + Constants.userURLFolder +  (appDomain.order.products[0] as Product).uprusr + "/" + Constants.userURLLibrary + editableItem.imageFileName, bitmaps));
			}
			taskGroup.start();
		}



		protected function onImagesLoaded(event:TaskEvent):void
		{
			var editableImage:EditableImage;
			var editableItemXML:XML;
			var editableItem:EditableItem;
			var productDisplayId:String;
			var posicion:Posicion; 
			
			//start creating EditableDesign instances
			for(var i:uint = 0; i<bitmaps.length; i++)
			{
				editableImage = new EditableImage(Constants.NO_ID, bitmaps[i], editableItems[i].imageFileName);
			
				//set the positionForSVG automatically. This item maybe is never added to the displayList (if 
				//its product display is never shown), so we set it here
				editableImage.positionForSVG = new Point(editableItems[i].x, editableItems[i].y);
				
				//get info of the product display of the editableItem
				productDisplayId = (imageXMLList[i] as XML).parent().@position;
				posicion = appDomain.selectedProduct.posiciones[productDisplayId] as Posicion;
				
				//the coords of the editableItem are relative to the design area. These coords are the left-top
				//corner of the design
				editableImage.autoSetup(bitmaps[i], editableItems[i], new Point(posicion.x1, posicion.y1));
				
				//add it into the appDomain. The appDomain will decide whether these objects are added into the context or
				//not, depending on the profile of the app (whether profile indicates that order's items are updatable or not)
				appDomain.addEditableItemOrderToProductDisplay(editableImage, productDisplayId);
				
				//add the editableItem in the collection of order's items
				appDomain.editableItemsFromExistingOrder.push(editableImage);
			}
			
			complete();
		}
	}
}