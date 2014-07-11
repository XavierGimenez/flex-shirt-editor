package com.bykoko.infrastructure.task
{
	import com.bykoko.domain.AppDomain;
	import com.bykoko.domain.Constants;
	import com.bykoko.infrastructure.message.ProductMessage;
	import com.bykoko.presentation.product.designer.EditableText;
	import com.bykoko.vo.order.EditableItem;
	import com.bykoko.vo.xmlmapping.product.Posicion;
	
	import flash.geom.Point;
	
	import org.spicefactory.lib.xml.XmlObjectMapper;
	import org.spicefactory.lib.xml.mapper.XmlObjectMappings;
	
	import spark.core.SpriteVisualElement;
	
	public class TaskRecreateOrderTexts extends AbstractContextTask
	{
		[Inject]
		[Bindable]
		public var appDomain:AppDomain;

		
		
		public function TaskRecreateOrderTexts()
		{
			super();
		}

		override protected function doStartContext():void
		{
			var productDisplayId:String;
			var posicion:Posicion 
			var editableItem:EditableItem;
			var editableText:EditableText;
			var mapper:XmlObjectMapper = XmlObjectMappings.
				forUnqualifiedElements().
				withRootElement(EditableItem).
				mappedClasses(EditableItem).build();

			//search for texts to recreate
			for each(var editableTextXML:XML in appDomain.orderXML.descendants().(attribute("tip") == "txt"))			
			{
				editableItem = mapper.mapToObject(editableTextXML) as EditableItem;
				editableText = new EditableText(Constants.NO_ID, new SpriteVisualElement());
				
				//set the positionForSVG automatically. This item maybe is never added to the displayList (if 
				//its product display is never shown), so we set it here
				editableText.positionForSVG = new Point(editableItem.x, editableItem.y);
				
				//get info of the product display of the editableItem
				productDisplayId = editableTextXML.parent().@position;
				posicion = appDomain.selectedProduct.posiciones[productDisplayId] as Posicion;
				
				//add it into the appDomain. The appDomain will decide whether these objects are added into the context or
				//not, depending on the profile of the app (whether profile indicates that order's items are updatable or not)
				appDomain.addEditableItemOrderToProductDisplay(editableText, productDisplayId);

				//add the editableItem in the collection of order's items
				appDomain.editableItemsFromExistingOrder.push(editableText);
				
				//the coords of the editableItem are relative to the design area. These coords are the left-top corner of the design
				//1. autoInit can need the context , so first we add it into the appDomain
				//2. if autoInit needs context, these editableText will send a message COMPLETE, handled by the view ProductDesigner
				//   which uses appDomain.editableItemsFromExistingOrder
				
				//because of 1) and 2), execute autoinit here, not before the lines of code above
				editableText.autoInit(editableItem, new Point(posicion.x1, posicion.y1));
			}
			
			//task completed
			complete();
		}
	}
}