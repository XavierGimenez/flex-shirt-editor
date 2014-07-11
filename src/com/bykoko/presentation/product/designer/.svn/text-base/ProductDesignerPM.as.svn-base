package com.bykoko.presentation.product.designer
{
	import com.bykoko.domain.AppDomain;
	import com.bykoko.domain.Constants;
	import com.bykoko.domain.ViewDomain;
	import com.bykoko.infrastructure.message.EditableTextMessage;
	import com.bykoko.infrastructure.message.ProductMessage;
	import com.bykoko.infrastructure.message.ServiceMessage;
	import com.bykoko.presentation.product.designer.event.ProductDesignerEvent;
	import com.bykoko.presentation.product.designer.ui.BoundingBox;
	import com.bykoko.vo.TeamProductItemData;
	import com.bykoko.vo.xmlmapping.design.Diseno;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import flashx.textLayout.edit.SelectionState;
	import flashx.textLayout.formats.TextLayoutFormat;
	
	import mx.collections.ArrayCollection;
	
	import org.spicefactory.parsley.core.context.DynamicObject;
	import org.spicefactory.parsley.core.state.GlobalState;
	
	import spark.components.Group;
	import spark.core.SpriteVisualElement;

	[Event(name="addEditables", type="com.bykoko.presentation.product.designer.event.ProductDesignerEvent")]
	[Event(name="removeEditables", type="com.bykoko.presentation.product.designer.event.ProductDesignerEvent")]
	[Event(name="productSelected", type="com.bykoko.presentation.product.designer.event.ProductDesignerEvent")]
	[Event(name="changeProductDisplay", type="com.bykoko.presentation.product.designer.event.ProductDesignerEvent")]
	public class ProductDesignerPM extends EventDispatcher
	{
		[Inject]
		[Bindable]
		public var appDomain:AppDomain;
		
		[Inject]
		[Bindable]
		public var viewDomain:ViewDomain;
		
		//bounding box of the design, with controls to transform the image
		public var boundingBox:BoundingBox;
		
		//dynamic object created after the bounding box is added to Parsley context
		private var dynamicObjectBoundingBox:DynamicObject;

		[MessageDispatcher]
		public var dispatcher:Function;

		//view of this presentation model
		public var view:ProductDesigner;
		
		//flag to indicate a new product has been selected and editableItems need to be checked
		public var dirtyEditableItems:Boolean = false;
		
		
		
		/**************************************************************************************
		 * PUBLIC METHODS
		 *************************************************************************************/
		

		
		//
		public function selectEditableItem(editableItem:IEditable, mouseInteraction:Boolean):void
		{
			appDomain.editableItem = editableItem;
			
			//link a bounding box to the editable design and make the design draggable if its not
			//a text. Texts are not draggable because:
			//1. For normal texts, when the user clicks on the item, the user needs to write on it,
			//	 start a selection, etc... and not dragging it.
			//2. For teams texts, these are not editable by clicking on it
			createBoundingBox(editableItem, view.designsHolder, !(appDomain.editableItem is EditableTextBase) && mouseInteraction);
		}
		
		
		
		//
		public function deselectEditableItem():void
		{
			appDomain.editableItem = null;
			removeBoundingBox();
		}

		
		
		//Removes a design item from the collection of designs for the current product display.
		//Also removes, if exists, the dynamic object from the context that was created with
		//the creation of the IEditable object
		public function removeIEditable():IEditable
		{
			if(appDomain.dynamicObjects[boundingBox.editableDesign] != null)
				(appDomain.dynamicObjects[boundingBox.editableDesign] as DynamicObject).remove();
			
			appDomain.removeEditableDesign(boundingBox.editableDesign);
			return boundingBox.editableDesign; 
		}

		
		
		//Adds a design item to the collection of designs for the current product display
		public function addDesign(design:Diseno, designColor:int):void
		{
			//create the new editableDesign
			appDomain.editableItem = new EditableDesign(design, designColor);
			appDomain.addEditableDesign(appDomain.editableItem);
			
			//notify to the view the item to add
			dispatchEvent( new ProductDesignerEvent(ProductDesignerEvent.ADD_EDITABLES, new ArrayCollection([appDomain.editableItem])));
		}
		
		
		
		//Adds a bitmap to the collection of designs for the current product display
		public function addImage(image:Bitmap, imageFileName:String, imageRemoveBackground:int):void
		{
			//create a new editableImage
			appDomain.editableItem = new EditableImage(Constants.NO_ID, image, imageFileName);
			(appDomain.editableItem as EditableImage).removeBackground = imageRemoveBackground;
			appDomain.addEditableDesign(appDomain.editableItem);
			
			//notify to the view the item to add
			dispatchEvent( new ProductDesignerEvent(ProductDesignerEvent.ADD_EDITABLES, new ArrayCollection([appDomain.editableItem])));
		}
		
		
		
		//Adds an editable text for the current product display
		public function addText(textLayoutFormat:TextLayoutFormat):void
		{
			appDomain.editableItem = new EditableText(Constants.NO_ID, new SpriteVisualElement(), textLayoutFormat);
			appDomain.addEditableDesign(appDomain.editableItem);
			
			//notify to the view the item to add
			dispatchEvent( new ProductDesignerEvent(ProductDesignerEvent.ADD_EDITABLES, new ArrayCollection([appDomain.editableItem])));
		}

		
		
		//Adds a team text for the current product display
		public function addTextTeam(teamProductItemData:TeamProductItemData):void
		{
			appDomain.editableItem = new EditableTextTeam(Constants.NO_ID, new SpriteVisualElement(), teamProductItemData); 			
			appDomain.addEditableDesign(appDomain.editableItem);
			
			//notify to the view the item to add
			dispatchEvent( new ProductDesignerEvent(ProductDesignerEvent.ADD_EDITABLES, new ArrayCollection([appDomain.editableItem])));
		}
		
		
		
		//
		public function selectTextTeam(editableTextTeam:EditableTextTeam):void
		{
			for(var i:int = 0; i<appDomain.editableDesigns.length; i++)
			{
				//hide each editableTextTeam found. If the user is editing an existing one, it will be shown later
				(appDomain.editableDesigns.getItemAt(i) as EditableTextTeam).visible = (editableTextTeam == appDomain.editableDesigns.getItemAt(i) as EditableTextTeam);
			}

			selectEditableItem(editableTextTeam, false);
			
			//check here again if the design is outside the limits. This check is already done when
			//the text changes and an event is launched, but here after selecting the editableItem
			//the bounding box is created again, so it looses the state.
			checkEditableItemPartiallyOutside();
		}
		
		
		
		
		//
		public function removeAllDesigns():void
		{
			//reset all the editable designs
			appDomain.resetEditableDesigns();
			
			//if needed, change the product display to show the default one
			if(appDomain.currentProductDisplay != appDomain.defaultProductDisplay)
			{
				appDomain.setFirstAvailableProductDisplay();
				dispatcher(new ProductMessage(ProductMessage.CHANGE_PRODUCT_DISPLAY))
			}
		}

		
		
		//
		public function checkEditableItemPartiallyOutside():void
		{
			//if the editableText has no text, its bounds has no dimensions, so don't check
			//if the bounds of the item is inside/outside the design area as we are not able
			//to generate any bitmap
			var itemBounds:Rectangle = (appDomain.editableItem as EditableBase).getBounds(view);
			if(itemBounds.width == 0 || itemBounds.height == 0)
				return;
			
			//check the hitest against the 4 rectangles that can be build between the limits
			//of the holder and the valid design area
			var rectangles:Vector.<Rectangle> = new Vector.<Rectangle>(); 
			rectangles.push( new Rectangle(0, 0, view.designAreaHolder.width, view.designAreaRectangle.rect.y) );
			rectangles.push( new Rectangle(0, 0, view.designAreaRectangle.rect.x, view.designAreaHolder.height) );
			rectangles.push( new Rectangle(view.designAreaRectangle.rect.x + view.designAreaRectangle.rect.width, 0, view.designAreaHolder.width - (view.designAreaRectangle.rect.x + view.designAreaRectangle.rect.width), view.designAreaHolder.height) );
			rectangles.push( new Rectangle(0, view.designAreaRectangle.rect.y + view.designAreaRectangle.rect.height, view.designAreaHolder.width, view.designAreaHolder.height - (view.designAreaRectangle.rect.y + view.designAreaRectangle.rect.height)) );
			if(editableItemHitTest(rectangles))
			{
				showWarning(true);
			}
			else
			{
				//if the editable item is not hittesting the out sides of the valid design
				//area, check if it's position is completely outside from the ProductDesigner view.
				//That also means it is in an invalid position
				showWarning(isEditableItemOutside());
			}
		}
		
		
		
		/**************************************************************************************
		 * MESSAGES
		 *************************************************************************************/
		
		
		
		//
		[MessageHandler]
		public function handleProductMessage(productMessage:ProductMessage):void
		{
			switch(productMessage.type)
			{
				case ProductMessage.PRODUCT_SELECTED:
					//if the product is not the first load, the user has changed the product from the UI
					if(appDomain.bootstrapTaskGroup == null)
					{
						dirtyEditableItems = true;
						deselectEditableItem();
						dispatchEvent(new ProductDesignerEvent(ProductDesignerEvent.PRODUCT_SELECTED));
					}
					break;

				case ProductMessage.CHANGE_PRODUCT_DISPLAY:
					deselectEditableItem();
					dispatchEvent(new ProductDesignerEvent(ProductDesignerEvent.CHANGE_PRODUCT_DISPLAY, appDomain.editableDesigns));
					break;
				
				case ProductMessage.IMAGE_LOADED:
					addImage(productMessage.image, productMessage.imageFilename, productMessage.imageRemoveBackground);
					dispatcher(new ProductMessage(ProductMessage.UPDATE_PRICE));
					break;
				
				case ProductMessage.DESIGN_SELECTED:
					addDesign(productMessage.design, productMessage.designColor);
					dispatcher(new ProductMessage(ProductMessage.UPDATE_PRICE));
					break;
				
				case ProductMessage.INSERT_TEXT:
					addText(productMessage.textLayoutFormat);
					dispatcher(new ProductMessage(ProductMessage.UPDATE_PRICE));
					break;
				
				case ProductMessage.INSERT_TEXT_TEAM:	
					addTextTeam(productMessage.teamProductItemData);
					break;
				
				case ProductMessage.SHOW_TEXT_TEAM:
					selectTextTeam(productMessage.editableTextTeam);
					break;
				
				case ProductMessage.REMOVE_TEXT_TEAM:
					//an element has to be selected before its being removed
					selectTextTeam(productMessage.editableTextTeam);
					
					//removing an object starts in the view, so launch a message
					//so the view catches it and the object is removed
					dispatcher(new ProductMessage(ProductMessage.REMOVE_DESIGN));
					break;
				
				case ProductMessage.EDITABLE_ITEM_CHANGING:
					//an editable item is being translated, rotated or scaled
					//from the bounding box.
					checkEditableItemPartiallyOutside();
					break;
				
				case ProductMessage.EDITABLE_ITEM_TRANSFORMED:
					
					//an editable item has been changed. Check if its completely
					//outside of the design valid area, if so restore to its position
					//before the translation
					if(productMessage.transformation == Constants.TRANSLATION)
					{
						if(isEditableItemOutside())
						{
							boundingBox.undoTranslation();
							checkEditableItemPartiallyOutside();
						}
					}
					
					//for transformed texts, remove its selection
					if(appDomain.selectedEditableItemIsText)
					{
						(appDomain.editableItem as EditableTextBase).clearSelection();
					}
					break;
			}
		}
		
		
		
		//Receives the events launched from a subclass of an EditableTextBase instance when
		//the text of the instance is being changed
		[MessageHandler(selector="textChange")]
		public function handleTextChangeEditableTextMessage(editableTextMessage:EditableTextMessage):void
		{
			checkEditableItemPartiallyOutside();
		}
		
		
		
		/**************************************************************************************
		 * PRIVATE METHODS
		 *************************************************************************************/
		
		
		
		//
		private function createBoundingBox(editableDesign:IEditable, parentLayer:Group, draggable:Boolean = true):void
		{
			//remove any previous existing bounding box and create a new one
			removeBoundingBox();
			
			//create and add it to the context so it can send/receive parsley messages
			boundingBox = new BoundingBox(editableDesign, parentLayer, draggable);
			dynamicObjectBoundingBox = GlobalState.objects.getContext(this).addDynamicObject(boundingBox);
		}
		
		
		
		//
		private function removeBoundingBox():void
		{
			//remove any previous existing bounding box and create a new one
			if(boundingBox && boundingBox.parent && boundingBox.parent.contains(boundingBox))
				(boundingBox.parent as Group).removeElement(boundingBox);
			
			if(dynamicObjectBoundingBox)
				dynamicObjectBoundingBox.remove();
			
			dynamicObjectBoundingBox = null;
			boundingBox = null;
		}
		
		
		
		//HitTest detection using the bitmap of the EditableItem being used.
		//Explanation of the method BitmapData.hitTest at:
		//http://www.mikechambers.com/blog/2009/06/24/using-bitmapdata-hittest-for-collision-detection/
		//The hitTest works regardless of the contents or shape of the DisplayObjects. However, 
		//if either of the DisplayObjects have had any transformations applied to them (such as 
		//rotation), then the collision detection wont work correctly. In order to get it to work, 
		//you need to apply a Matrix when drawing the BitmapData to account for the transformation 
		//applied to one or both DisplayObjects
		private function editableItemHitTest(rectangles:Vector.<Rectangle>):Boolean
		{			
			//********* IMPORTANT:
			//The TextFlow implemented in an EditableTextBase gives a lot of problems when applying the hitTest function of its generated
			//bitmap. To have it working properly, the text has to be as selected. That makes appear the selection, and only then the 
			//hitTest works as expected. Later we have to deselect the text again.
			
			//UPDATE 2012/07/13:	Problem comes from trying to get the bitmap from the editableItem instance. Instead of that, the 
			//						IEditableTextBase instance mantains a bitmap version of its TextFlow. We use this bitmap.
			
			var result:Boolean = false;
			var editableItem:EditableBase = appDomain.editableItem as EditableBase;
			var itemBounds:Rectangle = editableItem.getBounds(view);
			var itemBitmapData:BitmapData = new BitmapData(itemBounds.width, itemBounds.height, true, 0);
			var itemOffset:Matrix = editableItem.transform.matrix.clone();
			itemOffset.tx = editableItem.x - itemBounds.x;
			itemOffset.ty = editableItem.y - itemBounds.y;
			itemBitmapData.draw(editableItem, itemOffset);

			var pointLeftTop:Point = new Point(itemBounds.x, itemBounds.y);
			
			if(editableItem is EditableTextBase)
			{
				(editableItem as EditableTextBase).showSnapShot(true);
			}
			
			//return true if there is a hitText with any of the rectangles
			for each(var rectangle:Rectangle in rectangles)
			{
				if(itemBitmapData.hitTest(pointLeftTop, 255, rectangle, rectangle.topLeft))
				{
					result = true;
				}
			}
			
			if(editableItem is EditableTextBase)
			{
				(editableItem as EditableTextBase).showSnapShot(false);
			}
			
			itemBitmapData.dispose();
			return result;
		}
		
		
		
		//Check if the selected editableItem is completely outside the design area
		private function isEditableItemOutside():Boolean
		{
			var rectangles:Vector.<Rectangle> = new Vector.<Rectangle>();
			rectangles.push(view.designAreaRectangle.rect.clone());
			return !editableItemHitTest(rectangles);
		}
		
		
		
		//Shows visual warnings when an editable item is outside the design area
		private function showWarning(state:Boolean):void
		{
			//(boundingBox.editableDesign as EditableBase).filters = (state)?	[new GlowFilter()]:[];
			(appDomain.editableItem as EditableBase).filters = (state)?	[new GlowFilter()]:[];
			
			//need to check if bounding box exists. Maybe we are checking all the existing 
			//items because the product has changed
			if(boundingBox)
			{
				boundingBox.showWarning = state;
			}
		}		
	}
}