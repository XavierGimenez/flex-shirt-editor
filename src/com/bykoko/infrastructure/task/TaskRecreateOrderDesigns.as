package com.bykoko.infrastructure.task
{
	import com.bykoko.domain.AppDomain;
	import com.bykoko.presentation.product.designer.EditableDesign;
	import com.bykoko.vo.order.EditableItem;
	import com.bykoko.vo.xmlmapping.design.Diseno;
	import com.bykoko.vo.xmlmapping.product.Posicion;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import org.spicefactory.lib.task.events.TaskEvent;
	import org.spicefactory.lib.xml.XmlObjectMapper;
	import org.spicefactory.lib.xml.mapper.XmlObjectMappings;
	import org.spicefactory.parsley.core.context.Context;
	
	public class TaskRecreateOrderDesigns extends AbstractContextTask
	{
		[MessageDispatcher]
		public var dispatcher:Function;
		
		[Inject]
		[Bindable]
		public var appDomain:AppDomain;
		
		[Inject]
		public var context:Context;

		protected var editableItems:XMLList;
		protected var designs:Dictionary
		protected var SWFs:Dictionary;

		
		
		public function TaskRecreateOrderDesigns()
		{
			super();
		}



		override protected function doStartContext():void
		{
			editableItems = new XMLList();
			designs = new Dictionary();
			SWFs = new Dictionary();
			
			//create a group of tasks to, for each item: 1)ask for its design swf, 2)load the swf
			var taskGroup:SequentialContextTaskGroup = new SequentialContextTaskGroup(context);
			taskGroup.addEventListener(TaskEvent.COMPLETE, onDesignsLoaded);
			
			//get from the order all the editableItems that are designs
			editableItems = appDomain.orderXML.descendants().(attribute("tip") == "img" && attribute("id") != "-1");
			for each(var editableItem:XML in editableItems)
			{
				//this tasks does:
				//1. api call to get info of the design (swf location, name, etc...)
				//2. loads the swf of the design
				taskGroup.addTask( new TaskLoadBootstrapDesignById(editableItem, designs, SWFs));
			}
			taskGroup.start();
		}
		
		
		
		protected function onDesignsLoaded(event:TaskEvent):void
		{
			var editableDesign:EditableDesign;
			var editableItem:EditableItem;
			var productDisplayId:String;
			var posicion:Posicion;
			var mapper:XmlObjectMapper = XmlObjectMappings.
				forUnqualifiedElements().
				withRootElement(EditableItem).
				mappedClasses(EditableItem).build();
			
			var design:Diseno;
			var swf:DisplayObject;
			
			//start creating EditableDesign instances
			for each(var editableItemXML:XML in editableItems)
			{
				//get the editable-item node from the order
				editableItem = mapper.mapToObject(editableItemXML) as EditableItem;
				
				editableDesign = new EditableDesign(designs[editableItemXML]);
				
				//set the positionForSVG automatically. This item maybe is never added to the displayList (if 
				//its product display is never shown), so we set it here
				editableDesign.positionForSVG = new Point(editableItem.x, editableItem.y);
				
				//get info of the product display of the editableItem
				productDisplayId = editableItemXML.parent().@position;
				posicion = appDomain.selectedProduct.posiciones[productDisplayId] as Posicion;
				
				//the coords of the editableItem are relative to the design area. These coords are the left-top
				//corner of the design
				editableDesign.autoSetup(SWFs[editableItemXML], editableItem, new Point(posicion.x1, posicion.y1));
				
				//add it into the appDomain. The appDomain will decide whether these objects are added into the context or
				//not, depending on the profile of the app (whether profile indicates that order's items are updatable or not)
				appDomain.addEditableItemOrderToProductDisplay(editableDesign, productDisplayId);
				
				//add the editableItem in the collection of order's items
				appDomain.editableItemsFromExistingOrder.push(editableDesign);
			}
			
			complete();
		}
	}
}